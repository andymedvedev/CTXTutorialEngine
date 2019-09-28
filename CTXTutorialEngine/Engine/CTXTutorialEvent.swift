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
    
    init?(with config: CTXTutorialEventConfig)
}


public extension CTXTutorialEvent {
    
    init?(with config: CTXTutorialEventConfig) {
        return nil
    }
}


public final class CTXTutorialViewsShownEvent: CTXTutorialEvent {

    let stepConfigs: [CTXTutorialStepConfig]
    let views: [UIView]
    
    public init?(with config: CTXTutorialEventConfig) {
        
        guard let config = config as? CTXTutorialViewsShownEventConfig else { return nil }
        
        self.stepConfigs = config.eventConfig.stepConfigs
        
        self.views = self.stepConfigs.map{ stepConfig -> [UIView] in
            
            let views = stepConfig.accessibilityIdentifiers.map { id -> UIView in
                let view = UIView()
                
                view.accessibilityIdentifier = id
                
                return view
            }
            
            return views
        }.flatMap{ $0 }
    }
    
    init(with views: [UIView]) {
        
        self.stepConfigs = []
        self.views = views
    }
    
    public func compare(with event: CTXTutorialEvent) -> CTXTutorialEventComparingResult {
        
        if let event = event as? CTXTutorialViewsShownEvent {
            
            return self.compareViews(self.views, event.views)
        } else {
            
            return .different
        }
    }
}


private extension CTXTutorialViewsShownEvent {
    
    func compareViews(_ lhs: [UIView], _ rhs: [UIView]) -> CTXTutorialEventComparingResult {
        
        let leftSet = Set<String>(lhs.compactMap{ $0.accessibilityIdentifier })
        let rightSet = Set<String>(rhs.compactMap{ $0.accessibilityIdentifier })
        
        if rightSet.isSubset(of: leftSet) || leftSet.isSubset(of: rightSet) {
            
            return .equal
        }
        
        return .different
    }
}
