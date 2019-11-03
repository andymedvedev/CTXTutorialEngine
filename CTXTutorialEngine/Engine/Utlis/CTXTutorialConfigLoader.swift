//
//  CTXTutorialConfigLoader.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 23/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

enum ConfigLoaderError: Error {
    
    case error(String)
}

final class CTXTutorialConfigLoader {
    
    func loadConfigs<M: Meta>(from fileName: String, eventConfigMetaType: M.Type) throws -> [CTXTutorialConfig<M>]  {
        
        guard let configFileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw ConfigLoaderError.error("Config with name: \"\(fileName)\" not found.")
        }
        
        let data = try Data(contentsOf: configFileURL)
        let decoder = JSONDecoder()
        var configs: [String: [CTXTutorialConfig<M>]]?
        
        configs = try decoder.decode([String: [CTXTutorialConfig<M>]].self, from: data)
        
        if let configs = configs?["tutorials"] {
            return configs
        } else {
            throw ConfigLoaderError.error("Configs are nil")
        }
    }
    
}
