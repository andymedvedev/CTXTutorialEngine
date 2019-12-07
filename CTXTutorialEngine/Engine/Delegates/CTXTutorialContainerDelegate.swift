//
//  CTXTutorialContainerDelegate.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 07.12.2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation
import UIKit

protocol CTXTutorialContainerDelegate: AnyObject {
    
    func containerDidEndShowTutorial(_ container: CTXTutorialContainerViewController)
    
    func containerDidShowTutorialStep(_ container: CTXTutorialContainerViewController,
                                      with stepInfo: CTXTutorialStepPresentationInfo)
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat?
    
    func tutorialOverlayColor() -> UIColor?
    
    func container(_ container: CTXTutorialContainerViewController,
                   hintViewForTutorialWith currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType?
}

extension CTXTutorialContainerDelegate {
    
    func containerDidEndShow(_ container: CTXTutorialContainerViewController, tutorial: CTXTutorial) {}
    
    func containerDidShowTutorialStep(_ container: CTXTutorialContainerViewController,
                                      with stepInfo: CTXTutorialStepPresentationInfo) {}
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat? {
        return nil
    }
    
    func tutorialOverlayColor() -> UIColor? {
        return nil
    }
    
    func container(_ container: CTXTutorialContainerViewController,
                   hintViewForTutorialWith currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType? {
        return nil
    }
}
