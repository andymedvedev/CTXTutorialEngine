//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public protocol CTXTutorialEngineDelegate: AnyObject {
    
    func engineWillShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial)
    func engineDidEndShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial)
    func engineWillShowTutorialStep(_ engine: CTXTutorialEngine,
                                    tutorial: CTXTutorial,
                                    with stepInfo: CTXTutorialStepPresentationInfo)
    func engineDidShowTutorialStep(_ engine: CTXTutorialEngine,
                                   tutorial: CTXTutorial,
                                   with stepInfo: CTXTutorialStepPresentationInfo)
    func engine(_ engine: CTXTutorialEngine,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel,
                isHavePreviousStep: Bool,
                isHaveNextStep: Bool) -> CTXTutorialHintView?
    func selectedViewsToProcess(in accessibilityViewsDict: [String: [[UIView]]]) -> [UIView]
}

public extension CTXTutorialEngineDelegate {
    
    func engineWillShow(_ engien: CTXTutorialEngine, tutorial: CTXTutorial) {
    }
    
    func engineDidEndShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial) {
    }
    
    func engineWillShowTutorialStep(_ engine: CTXTutorialEngine, tutorial: CTXTutorial, with stepInfo: CTXTutorialStepPresentationInfo) {
    }
    
    func engineDidShowTutorialStep(_ engine: CTXTutorialEngine, tutorial: CTXTutorial, with stepInfo: CTXTutorialStepPresentationInfo) {
    }
    
    func engine(_ engine: CTXTutorialEngine,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel,
                isHavePreviousStep: Bool,
                isHaveNextStep: Bool) -> CTXTutorialHintView? {
        return nil
    }
    
    func selectedViewsToProcess(in accessibilityViewsDict: [String : [[UIView]]]) -> [UIView] {
        var views = [UIView]()
        
        accessibilityViewsDict.forEach { (_, viewsArr) in
            views.append(viewsArr[0][0])
        }
        
        return views
    }
}
