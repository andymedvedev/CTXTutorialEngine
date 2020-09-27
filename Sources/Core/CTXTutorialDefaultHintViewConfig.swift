//
//  CTXTutorialHintStyle.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 24.09.2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

public final class CTXTutorialDefaultHintViewConfig {
    
    public var cornerRadius: CGFloat = 8
    public var anchorSize = CGSize(width: 16, height: 16)
    public var gradientStartPoint = CGPoint(x: 0.5, y: 0.0)
    public var gradientEndPoint = CGPoint(x: 0.5, y: 1.0)
    public var gradientLocations: [Float] = [0.0, 1.0]
    public var gradientColors: [UIColor?] = [.white, .white]
    public var anchorColor: UIColor? = .white
    public var insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    public var spacing: CGFloat = 8
    public var backButtonTitle: String?
    public var backButtonImage: UIImage?
    public var backButtonTintColor: UIColor! = UIColor.gray
    public var nextButtonTitle: String?
    public var nextButtonImage: UIImage?
    public var nextButtonTintColor: UIColor! = UIColor.gray
    public var closeButtonTitle: String?
    public var closeButtonImage: UIImage?
    public var closeButtonTintColor: UIColor! = UIColor.gray
    public var textColor: UIColor? = .black
    public var font: UIFont = .systemFont(ofSize: 16)
    public var onAppear: ((CTXTutorialHintView) -> Void)?
}
