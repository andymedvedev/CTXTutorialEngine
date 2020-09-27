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
    func containerWillShowTutorialStep(_ container: CTXTutorialContainerViewController,
                                       with stepInfo: CTXTutorialStepPresentationInfo)
    func containerDidShowTutorialStep(_ container: CTXTutorialContainerViewController,
                                      with stepInfo: CTXTutorialStepPresentationInfo)
    func tutorialOverlayColor() -> UIColor?
    func container(_ container: CTXTutorialContainerViewController,
                   hintViewForTutorialWith currentStepViews: CTXTutorialStepModel,
                   isHavePreviousStep: Bool,
                   isHaveNextStep: Bool) -> CTXTutorialHintView?
}
