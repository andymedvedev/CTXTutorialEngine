//
//  CTXTutorialItemConfig.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 23/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

public struct CTXTutorialConfig<M: Meta>: Decodable {
    
    let id: CTXTutorialID
    let name: String?
    let eventConfigs: CTXTutorialEventConfigsArray<M>
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case eventConfigs = "events"
    }
}
