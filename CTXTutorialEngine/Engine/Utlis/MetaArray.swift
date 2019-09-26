//
//  MetaArray.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 26/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

public protocol CTXTutorialEventConfig: Decodable {
}

public protocol Meta: CTXTutorialEventConfig {
    associatedtype Element
    
    var type: Decodable.Type { get }
    
    var rawValue: String { get }
    
    init?(rawValue: String)
}

struct CTXTutorialEventConfigsArray<M: Meta>: Decodable {
    
    let array: [M.Element]
    
//    init(_ array: [M.Element]) {
//        self.array = array
//    }
//    
//    init(arrayLiteral elements: M.Element...) {
//        self.array = elements
//    }
    
    struct ElementKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        var elements: [M.Element] = []
        
        
        
        while !container.isAtEnd {
            
            let nested = try container.nestedContainer(keyedBy: ElementKey.self)
            
            guard let key = nested.allKeys.first else { continue }
                        
            let metatype = M(rawValue: key.stringValue)
            let superDecoder = try nested.superDecoder(forKey: key)
            let object = try metatype?.type.init(from: superDecoder)
            
            if let element = object as? M.Element {
                elements.append(element)
            }
        }
        array = elements
    }
}
