//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public class CTXTutorialRouterImpl: CTXTutorialRouter {
    
    weak var tutorialViewController: CTXTutorialContainerViewController?
    
    private var window: UIWindow?
    private var appWindow: UIWindow?
    private var hideCompletion: (() -> Void)?
    
    func showTutorial(startHandler: @escaping () -> (),
                      hideCompletion: @escaping () -> Void) {
        guard let rootVC = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController,
            let tutorialVC = tutorialViewController else {
            print("CTXTutorianEngine: can't find app keyWindow")
            return
        }
        
        self.hideCompletion = hideCompletion
        
        tutorialVC.view.frame = rootVC.view.frame
        tutorialVC.view.layoutIfNeeded()
        rootVC.addChild(tutorialVC)
        rootVC.view.addSubview(tutorialVC.view)
        
        tutorialVC.didMove(toParent: rootVC)
        
        startHandler()
    }
    
    func hideTutorial() {
        tutorialViewController?.willMove(toParent: nil)
        tutorialViewController?.view.removeFromSuperview()
        tutorialViewController?.removeFromParent()

        hideCompletion?()
        UIApplication.getTopViewController()?.setNeedsStatusBarAppearanceUpdate()
    }
}
