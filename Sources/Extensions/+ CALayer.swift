//
//  + CALayer.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 18.11.2020.
//  Copyright © 2020 home. All rights reserved.
//

import QuartzCore

extension CALayer {
    
    func pause() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }

    func resume() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}




