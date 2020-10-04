//
//  UIApplicationExtension.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 26/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.keyWindow()?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
    class func keyWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
}
