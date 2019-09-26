//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

public protocol CTXTutorialEventConfig: Decodable {
}

public class CTXTutorialViewsShownEventStepsConfig: Decodable {
    
    let stepConfigs: [CTXTutorialStepConfig]
    
    enum CodingKeys: String, CodingKey {
        case stepConfigs = "steps"
    }
}

public class CTXTutorialViewsShownEventConfig: CTXTutorialEventConfig {
    
    let value: CTXTutorialViewsShownEventStepsConfig
}
