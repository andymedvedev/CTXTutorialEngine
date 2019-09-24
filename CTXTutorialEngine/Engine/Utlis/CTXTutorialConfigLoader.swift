//
//  CTXTutorialConfigLoader.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 23/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

final class CTXTutorialConfigLoader {
    
    func loadConfigs(with name: String = "CTXTutorialConfig") throws -> [CTXTutorialItemConfig] {
        guard let configFileURL = Bundle.main.url(forResource: name, withExtension: "json") else {
            fatalError("Config with name: \"\(name)\" not found.")
        }
        
        let data = try Data(contentsOf: configFileURL)
        let decoder = JSONDecoder()
        var configs: [String: [CTXTutorialItemConfig]]?
        
        configs = try decoder.decode([String: [CTXTutorialItemConfig]].self, from: data)
        
        if let configs = configs {
            return (configs["configs"] as! [CTXTutorialItemConfig])
        } else {
            fatalError("Configs are nil")
        }
    }
    
}
