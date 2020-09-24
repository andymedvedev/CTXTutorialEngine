//
//  CTXTutorialHintStyle.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 24.09.2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

public final class CTXTutorialDefaultHintViewConfig {
    
    public var backgroundView: UIView?
    public var cornerRadius: CGFloat = 8
    public var anchorSize = CGSize(width: 16, height: 16)
    public var anchorColor = UIColor.white
    public var insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    public var spacing = 8
    public var backButton: UIButton?
    public var nextButton: UIButton?
    public var closeButton: UIButton?
    public var textLabel: UILabel?
}
