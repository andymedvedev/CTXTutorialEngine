//
//  TutorialAdditionError.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 28/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

public struct CTXTutorialAdditionError: LocalizedError {
    
    public let id: CTXTutorialID
    public let name: String?
    
    public var errorDescription: String {
        return "Tutorial with same ID (id: \(id), name: \"\(name ?? "")\" already in the system, and it will not be fired."
    }
}
