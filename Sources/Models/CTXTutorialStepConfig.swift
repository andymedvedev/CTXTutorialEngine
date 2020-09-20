//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

public struct CTXTutorialStepConfig: Decodable {

    let text: String?
    let accessibilityIdentifier: String
    
    public init(text: String?, accessibilityIdentifier: String) {
        self.text = text
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}
