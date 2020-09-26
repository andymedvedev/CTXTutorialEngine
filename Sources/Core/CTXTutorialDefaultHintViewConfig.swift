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
    public var gradientTopControlPoint: Float = 0.2
    public var gradientBottomControlPoint: Float = 0.7
    public var gradientOuterColor: UIColor? = UIColor.white
    public var gradientInnerColor: UIColor? = UIColor.white
    public var anchorColor: UIColor? = UIColor.white
    public var insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    public var spacing: CGFloat = 8
    public var backButton: UIButton?
    public var nextButton: UIButton?
    public var closeButton: UIButton?
    public var buttonsTintColor: UIColor = .white
    public var textColor: UIColor? = .black
    public var font: UIFont = .systemFont(ofSize: 16)
    public var onAppear: ((CTXTutorialHintView) -> Void)?
}
