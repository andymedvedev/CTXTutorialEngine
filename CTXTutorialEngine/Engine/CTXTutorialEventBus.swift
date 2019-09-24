//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

protocol CTXTutorialEventSubject {
    
    func add(_ observer: CTXTutorialEventObserver)
    
    func remove(_ observer: CTXTutorialEventObserver)
    
    func push(_ event: CTXTutorialEvent)
}


protocol CTXTutorialEventObserver: AnyObject {
    
    func push(_ event: CTXTutorialEvent)
}


public final class CTXTutorialEventBus: CTXTutorialEventSubject {
    
    public static let shared = CTXTutorialEventBus()

    var isLocked = false
    
    private init() {}
    
    private var observers = [CTXTutorialEventObserver]()
    
    func add(_ observer: CTXTutorialEventObserver) {
        
        self.observers.append(observer)
    }
    
    func remove(_ observer: CTXTutorialEventObserver) {
        
        self.observers.removeAll { $0 === observer }
    }
    
    public func push(_ event: CTXTutorialEvent) {
        
        self.observers.forEach{
            if !self.isLocked {
                $0.push(event)
            }
        }
    }
}
