//
//  CTXTutorialItemEvent.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 23/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

struct CTXTutorialItemEvent: Decodable {
    
    var basicEvent: String?
    var stepsEvent: CTXTutorialItemStepsEvent?
}
