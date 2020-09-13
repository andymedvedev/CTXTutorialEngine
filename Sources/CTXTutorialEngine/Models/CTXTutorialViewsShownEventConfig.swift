//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

public class CTXTutorialViewsShownEventStepsConfig: Decodable {
    
    let stepConfigs: [CTXTutorialStepConfig]
    
    enum CodingKeys: String, CodingKey {
        case stepConfigs = "steps"
    }
    
    public init(stepConfigs: [CTXTutorialStepConfig]) {
        self.stepConfigs = stepConfigs
    }
}

public class CTXTutorialViewsShownEventConfig: CTXTutorialEventConfig {
    
    let eventConfig: CTXTutorialViewsShownEventStepsConfig
    
    enum CodingKeys: String, CodingKey {
        case eventConfig = "event"
    }
    
    public init(stepConfigs: [CTXTutorialStepConfig]) {
        self.eventConfig = CTXTutorialViewsShownEventStepsConfig(stepConfigs: stepConfigs)
    }
}
