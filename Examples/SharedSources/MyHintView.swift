//
//  MyHintView.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 08.12.2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit
import CTXTutorialEngine

public final class MyHintView: UIView, CTXTutorialHintView {
    
    public var previousStepHandler: VoidClosure?
    public var nextStepHandler: VoidClosure?
    public var closeTutorialHandler: VoidClosure?

    private enum AnchorDirection {
        case toTop
        case toBottom
        case toLeft
        case toRight
        case none
    }
    
    private enum AnchorAlignment {
        case top
        case bottom
        case left
        case right
        case center
    }
    
    private let textLabel = UILabel()
    private lazy var buttonsStackView = UIStackView(arrangedSubviews: [backButton, nextButton])
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            closeButton,
            textLabel,
            buttonsStackView,
        ])
        stackView.alignment = .trailing
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var bubleView: UIView = {
        let view = UIView()
        view.addSubview(mainStackView)
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        return view
    }()
    private let horizontalInset: CGFloat = 16
    private let topInset: CGFloat = 8
    private let verticalSpacing: CGFloat = 16
    private let backButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    private let anchorSize: CGFloat = 32
    private let cornerRadius: CGFloat = 6
    private let snapshot: UIView
    
    public init?(with step: CTXTutorialStepModel) {
        guard let snapshot = step.views.first else {
            return nil
        }
        
        self.snapshot = snapshot
        
        super.init(frame: .zero)
        
        textLabel.text = step.text
        textLabel.font = .systemFont(ofSize: 13)
        textLabel.numberOfLines = 0
        
        backButton.setImage(UIImage(named: "arrow_back"), for: .normal)
        nextButton.setImage(UIImage(named: "arrow_forward"), for: .normal)
        closeButton.setImage(UIImage(named: "cross"), for: .normal)
        
        [backButton, nextButton, closeButton].forEach { $0.tintColor = .darkGray }
        
        backButton.addTarget(self, action: #selector(previousStep), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTutorial), for: .touchUpInside)
        
        backgroundColor = .clear
        
        addSubview(bubleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bubleView.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        
        setup()
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
    
    public func configure(isHavePreviousStep: Bool,
                          isHaveNextStep: Bool,
                          isHaveCloseButton: Bool) {
        backButton.isHidden = !isHavePreviousStep
        nextButton.isHidden = !isHaveNextStep
        closeButton.isHidden = !isHaveCloseButton
    }
    
    private func centerHintViewX(anchorAlignment: inout AnchorAlignment) {
        let bounds = UIScreen.main.bounds
        
        if snapshot.center.x - bubleView.frame.width > 16 {
            frame.origin.x = snapshot.center.x - bubleView.frame.width
            anchorAlignment = .right
        } else if snapshot.center.x + bubleView.frame.width < bounds.width - 16 {
            frame.origin.x = snapshot.center.x
            anchorAlignment = .left
        } else {
            center.x = snapshot.center.x
            anchorAlignment = .center
        }
    }
    
    private func centerHintViewY() {
        bubleView.center.y = snapshot.center.y
        //TODO
    }
    
    private func fitSize(with width: CGFloat) {
        textLabel.frame.size = textLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    }
    
    private func setup() {
        let bounds = UIScreen.main.bounds
        let safeAreaInsets: UIEdgeInsets
        
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            safeAreaInsets = keyWindow.safeAreaInsets
        } else {
            safeAreaInsets = .zero
        }
        
        if frame.width > bounds.width - 32 {
            fitSize(with: bounds.width - 32)
            return
        }
        
        let bubleHeight = bubleView.frame.height
        let bubleWidth = bubleView.frame.width
        let snapshotMinX = snapshot.frame.minX
        let snapshotMaxX = snapshot.frame.maxX
        let snapshotMinY = snapshot.frame.minY
        let snapshotMaxY = snapshot.frame.maxY
        
        let topSpace = snapshotMinY - safeAreaInsets.top
        let bottomSpace = bounds.maxY - safeAreaInsets.bottom - snapshotMaxY
        let leftSpace = snapshotMinX
        let rightSpace = bubleView.frame.maxX - snapshotMinX
        var anchorDirection = AnchorDirection.none
        var anchorAlignment = AnchorAlignment.center
        
        if topSpace > bottomSpace && topSpace >= bubleHeight + anchorSize { // plate hint on the top of snapshot
            
            frame.origin.y = snapshotMinY - bubleHeight - anchorSize
            bubleView.frame.origin.y = .zero
            centerHintViewX(anchorAlignment: &anchorAlignment)
            anchorDirection = .toBottom
        } else if bottomSpace >= bubleHeight + anchorSize {
            
            frame.origin.y = snapshotMaxY
            bubleView.frame.origin.y = anchorSize
            centerHintViewX(anchorAlignment: &anchorAlignment)
            anchorDirection = .toTop
        } else if leftSpace > rightSpace && leftSpace >= bubleWidth + anchorSize {
            
            frame.origin.x = snapshotMinX - bubleWidth - anchorSize
            bubleView.frame.origin.x = .zero
            centerHintViewY()
            anchorDirection = .toRight
        } else if rightSpace >= bubleWidth + anchorSize {
            
            frame.origin.x = snapshotMaxX
            bubleView.frame.origin.x = anchorSize
            centerHintViewY()
            anchorDirection = .toLeft
        }
        
        bubleView.layer.maskedCorners = maskedCorners(for: anchorDirection, alignment: anchorAlignment)
        layer.addSublayer(anchorLayer(with: anchorDirection, alignment: anchorAlignment))
    }
    
    private func anchorLayer(with direction: AnchorDirection, alignment: AnchorAlignment) -> CALayer {
        let anchorLayer = CAShapeLayer()
        let path = UIBezierPath()
        let middlePoint: CGPoint
        
        path.move(to: CGPoint(x: .zero, y: anchorSize))
        
        switch (direction, alignment) {
        case (.toTop, .left),
             (.toBottom, .right),
             (.toRight, .top),
             (.toLeft, .bottom):
            middlePoint = .zero
        case (.toBottom, .left),
             (.toTop, .right),
             (.toLeft, .top),
             (.toRight, .bottom):
            middlePoint = CGPoint(x: anchorSize, y: .zero)
        default:
            middlePoint = CGPoint(x: anchorSize / 2, y: .zero)
        }
        
        path.addLine(to: middlePoint)
        path.addLine(to: CGPoint(x: anchorSize, y: anchorSize))
        path.close()
        path.stroke()
        path.fill()
        anchorLayer.path = path.cgPath
        anchorLayer.frame = anchorFrame(for: direction, alignment: alignment)
        anchorLayer.fillColor = UIColor.white.cgColor
        
        switch direction {
        case .toTop:
            break
        case .toLeft:
            anchorLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi / 2))
        case .toRight:
            anchorLayer.setAffineTransform(CGAffineTransform(rotationAngle: -CGFloat.pi / 2))
        case .toBottom:
            anchorLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi))
        case .none:
            break
        }
        
        return anchorLayer
    }
    
    private func anchorFrame(for direction: AnchorDirection, alignment: AnchorAlignment) -> CGRect {
        let origin: CGPoint
        let size = CGSize(width: anchorSize, height: anchorSize)
        
        switch (direction, alignment) {
        case (.toTop, .left), (.toLeft, .top):
            origin = .zero
        case (.toTop, .right):
            origin = CGPoint(x: bubleView.frame.maxX - anchorSize, y: .zero)
        case (.toTop, .center):
            origin = CGPoint(x: bubleView.center.x - anchorSize / 2, y: .zero)
        case (.toBottom, .left):
            origin = CGPoint(x: .zero, y: bubleView.frame.maxY)
        case (.toBottom, .right):
            origin = CGPoint(x: bubleView.frame.maxX - anchorSize, y: bubleView.frame.maxY)
        case (.toBottom, .center):
            origin = CGPoint(x: bubleView.center.x - anchorSize / 2, y: bubleView.frame.maxY)
        case (.toLeft, .bottom):
            origin = CGPoint(x: .zero, y: bubleView.frame.maxY - anchorSize)
        case (.toLeft, .center):
            origin = CGPoint(x: .zero, y: bubleView.center.y - anchorSize / 2)
        case (.toRight, .top):
            origin = CGPoint(x: bubleView.frame.maxX, y: .zero)
        case (.toRight, .bottom):
            origin = CGPoint(x: bubleView.frame.maxX, y: bubleView.frame.maxY - anchorSize)
        case (.toRight, .center):
            origin = CGPoint(x: bubleView.frame.maxX, y: bubleView.center.y - anchorSize / 2)
        default:
            return .zero
        }
        
        return CGRect(origin: origin, size: size)
    }
    
    private func maskedCorners(for direction: AnchorDirection, alignment: AnchorAlignment) -> CACornerMask {
        var corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        let excluedCorner: CACornerMask?
        
        switch (direction, alignment) {
        case (.toTop, .left), (.toLeft, .top):
            excluedCorner = .layerMinXMinYCorner
        case (.toTop, .right), (.toRight, .top):
            excluedCorner = .layerMaxXMinYCorner
        case (.toBottom, .left), (.toLeft, .bottom):
            excluedCorner = .layerMinXMaxYCorner
        case (.toBottom, .right), (.toRight, .bottom):
            excluedCorner = .layerMaxXMaxYCorner
        default:
            excluedCorner = nil
        }
        
        if let excludedCorner = excluedCorner {
            corners.remove(excludedCorner)
        }
        
        return corners
    }
}

private extension MyHintView {
    
    @objc func previousStep() {
        previousStepHandler?()
    }
    
    @objc func nextStep() {
        nextStepHandler?()
    }
    
    @objc func closeTutorial() {
        closeTutorialHandler?()
    }
}
