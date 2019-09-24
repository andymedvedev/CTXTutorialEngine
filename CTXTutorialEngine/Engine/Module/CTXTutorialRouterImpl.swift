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
        self.appWindow = UIApplication.shared.keyWindow
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.rootViewController
        self.window?.windowLevel = .alert
        self.window?.makeKeyAndVisible()
        startHandler()
    }
    
    func hideTutorial() {
        self.window?.windowLevel = .normal
        self.appWindow?.makeKeyAndVisible()
        self.hideCompletion?()
    }
}
