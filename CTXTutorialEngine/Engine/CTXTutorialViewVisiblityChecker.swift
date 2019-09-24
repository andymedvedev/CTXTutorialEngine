//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

final class CTXTutorialViewVisibilityChecker {
    
    func isVisible(_ view: UIView, inSafeArea: Bool = true) -> Bool {
        
        if view.isHidden || view.superview == nil {
            return false
        }
        
        let window = UIApplication.shared.keyWindow
        
        if let rootViewController = window?.rootViewController,
            let rootView = rootViewController.view {

            let viewFrame = view.convert(view.bounds, to: nil)
            
            let safeAreaInsets: UIEdgeInsets
            
            if inSafeArea {
                if #available(iOS 11.0, *) {
                    safeAreaInsets = rootView.safeAreaInsets
                } else {
                    safeAreaInsets = UIEdgeInsets(top: rootViewController.topLayoutGuide.length,
                                                  left: 0,
                                                  bottom: rootViewController.topLayoutGuide.length,
                                                  right: 0)
                }
            } else {
                safeAreaInsets = .zero
            }
            
            let rootFrame = CGRect(x: safeAreaInsets.left,
                                   y: safeAreaInsets.top,
                                   width: rootView.bounds.width - safeAreaInsets.left - safeAreaInsets.right,
                                   height: rootView.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom)
            
            
            return rootFrame.contains(viewFrame) && view.isVisibleInAllSuperviews()
        }
        
        return false
    }
}
