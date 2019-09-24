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
    
    init(rawValue: String) {
        
        switch rawValue {
        case "launch": self = .launch
        case "check:true": self = .check(true)
        case "check:false": self = .check(false)
        default: self = .unknown
        }
    }
    
    func getString(from state: Bool) -> String {
        return state ? ":true" : ":false"
    }
}
