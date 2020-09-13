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
    
    func pause() {
        
        let pausedTime: CFTimeInterval = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        
        self.layer.speed = 0.0
        self.layer.timeOffset = pausedTime
        
        self.isUserInteractionEnabled = false
    }
    
    func resume() {
        
        let pausedTime: CFTimeInterval = self.layer.timeOffset
        
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        
        let timeSincePause: CFTimeInterval = self.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        
        self.layer.beginTime = timeSincePause
        
        self.isUserInteractionEnabled = true
    }
}
