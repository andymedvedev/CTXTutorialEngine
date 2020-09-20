//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

extension UIView {
    
    func accessibilityViews() -> [UIView] {
        
        guard !self.isHidden && (self.alpha != 0)  else { return [] }
        
        var views = [UIView]()
        
        self.subviews.forEach { subview in
            
            if subview.accessibilityIdentifier != nil {
                views.append(subview)
            } else {
                views.append(contentsOf: subview.accessibilityViews())
            }
        }
        
        return views
    }
    
    func isVisibleInAllSuperviews() -> Bool {
        
        var superview = self.superview
        
        while superview != nil {
            
            let convertedFrame = self.convert(self.bounds, to: superview)
            
            if superview?.bounds.contains(convertedFrame) == false {
                return false
            }
            
            superview = superview?.superview
        }
        
        return true
    }
}
