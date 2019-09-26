//
//  MyEvent.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 23/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

enum MyEvent: CTXTutorialEvent {
    
    case launch
    case check(Bool)
    case unknown
    
    func compare(with event: CTXTutorialEvent) -> CTXTutorialEventComparingResult {
        
        if let event = event as? MyEvent {
            
            switch (self, event) {
            case (.launch, .launch):
                return .equal
            case (.unknown, .unknown):
                return .equal
            default:
                return .different
            }
        }
        
        return .different
    }
    
    init?(with config: CTXTutorialEventConfig) {
        
        guard let config = config as? MyEventConfig else { return nil }
        
        switch config.event {
        case "launch": self = .launch
        case "check:true": self = .check(true)
        case "check:false": self = .check(false)
        default: self = .unknown
        }
    }
}
