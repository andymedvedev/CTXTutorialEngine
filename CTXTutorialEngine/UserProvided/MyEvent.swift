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
    case tapButton
    case check(Bool) // not used. Only for instance
    case unknown
    
    func compare(with event: CTXTutorialEvent) -> CTXTutorialEventComparingResult {
        if let event = event as? MyEvent {
            
            switch (self, event) {
            case (.launch, .launch):
                return .equal
            case (.tapButton, .tapButton):
                return .equal
            case let (.check(lhs), .check(rhs)):
                return (lhs == rhs) ? .equal : .mutuallyExclusive
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
        case "tapButton": self = .tapButton
        case "check:true": self = .check(true)
        case "check:false": self = .check(false)
        default: self = .unknown
        }
    }
    
    init(rawValue: String) {
        switch rawValue {
        case "launch": self = .launch
        case "tapButton": self = .tapButton
        case "check:true": self = .check(true)
        case "check:false": self = .check(false)
        default: self = .unknown
        }
    }
}
