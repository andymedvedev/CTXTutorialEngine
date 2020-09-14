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
        
        if #available(iOS 13, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let windowContainable = windowScene.delegate as? CTXTutorialWindowContainable {
                appWindow = windowContainable.window
                window = UIWindow(windowScene: windowScene)
            } else {
                appWindow  = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
                window = UIWindow(frame: UIScreen.main.bounds)
            }
        } else {
            appWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            window = UIWindow(frame: UIScreen.main.bounds)
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
