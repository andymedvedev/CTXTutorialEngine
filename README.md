# CTXTutorialEngine
> Show contextual hints or event tutorials for your views

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

![](header.png)

## Features

- [x] Engine can read configuration file for tutorials setup or you can add tutrials to engine manually.
- [x] You can add custom events that will be handled by engine
- [x] Can set polling interval

## Requirements

- iOS 11.0+
- Xcode 10.0+

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `YourLibrary` by adding it to your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!
pod 'CTXTutorialEngine'
```

## The engine is based on the following provisions:

- Engine uses `accessibilityIdentifier` of `UIView` to parse view hierarchy
- Engine uses sequence of events to trigger corresponding tutorial (hint). Last event always must be `CTXTutorialViewsShownEvent` with corresponding `accessibilityIdentifier`s for views that showing at the same time.
- Each step for `CTXTutorialViewsShownEvent` contains text that will be show to user via custom hint view.

## Usage example

Assuming that you want:
* show tutorial with three steps when all three views with `accessibilityIdentifier`s:
  - `redView`
  - `greenView`
  - `blueView`
  
  and show texts for them, for example:
  - `This view is red and its hot`
  - `This view is green like a grass`
  - `This view is looks like deep sea or sky`
  
  in that sequance.
  
Then you need to do following setup:
  
1. Add `MyHintView` class that conforms to `CTXTutorialHintView` protocol.

2. Add this code to your project somewhere:

``` swift
  import CTXTutorialEngine
  
  enum MyEvent: CTXTutorialEvent {
      
      case launch
      case unknown
      
      func compare(with event: CTXTutorialEvent) -> CTXTutorialEventComparingResult {
          if let event = event as? MyEvent {
              
              switch (self, event) {
              case (.launch, .launch):
                  return .equal
              case (.unknown, .unknown):
                  return .equal
              default:
                  return .different
              }
          }
          
          return .different
      }
      
      init?(with config: CTXTutorialEventConfig) {
          guard let config = config as? MyEventConfig else { return nil }
          
          switch config.event {
          case "launch": self = .launch
          default: self = .unknown
          }
      }
      
      init(rawValue: String) {
          switch rawValue {
          case "launch": self = .launch
          default: self = .unknown
          }
      }
  }
 ```
 
 then
 
``` swift
  import CTXTutorialEngine
  
  struct MyEventConfig: CTXTutorialEventConfig {
      let event: String
  }
 ```
 
 then
 
``` swift
 final class MyEventConfigMetatype: CTXTutorialEventConfigMetaType {
     
     enum ConfigType: String{
         case myEvent = "MyEvent"
     }
     
     override var type: Decodable.Type {
         
         let configType = ConfigType(rawValue: rawValue)
         
         switch configType {
         case .myEvent?:
             return MyEventConfig.self
         default:
             return super.type
         }
     }
 }
 ```
 
 and at `AppDelegate.swift` make code to look like this:
 
``` swift
 import UIKit
 import CTXTutorialEngine
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

     let engine = CTXTutorialEngine.shared
     let eventBus = CTXTutorialEventBus.shared
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

         window = UIWindow(frame: UIScreen.main.bounds)
         
         engine.addTutorials(with: [MyEvent.self],
                             eventConfigMetaType: MyEventConfigMetatype.self) { error in
             if let error = error {
                 print(error.errorDescription)
             }
         }
         
         eventBus.push(MyEvent.launch)
         
         return true
     }
 ```

3. Add `CTXTutorialConfig.json` to your project with content:

```
{
    "tutorials": [
        {
            "id": 0,
            "name": "RGBTutorial",
            "events": [
                {
                    "MyEvent": {
                        "event": "launch"
                    }
                },
                
                {
                    "CTXTutorialViewsShownEvent": {
                        "event": {
                            "steps": [
                                {
                                    "text": "This view is red and its hot",
                                    "accessibilityIdentifier": "redView"
                                },
                                
                                {
                                    "text": "This view is green like a grass",
                                    "accessibilityIdentifier": "greenView"
                                },
                                
                                {
                                    "text": "This view is looks like deep sea or sky",
                                    "accessibilityIdentifier": "blueView"
                                }
                            ]
                        }
                    }
                }
            ]
        }
    ]
}
```

and your ViewCotroller's code should looks like this:

``` swift
import CTXTutorialEngine

class ViewController: UIViewController {

    private let redView: UIView = ...
    private let greenView: UIView = ...
    private let blueView: UIView = ...

    private let engine = CTXTutorialEngine.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redView.backgroundColor = .red
        greenView.backgroundColor = .green
        blueView.backgroundColor = .blue
        
        redView.accessibilityIdentifier = "redView"
        greenView.accessibilityIdentifier = "greenView"
        blueView.accessibilityIdentifier = "blueView"
        
        view.addSubview(redView)
        view.addSubview(greenView)
        view.addSubview(blueView)
        
        engine.observe(self, contentType: .dynamic)
        engine.delegate = self
        engine.start()
    }
}

extension ViewController: CTXTutorialEngineDelegate {

    func engine(_ engine: CTXTutorialEngine,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel,
                isHavePreviousStep: Bool,
                isHaveNextStep: Bool) -> CTXTutorialHintView? {
        
        let hintView = MyHintView(stepModel: currentStepModel,
                                  isHavePreviousStep: isHavePreviousStep,
                                  isHaveNextStep: isHaveNextStep)
        // make additional setup for hintView
        
        return hintView
    }
    
    func engineDidEndShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial) {
        
        setNeedsStatusBarAppearanceUpdate()
        
        engine.unobserve(self)
        engine.stop()
    }
    
    func preferredTutorialStatusBarStyle() -> UIStatusBarStyle? {
        return .lightContent
    }
}
```

For more details see example.

## With carefull

If you want to rename `MyEvent` class with different one then replace all occurences of this string in your project.

## Contribute

We would love you for the contribution to **CTXTutorialEngine**, check the ``LICENSE`` file for more info.

## Meta

Andrey Medvedev – andertsk@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

[swift-image]:https://img.shields.io/badge/swift-5.2-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
