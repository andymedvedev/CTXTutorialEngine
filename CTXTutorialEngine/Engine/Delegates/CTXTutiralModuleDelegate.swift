//
//  CTXTutiralModuleDelegate.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 07.12.2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation
import UIKit

protocol CTXTutorialModuleDelegate: AnyObject {
    
    func moduleDidEndShow(_ module: CTXTutorialModule, tutorial: CTXTutorial)
    
    func moduleDidShowTutorialStep(_ module: CTXTutorialModule,
                                   tutorial: CTXTutorial,
                                   with stepInfo: CTXTutorialStepPresentationInfo)
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat?
    
    func tutorialOverlayColor() -> UIColor?
    
    func module(_ module: CTXTutorialModule,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType?
}

extension CTXTutorialModuleDelegate {
    
    func moduleDidEndShow(_ module: CTXTutorialModule, tutorial: CTXTutorial) {}
    
    func moduleDidShowTutorialStep(_ module: CTXTutorialModule,
                                   tutorial: CTXTutorial,
                                   with stepInfo: CTXTutorialStepPresentationInfo) {}
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat? {
        return nil
    }
    
    func tutorialOverlayColor() -> UIColor? {
        return nil
    }
    
    func module(_ module: CTXTutorialModule,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType? {
        return nil
    }
}
