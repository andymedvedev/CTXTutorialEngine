//
//  EventConfigMetaType.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 26/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

public class CTXTutorialEventConfigMetaType: Meta {
    
    public typealias Element = CTXTutorialEventConfig
    
    public var type: Decodable.Type {
        if self.rawValue == "CTXTutorialViewsShownEvent" {
            return CTXTutorialViewsShownEventConfig.self
        } else {
            fatalError("CTXTutorialEngine: \(String(describing: self)) class wasn't found by rawValue: \"\(self.rawValue)\".\nCheck your custom class. Key of event in config and rawValue (\"\(rawValue)\") of class must be equal.")
        }
    }
    
    public let rawValue: String
    
    required public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}
