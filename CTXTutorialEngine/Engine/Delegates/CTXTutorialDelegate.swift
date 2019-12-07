//
//  CTXTutorialDelegate.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 07.12.2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

protocol CTXTutorialDelegate: AnyObject {
    func tutorialWillShow(_ tutorial: CTXTutorial)
    
    func tutorialDidEndShow(_ tutorial: CTXTutorial)
    
    func tutorialDidShowTutorialStep(_ tutorial: CTXTutorial,
                                     with stepInfo: CTXTutorialStepPresentationInfo)
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat?
    
    func tutorialOverlayColor() -> UIColor?
    
    func tutorialHintView(_ tutorial: CTXTutorial,
                          with currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType?
}

extension CTXTutorialDelegate {
    func tutorialWillShow(_ tutorial: CTXTutorial) {}
    
    func tutorialDidEndShow(_ tutorial: CTXTutorial) {}
    
    func tutorialDidShowTutorialStep(_ tutorial: CTXTutorial,
                                     with stepInfo: CTXTutorialStepPresentationInfo) {}
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat? {
        return nil
    }
    
    func tutorialOverlayColor() -> UIColor? {
        return nil
    }
    
    func tutorialHintView(_ tutorial: CTXTutorial,
                          with currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType? {
        return nil
    }
}
