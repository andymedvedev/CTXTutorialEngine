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
    
    func moduleDidEndShowTutorial(_ module: CTXTutorialModule)
    
    func moduleDidShowTutorialStep(_ module: CTXTutorialModule,
                                   with stepInfo: CTXTutorialStepPresentationInfo)
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat?
    
    func preferredStatusBarStyle() -> UIStatusBarStyle?
    
    func tutorialOverlayColor() -> UIColor?
    
    func module(_ module: CTXTutorialModule,
                hintViewForTutorialWith currentStepModel: CTXTutorialStepModel,
                previousStepHandler: VoidClosure?,
                nextStepHandler: VoidClosure?,
                closehandler: VoidClosure?) -> UIView?
}
