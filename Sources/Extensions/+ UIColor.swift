//
//  + UIColor.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 04.10.2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: UInt) {
        let r, g, b: CGFloat

        r = CGFloat((hex & 0xff0000) >> 16) / 255
        g = CGFloat((hex & 0x00ff00) >> 8) / 255
        b = CGFloat((hex & 0x0000ff)) / 255
            
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
