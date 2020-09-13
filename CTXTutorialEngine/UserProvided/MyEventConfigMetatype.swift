//
//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

final class MyEventConfigMetatype: CTXTutorialEventConfigMetaType {
    
    enum ConfigType: String{
        case myEvent = "MyEvent"
    }
    
    override var type: Decodable.Type {
        
        let configType = ConfigType(rawValue: rawValue)
        
        switch configType {
        case .myEvent?:
            return MyEventConfig.self
        default:
            return super.type
        }
    }
}
