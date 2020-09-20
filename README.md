CTXTutorialEngine
========

[![Swift Version](https://img.shields.io/badge/Swift-4.2--5.2-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/cocoapods/l/CTXTurorial.svg?style=flat)](http://cocoapods.org/pods/CTXTutorialEngine)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CTXTutorialEngine.svg)](https://img.shields.io/cocoapods/v/CTXTutorialEngine.svg)
[![Platform](https://img.shields.io/cocoapods/p/CTXTutorialEngine.svg?style=flat)](http://cocoapods.org/pods/CTXTutorialEngine)

CTXTutorialEngine is library provides ability to display hints or even tutorials to onboard users into your awesome app.

![](https://media.giphy.com/media/vSQarjdvkOmVGRjNTB/giphy.gif)

## Features

- [x] Engine can read configuration file for tutorials setup or you can add tutrials to engine manually.
- [x] Ability to add custom events that will be handled by engine.
- [x] Ability to set interval of view hierarchy polling.

## Requirements

- iOS 11.0+
- Xcode 10.0+

## Installation

#### CocoaPods

```ruby
platform :ios, '11.0'
use_frameworks!

pod 'CTXTutorialEngine', '~> 1.0.0'
```

## The engine is based on the following provisions:

- Engine uses `accessibilityIdentifier` of `UIView` to parse view hierarchy
- Engine uses sequence of events to trigger corresponding tutorial (hint). Last event always must be `CTXTutorialViewsShownEvent` with corresponding `accessibilityIdentifier`s for views that showing at the same time.
- Each step for `CTXTutorialViewsShownEvent` contains text that will be shown to user via custom hint view.

## Usage example

Assuming that you want to:
* show tutorial with three steps when all three views with `accessibilityIdentifier`s:
  - `redView`
  - `greenView`
  - `blueView`
  
  and show texts for them, for example:
  - `This view is red and its hot`
  - `This view is green like a grass`
  - `This view is looks like deep sea or sky`
  
  only in that sequance.
  
Then you need to do following setup:
  
1. Add `MyHintView` class that conforms to `CTXTutorialHintView` protocol.

2. Add this code to your project somewhere,
where you define your events that engine will handle.

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

 then add
 
``` swift
import CTXTutorialEngine
  
struct MyEventConfig: CTXTutorialEventConfig {
    let event: String
}
 ```
 
then add
 
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
 
 this is special meta class for your events.
 
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
        
        engine.start() 
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

In this config file we have one custom event from class `MyEvent`: `launch`
and one predefined event `CTXTutorialViewsShownEvent`.
This config describes that when `launch` event occurs and then three views with corresponding `accessiblityIdentifier`s will shown on screen then show tutorial.

And your ViewCotroller's code should looks like this:

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        engine.observe(self, contentType: .dynamic)
        engine.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        engine.unobserve(self)
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
        //some cleanup if needed
    }
    
    func preferredTutorialStatusBarStyle() -> UIStatusBarStyle? {
        return .lightContent
    }
}
```

For more details see example.

## Note

If you are using `SceneDelegate` then conform it to `CTXTutorialWindowContainable`, because engine needs to save current `keyWindow`.

## With carefull

If you want to rename `MyEvent` class with different one then replace all occurences of this string in your project.

## Contribute

We would love you for the contribution to **CTXTutorialEngine**, check the ``LICENSE`` file for more info.

## Special thanks to:

Eugene Cherkasov (https://github.com/johnnie-che)

## License

MIT license. See the [LICENSE file](LICENSE.txt) for details.
