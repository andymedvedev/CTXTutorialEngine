//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

final class CTXTutorialRouterImpl: CTXTutorialRouter {
    
    weak var rootViewController: CTXTutorialContainerViewController?
    
    private var window: UIWindow?
    private var appWindow: UIWindow?
    private var hideCompletion: (() -> Void)?
    
    func showTutorial(startHandler: @escaping () -> (),
                      hideCompletion: @escaping () -> Void) {
        
        self.hideCompletion = hideCompletion
        
        appWindow = UIApplication.shared.keyWindow
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = self.rootViewController
        window?.windowLevel = .alert
        window?.makeKeyAndVisible()
        
        startHandler()
    }
    
    func hideTutorial() {
        window?.windowLevel = .normal
        appWindow?.makeKeyAndVisible()
        hideCompletion?()
    }
}
