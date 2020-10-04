//
//  CTXTutorialViewController.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 04.10.2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

public protocol CTXTutorialShowing where Self: UIViewController {
    
    var isTutorialShowing: Bool { get set }
}

open class CTXTutorialViewController: UIViewController, CTXTutorialShowing {
    
    public var isTutorialShowing: Bool = false
    
    private let _engine = CTXTutorialEngine.shared
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        if isTutorialShowing {
            return _engine.appearance.preferredStatusBarStyle
        } else {
            return .default
        }
    }
}
