//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public protocol CTXTutorialEngineDelegate: AnyObject {
    
    func engineWillShow(tutorial: CTXTutorial)
    
    func engineDidShowTutorialStep(tutorial: CTXTutorial, with stepInfo: CTXTutorialStepPresentationInfo)
    
    func engineDidEndShow(tutorial: CTXTutorial)
    
    func hintViewFor(for tutorial: CTXTutorial, with currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType?
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat
    
    func selectedViewsToProcess(in accessibilityViewsDict: [String: [[UIView]]]) -> [UIView]
}

public extension CTXTutorialEngineDelegate {
    
    func engineWillShow(tutorial: CTXTutorial) {}
    
    func engineDidShowTutorialStep(tutorial: CTXTutorial, with stepInfo: CTXTutorialStepPresentationInfo) {}
    
    func engineDidEndShow(tutorial: CTXTutorial) {}
    
    func hintViewFor(for tutorial: CTXTutorial, with currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType? {
        return nil
    }
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat {
        return 20
    }
    
    func selectedViewsToProcess(in accessibilityViewsDict: [String : [[UIView]]]) -> [UIView] {
        var views = [UIView]()
        
        accessibilityViewsDict.forEach { (_, viewsArr) in
            views.append(viewsArr[0][0])
        }
        
        return views
    }
}
