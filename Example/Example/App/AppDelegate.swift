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
                                         eventsChain: [viewsShownEvent])
        
        engine.add(customTutorial) { error in
            if let error = error {
                print(error.errorDescription)
            }
        }
        
        configureDefaultHintView()
        engine.start()
        
        return true
    }
    
    private func configureDefaultHintView() {
        let config = engine.defaultHintViewConfig
        config.anchorSize = CGSize(width: 16, height: 16)
        config.anchorColor = .green
        config.onAppear = {
            hintView in
            
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.duration = 0.5
            animation.values = [
                NSValue(cgPoint: CGPoint(x: 1, y: 1)),
                NSValue(cgPoint: CGPoint(x: 1.1, y: 1.1)),
                NSValue(cgPoint: CGPoint(x: 1, y: 1)),
                NSValue(cgPoint: CGPoint(x: 0.9, y: 0.9)),
                NSValue(cgPoint: CGPoint(x: 1, y: 1)),
                NSValue(cgPoint: CGPoint(x: 1.05, y: 1.05)),
                NSValue(cgPoint: CGPoint(x: 1, y: 1)),
                NSValue(cgPoint: CGPoint(x: 0.95, y: 0.95)),
                NSValue(cgPoint: CGPoint(x: 1, y: 1)),
            ]
            hintView.layer.add(animation, forKey: "spring")
        }
    }
}

