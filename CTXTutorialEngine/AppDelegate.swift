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
        
        self.engine.setup(eventTypes: [MyEvent.self],
                                       eventConfigMetaType: MyEventConfigMetatype.self)
        
        
        let stepConfig = CTXTutorialStepConfig(text: "My Custom View Step",
                                               accessibilityIdentifiers: ["myCustomView"])
        
        let stepsEventConfig = CTXTutorialViewsShownEventStepsConfig(stepConfigs: [stepConfig])
        
        let viewsShownEventConfig = CTXTutorialViewsShownEventConfig(eventConfig: stepsEventConfig)
        
        guard let viewsShownEvent = CTXTutorialViewsShownEvent(with: viewsShownEventConfig) else {fatalError("cannot create event")}
        
        let customTutorial = CTXTutorial(id: 100,
                                         name: "My Custom Tutorial",
                                         eventsChain: [MyEvent.launch, viewsShownEvent])
        
        self.engine.add(customTutorial)
        CTXTutorialEventBus.shared.push(MyEvent.launch)
        
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

