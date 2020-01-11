//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public protocol CTXTutorialEngineDelegate: AnyObject {
    
    func engineWillShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial)
    
    func engineDidEndShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial)
    
    func engineDidShowTutorialStep(_ engine: CTXTutorialEngine,
                                   tutorial: CTXTutorial,
                                   with stepInfo: CTXTutorialStepPresentationInfo)
    
    func engine(_ engine: CTXTutorialEngine,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel,
                previousStepHandler: VoidClosure?,
                nextStepHandler: VoidClosure?,
                closehandler: VoidClosure?) -> UIView?

    func preferredStatusBarStyle() -> UIStatusBarStyle?
    
    func tutorialOverlayColor() -> UIColor?
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat?
    
    func selectedViewsToProcess(in accessibilityViewsDict: [String: [[UIView]]]) -> [UIView]
}

public extension CTXTutorialEngineDelegate {
    
    func engineWillShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial) {}
    
    func engineDidEndShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial) {}
    
    func engineDidShowTutorialStep(_ engine: CTXTutorialEngine, tutorial: CTXTutorial, with stepInfo: CTXTutorialStepPresentationInfo) {}
    
    func engine(_ engine: CTXTutorialEngine,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel,
                previousStepHandler: VoidClosure?,
                nextStepHandler: VoidClosure?,
                closehandler: VoidClosure?) -> UIView? {
        return nil
    }
    
    func preferredStatusBarStyle() -> UIStatusBarStyle? {
        return nil
    }
    
    func tutorialOverlayColor() -> UIColor? {
        return nil
    }
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat? {
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
