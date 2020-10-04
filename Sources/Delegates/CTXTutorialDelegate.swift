//
//  CTXTutorialDelegate.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 07.12.2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

protocol CTXTutorialDelegate: AnyObject {
    
    func tutorialShouldProcessEvents(_ tutorial: CTXTutorial) -> Bool
    func tutorialWillShow(_ tutorial: CTXTutorial)
    func tutorialDidEndShow(_ tutorial: CTXTutorial)
    func tutorialWillShowTutorialStep(_ tutorial: CTXTutorial,
                                      with stepInfo: CTXTutorialStepPresentationInfo)
    func tutorialDidShowTutorialStep(_ tutorial: CTXTutorial,
                                     with stepInfo: CTXTutorialStepPresentationInfo)
    func tutorialHintView(_ tutorial: CTXTutorial,
                          with currentStepModel: CTXTutorialStepModel,
                          isHavePreviousStep: Bool,
                          isHaveNextStep: Bool) -> CTXTutorialHintView?
}
