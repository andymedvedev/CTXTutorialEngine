//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

final class CTXTutorialViewAvailabilityChecker {
    
    func isAvailable(_ view: UIView, inSafeArea: Bool = true) -> Bool {
        guard !view.isHidden
            && view.alpha != .zero
            && view.superview != nil
            && view.layer.animationKeys()?.isEmpty ?? true else {
            return false
        }
        
        let window = UIApplication.keyWindow()
        
        if let rootViewController = window?.rootViewController,
            let rootView = rootViewController.view,
            let presentationLayer = view.layer.presentation() {

            let viewFrame = presentationLayer.convert(presentationLayer.bounds, to: nil)
            
            let safeAreaInsets: UIEdgeInsets
            
            if inSafeArea {
                safeAreaInsets = rootView.safeAreaInsets
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
