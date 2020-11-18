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
        guard let topVC = UIApplication.topViewController() as? CTXTutorialShowing else {
            print("CTXTutorianEngine: can't cast top view controller to CTXTutorialShowing, no tutorial will show")
            return
        }
        
        guard let tutorialVC = tutorialViewController else {
            return
        }
        
        self.topViewController = topVC
        self.hideCompletion = hideCompletion
        
        let window = UIApplication.keyWindow()
        window?.addSubview(tutorialVC.view)
        tutorialVC.view.frame = UIScreen.main.bounds
        
        topVC.isTutorialShowing = true
        topVC.view.layer.pause()
        topVC.setNeedsStatusBarAppearanceUpdate()
        topVC.presentationController?.presentedView?.gestureRecognizers?.forEach { $0.isEnabled = false }
        
        startHandler()
    }
    
    func hideTutorial() {
        topViewController?.isTutorialShowing = false
        topViewController?.setNeedsStatusBarAppearanceUpdate()
        topViewController?.presentationController?.presentedView?.gestureRecognizers?.forEach { $0.isEnabled = true }
        topViewController?.view.layer.resume()
        
        let window = UIApplication.keyWindow()
        window?.subviews.first { $0 === tutorialViewController?.view }?.removeFromSuperview()
        
        hideCompletion?()
    }
    

}
