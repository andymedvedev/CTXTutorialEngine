//
//  AppDelegate.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 21/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit
import CTXTutorialEngine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let engine = CTXTutorialEngine.shared
    let eventBus = CTXTutorialEventBus.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        engine.addTutorials(with: [MyEvent.self],
                            eventConfigMetaType: MyEventConfigMetatype.self) { error in
            if let error = error {
                print(error.errorDescription)
            }
        }
        
        let stepConfig = CTXTutorialStepConfig(text: "My Custom View Tutorial step",
                                               accessibilityIdentifier: "myCustomView")
        
        let viewsShownEventConfig = CTXTutorialViewsShownEventConfig(stepConfigs: [stepConfig])
        
        guard let viewsShownEvent = CTXTutorialViewsShownEvent(with: viewsShownEventConfig) else {fatalError("cannot create event")}
        
        let customTutorial = CTXTutorial(id: 100,
                                         name: "My Custom Tutorial",
                                         eventsChain: [MyEvent.launch, viewsShownEvent])
        
        engine.add(customTutorial) { error in
            if let error = error {
                print(error.errorDescription)
            }
        }
        
        engine.start()
        
        eventBus.push(MyEvent.launch)
        
        return true
    }
}

