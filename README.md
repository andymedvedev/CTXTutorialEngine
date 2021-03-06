CTXTutorialEngine
========

[![Travis CI](https://travis-ci.org/andymedvedev/CTXTutorialEngine.svg?branch=master)](https://travis-ci.org/andymedvedev/CTXTutorialEngine)
[![Swift Version](https://img.shields.io/badge/Swift-5.2-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/cocoapods/l/CTXTutorialEngine.svg?style=flat)](http://cocoapods.org/pods/CTXTutorialEngine)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://img.shields.io/badge/SPM-compatible-brightgreen)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CTXTutorialEngine.svg)](https://img.shields.io/cocoapods/v/CTXTutorialEngine.svg)
[![Platform](https://img.shields.io/cocoapods/p/CTXTutorialEngine.svg?style=flat)](http://cocoapods.org/pods/CTXTutorialEngine)

CTXTutorialEngine is library provides ability to display hints or even tutorials to onboard users into your awesome app.

![](https://media.giphy.com/media/qlazlEQ03fsv3z4nLU/giphy.gif)

## Features

- [x] Engine can read configuration file for tutorials setup or you can add tutrials to engine manually.
- [x] Ability to add chain of custom events that will be handled by engine to trigger tutorial.
- [x] Ability to set interval of view hierarchy polling.
- [x] Handling shape layers along as well as cornered views.
- [x] Automatically store shown tutorial states + ability to reset all tutorials shown states.
- [x] Forward touches to hinted views.
- [x] Ability to show custom hint views.

## Requirements

- iOS 11.0+
- Xcode 10.0+

## Installation

#### CocoaPods

```ruby
platform :ios, '11.0'
use_frameworks!

pod 'CTXTutorialEngine', '~> 3.0.0'
```

#### Carthage

In your `Cartfile`, add
```
github "andymedvedev/CTXTutorialEngine" ~> 3.0.0
```

#### Swift Package Manager

```swift
dependencies: [
.package(url: "https://github.com/andymedvedev/CTXTutorialEngine.git", .upToNextMajor(from: "3.0.0")))
]
```

don't forget to do `import CTXTutorialEngine`

## Quick start
You want to show hint view for some UIView.

1. Add to `AppDelegate's` `application(_:didFinishLaunchingWithOptions:)` following code:
```swift
CTXTutorialEngine.shared.addTutorials { error in
    if let error = error {
        //handle error
    }
}
    
CTXTutorialEngine.shared.start()
```
2. Add `CTXTutorialConfig.json` to your project with content:
```
{
    "tutorials": [
        {
            "id": "0",
            "name": "My view tutorial",
            "events": [
                {
                    "CTXTutorialViewsShownEvent": {
                        "event": {
                            "steps": [
                                {
                                    "text": "Hello world!",
                                    "accessibilityIdentifier": "myView"
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

And your ViewCotroller's code should looks like this:

``` swift
import CTXTutorialEngine

class ViewController: CTXTutorialViewController {

    private let myView: UIView = ...
    private let engine = CTXTutorialEngine.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myView.accessibilityIdentifier = "myView"

        view.addSubview(myView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        engine.observe(self, contentType: .dynamic)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        engine.unobserve(self)
    }
}
```

3. Default Hint View will appear and it will be plain white with black text and gray buttons,
but if you wan to alter appearance you should set parameters of `CTXTutorialEngine.shared.appearance`.
You can do it at app start or on each step of your tutorial by conforming your `ViewController` to `CTXTutorialEngineDelegate`:
```swift
extension ViewController: CTXTutorialEngineDelegate {

    func engineWillShowTutorialStep(_ engine: CTXTutorialEngine, tutorial: CTXTutorial, with stepInfo: CTXTutorialStepPresentationInfo) {
        let appearance = engine.appearance
        ...
    }
}
```

and don't forget to set `engine.delegate = self` in `viewDidAppear(_:)`


## Advanced setup
TODO

## Contribute

We would love you for the contribution to **CTXTutorialEngine**, check the ``LICENSE`` file for more info.

## Special thanks to:

Eugene Cherkasov (https://github.com/johnnie-che)

## License

MIT license. See the [LICENSE file](LICENSE.txt) for details.
