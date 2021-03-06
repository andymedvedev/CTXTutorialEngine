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
        
        engine.addTutorials { error in
            if let error = error {
                print(error.errorDescription)
            }
        }
        
        let stepConfig = CTXTutorialStepConfig(text: "Welcome to library!",
                                               accessibilityIdentifier: "libraryNameContainer")
        
        let viewsShownEventConfig = CTXTutorialViewsShownEventConfig(stepConfigs: [stepConfig])
        
        guard let viewsShownEvent = CTXTutorialViewsShownEvent(with: viewsShownEventConfig) else {fatalError("cannot create event")}
        
        let customTutorial = CTXTutorial(id: "100",
                                         name: "Welcome tutorial",
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
        let appearance = engine.appearance
        appearance.gradientLocations = [0.0, 0.3, 0.6, 1.0]
        appearance.anchorColor = UIColor(named: "gradientOuter")
        appearance.anchorSize = CGSize(width: 16, height: 16)
        appearance.font = .systemFont(ofSize: 18)
        appearance.backButtonTintColor = UIColor(named: "yellow")
        appearance.nextButtonTintColor = UIColor(named: "yellow")
        appearance.closeButtonTintColor = UIColor(named: "yellow")
        appearance.onAppear = {
            hintView in
            
            let deltas: [Double] = [0.0, 0.1, 0.0, -0.1, 0.0, 0.05, 0.0, -0.05, 0.0]
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.duration = 0.5
            animation.values = deltas.map { 1.0 + $0 }
            hintView.layer.add(animation, forKey: "spring")
        }
    }
}

