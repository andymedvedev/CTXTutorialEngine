//
//  CTXTutotialHintView.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 14.06.2020.
//  Copyright © 2020 Andrey Medvedev. All rights reserved.
//

import UIKit

public protocol CTXTutorialHintView where Self: UIView {
    
    var previousStepHandler: VoidClosure? { get set }
    var nextStepHandler: VoidClosure? { get set }
    var closeTutorialHandler: VoidClosure? { get set }
}

