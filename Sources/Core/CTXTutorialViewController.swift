//
//  CTXTutorialViewController.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 23.09.2020.
//

import UIKit

public protocol CTXTutorialShowing where Self: UIViewController {
    
    var isTutorialShowing: Bool { get set }
}
