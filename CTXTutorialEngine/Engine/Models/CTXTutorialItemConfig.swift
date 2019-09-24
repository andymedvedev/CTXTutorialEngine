//
//  CTXTutorialItemConfig.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 23/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

struct CTXTutorialItemConfig: Decodable {
    
    let id: Int
    let name: String?
    let events: [CTXTutorialItemEvent]
}
