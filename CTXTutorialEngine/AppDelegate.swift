//
//  AppDelegate.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 21/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let engine = CTXTutorialEngine.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.engine.addTutorials(withEventTypes: [MyEvent.self],
                                 eventConfigMetaType: MyEventConfigMetatype.self) { error in
            if let error = error {
                print(error.errorDescription)
            }
        }
        
        
        let stepConfig = CTXTutorialStepConfig(text: "My Custom View Tutorial step",
                                               accessibilityIdentifiers: ["myCustomView"])
        
        let viewsShownEventConfig = CTXTutorialViewsShownEventConfig(stepConfigs: [stepConfig])
        
        guard let viewsShownEvent = CTXTutorialViewsShownEvent(with: viewsShownEventConfig) else {fatalError("cannot create event")}
        
        let customTutorial = CTXTutorial(id: 100,
                                         name: "My Custom Tutorial",
                                         eventsChain: [MyEvent.launch, viewsShownEvent])
        
        self.engine.add(customTutorial) { error in
            if let error = error {
                print(error.errorDescription)
            }
        }
        CTXTutorialEventBus.shared.push(MyEvent.launch)
        
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

