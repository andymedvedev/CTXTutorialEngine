//
//  EventMetaType.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 26/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

final class MyEventConfigMetatype: CTXTutorialEventConfigMetaType {
    
    enum ConfigType: String{
        case myBasicEvent = "MyBasicEvent"
    }
    
    override var type: Decodable.Type {
        
        let configType = ConfigType(rawValue: self.rawValue)
        
        switch configType {
        case .myBasicEvent?:
            return MyEventConfig.self
        default:
            return super.type
        }
    }
}
