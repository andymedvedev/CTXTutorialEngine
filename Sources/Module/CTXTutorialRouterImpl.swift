//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public class CTXTutorialRouterImpl: CTXTutorialRouter {
    
    weak var tutorialViewController: CTXTutorialContainerViewController?
    private var topViewController: CTXTutorialShowing?
    private var hideCompletion: VoidClosure?
    
    func showTutorial(startHandler: @escaping VoidClosure,
                      hideCompletion: @escaping VoidClosure) {
        guard let topVC = UIApplication.topViewController() as? CTXTutorialShowing,
            let tutorialVC = tutorialViewController else {
            print("CTXTutorianEngine: can't find app keyWindow")
            return
        }
        
        self.topViewController = topVC
        self.hideCompletion = hideCompletion
        
        tutorialVC.view.frame = topVC.view.frame
        tutorialVC.view.layoutIfNeeded()
        topVC.addChild(tutorialVC)
        topVC.view.addSubview(tutorialVC.view)
        tutorialVC.didMove(toParent: topVC)
        topVC.isTutorialShowing = true
        topVC.setNeedsStatusBarAppearanceUpdate()
        
        startHandler()
    }
    
    func hideTutorial() {
        topViewController?.isTutorialShowing = false
        topViewController?.setNeedsStatusBarAppearanceUpdate()
        
        tutorialViewController?.willMove(toParent: nil)
        tutorialViewController?.view.removeFromSuperview()
        tutorialViewController?.removeFromParent()

        hideCompletion?()
    }
}
