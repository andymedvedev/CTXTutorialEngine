//
//  CTXTutorialHintStyle.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 24.09.2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

public final class CTXTutorialAppearance {
    
    private static let violet = UIColor(hex: 0xB08FFF)
    private static let violetLight = UIColor(hex: 0xCAA8FF)
    private static let yellow = UIColor(hex: 0xFFDC4A)
    public var preferredStatusBarStyle: UIStatusBarStyle = .lightContent
    public var overlayColor = UIColor(white: 0, alpha: 0.64)
    
    public var cornerRadius: CGFloat = 8
    public var anchorSize = CGSize(width: 16, height: 16)
    public var gradientStartPoint = CGPoint(x: 0.5, y: 0.0)
    public var gradientEndPoint = CGPoint(x: 0.5, y: 1.0)
    public var gradientLocations: [Float] = [0.0, 0.3, 0.6, 1.0]
    public var gradientColors: [UIColor?] = [CTXTutorialAppearance.violetLight,
                                             CTXTutorialAppearance.violet,
                                             CTXTutorialAppearance.violet,
                                             CTXTutorialAppearance.violetLight]
    public var anchorColor: UIColor? = CTXTutorialAppearance.violetLight
    public var insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    public var spacing: CGFloat = 8
    public var backButtonTitle: String?
    public var backButtonImage: UIImage?
    public var backButtonTintColor: UIColor! = CTXTutorialAppearance.yellow
    public var nextButtonTitle: String?
    public var nextButtonImage: UIImage?
    public var nextButtonTintColor: UIColor! = CTXTutorialAppearance.yellow
    public var closeButtonTitle: String?
    public var closeButtonImage: UIImage?
    public var closeButtonTintColor: UIColor! = CTXTutorialAppearance.yellow
    public var textColor: UIColor? = CTXTutorialAppearance.yellow
    public var font: UIFont = .systemFont(ofSize: 16)
    public var onAppear: ((UIView) -> Void)?
}
