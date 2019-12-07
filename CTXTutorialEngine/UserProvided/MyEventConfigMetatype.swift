//
//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

final class MyEventConfigMetatype: CTXTutorialEventConfigMetaType {
    
    enum ConfigType: String{
        case myBasicEvent = "MyEvent"
    }
    
    override var type: Decodable.Type {
        
        let configType = ConfigType(rawValue: rawValue)
        
        switch configType {
        case .myBasicEvent?:
            return MyEventConfig.self
        default:
            return super.type
        }
    }
}
