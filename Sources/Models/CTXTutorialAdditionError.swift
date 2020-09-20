//
//  TutorialAdditionError.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 28/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

public struct CTXTutorialAdditionError: LocalizedError {
    
    public var errorDescription: String {
        return "Tutorial with same ID already in system and not fired."
    }
}
