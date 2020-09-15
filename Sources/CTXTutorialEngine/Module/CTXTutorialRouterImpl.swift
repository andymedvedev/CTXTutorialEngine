//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public class CTXTutorialRouterImpl: CTXTutorialRouter {
    
    weak var rootViewController: CTXTutorialContainerViewController?
    
    private var window: UIWindow?
    private var appWindow: UIWindow?
    private var hideCompletion: (() -> Void)?
    
    func showTutorial(startHandler: @escaping () -> (),
                      hideCompletion: @escaping () -> Void) {
        
        self.hideCompletion = hideCompletion
        
        appWindow  = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 13, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
            }
        }
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
