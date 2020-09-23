//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public enum CTXTutorialViewControllerContentType {
    
    case `static`
    case dynamic
    
}

public final class CTXTutorialWeakViewController {
    
    weak var viewController: UIViewController?
    var provideSortedViewsSlices = true
    var warningIsProcessed = false
    
    var availableAccessibilityViewsDict: [String: [[UIView]]] {
        
        switch contentType {
        case .static:
            
            return staticAccessibilityViewsDict
        case .dynamic:
            
            var dict = [String: [[UIView]]]()
            
            if let vcView = viewController?.view {
                
                let views = vcView.accessibilityViews().filter{ availabilityChecker.isAvailable($0) }
                
                dict = makeDict(from: views)
            }
            
            return dict
        }
    }
    
    private var staticAccessibilityViewsDict = [String: [[UIView]]]()
    private let contentType: CTXTutorialViewControllerContentType
    private let availabilityChecker: CTXTutorialViewAvailabilityChecker
    
    init(with viewController: UIViewController,
         contentType: CTXTutorialViewControllerContentType,
         availabilityChecker: CTXTutorialViewAvailabilityChecker) {
        
        self.viewController = viewController
        self.contentType = contentType
        self.availabilityChecker = availabilityChecker
        
        _ = viewController.view
        
        switch contentType {
        case .static:
            
            let views = viewController.view.accessibilityViews().filter{ availabilityChecker.isAvailable($0) }

            if views.isEmpty {
                print("CTXTutorialEngine Warning: possible you call CTXTutorialEngine.observe(_:, contentType:) with .static contentType before viewDidAppear(_:). No views shown events will be processed.")
            }
            
            staticAccessibilityViewsDict = makeDict(from: views)
        default: break
        }
    }
}

private extension CTXTutorialWeakViewController {
    
    func sortedViews(views: [UIView]) -> [[UIView]] {
        
        guard self.provideSortedViewsSlices && (views.count > 1) else {
            return [views]
        }
        
        let xy = { (view: UIView) -> CGPoint in
            return view.convert(view.frame.origin, to: nil)
        }
        
        let ySet = Set<CGFloat>(views.map{ xy($0).y })
        let allY = Array(ySet).sorted(by: { $0 < $1 })
        
        var sortedSlices = [[UIView]]()

        for index in 0 ..< allY.count {
            
            var sortedSlice = views.filter({ xy($0).y == allY[index] })
            
            sortedSlice.sort { v1, v2 in
                return xy(v1).x <= xy(v2).x
            }
            
            sortedSlices.append(sortedSlice)
        }

        return sortedSlices
    }
    
    func makeDict(from views: [UIView]) -> [String: [[UIView]]] {
        
        var dict = [String: [[UIView]]]()
        
        let ids = Set<String>(views.compactMap{ $0.accessibilityIdentifier })
        
        ids.forEach { id in
            
            dict[id] = self.sortedViews(views: views.filter{
                $0.accessibilityIdentifier == id
            })
        }
        
        return dict
    }
}


