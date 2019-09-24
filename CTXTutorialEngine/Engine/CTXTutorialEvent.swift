//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public enum CTXTutorialEventComparingResult {
    case equal
    case mutuallyExclusive
    case different
}

public protocol CTXTutorialEvent {
    
    func compare(with event: CTXTutorialEvent) -> CTXTutorialEventComparingResult
    func compareViews(_ lhs: [UIView], _ rhs: [UIView]) -> CTXTutorialEventComparingResult
    
    init(rawValue: String)
}

public final class CTXTutorialViewsShownEvent: CTXTutorialEvent {

    let configs: [CTXTutorialItemStep]
    let views: [UIView]
    
    init(with configs: [CTXTutorialItemStep] = []) {
        
        self.configs = configs
        
        self.views = configs.map{ config -> [UIView] in
            
            let views = config.accessibilityIdentifiers.map { id -> UIView in
                let view = UIView()
                
                view.accessibilityIdentifier = id
                
                return view
            }
            
            return views
        }.flatMap{ $0 }
    }
    
    init(with views: [UIView]) {
        self.configs = []
        self.views = views
    }
    
    //Stub init
    public init(rawValue: String) {
        self.views = []
        self.configs = []
    }
    
    public func compare(with event: CTXTutorialEvent) -> CTXTutorialEventComparingResult {
        
        if let event = event as? CTXTutorialViewsShownEvent {
            
            return self.compareViews(self.views, event.views)
        } else {
            
            return .different
        }
    }
}

public extension CTXTutorialEvent {
    
    func compareViews(_ lhs: [UIView], _ rhs: [UIView]) -> CTXTutorialEventComparingResult {
        
        let leftSet = Set<String>(lhs.compactMap{ $0.accessibilityIdentifier })
        let rightSet = Set<String>(lhs.compactMap{ $0.accessibilityIdentifier })
        
        if rightSet.isSubset(of: leftSet) || leftSet.isSubset(of: rightSet) {
            
            return .equal
        }
        
        return .different
    }
}
