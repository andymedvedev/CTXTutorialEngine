//
//  MyHintView.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 08.12.2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit
import CTXTutorialEngine

public class CustomButton: UIButton {
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let minTouchAreaSize: CGFloat = 30
        let delta = Int(bounds.width < minTouchAreaSize ? minTouchAreaSize - bounds.width : .zero)
        let horizontalRange = -delta...(Int(bounds.width) + delta)
        let verticalRange = -delta...(Int(bounds.height) + delta)
        
        return horizontalRange.contains(Int(point.x))
            && verticalRange.contains(Int(point.y))
    }
}

public final class MyHintView: UIView, CTXTutorialHintView {
    
    public var previousStepHandler: VoidClosure?
    public var nextStepHandler: VoidClosure?
    public var closeTutorialHandler: VoidClosure?

    public struct ViewModel {
        
        let step: CTXTutorialStepModel
        let showBackButton: Bool
        let showNextButton: Bool
        let showCloseButton: Bool
        let boundingView: UIView
    }
    
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
    private lazy var bubleView: UIView = {
        let view = UIView()
        view.addSubview(closeButton)
        view.addSubview(textLabel)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        return view
    }()
    private let minHorizontalInset: CGFloat = 16
    private let bubleInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    private let bubleInnerSpacing: CGFloat = 8
    private let backButton = CustomButton(type: .system)
    private let nextButton = CustomButton(type: .system)
    private let closeButton = CustomButton(type: .system)
    private let anchorSize: CGFloat = 16
    private let cornerRadius: CGFloat = 6
    private let buttonSize = CGSize(width: 16, height: 16)
    
    public init(with viewModel: ViewModel) {
        super.init(frame: .zero)
        
        textLabel.font = .systemFont(ofSize: 15)
        textLabel.numberOfLines = 0
        
        backButton.setImage(UIImage(named: "arrow_backward"), for: .normal)
        nextButton.setImage(UIImage(named: "arrow_forward"), for: .normal)
        closeButton.setImage(UIImage(named: "cross"), for: .normal)
        
        [backButton, nextButton, closeButton].forEach { $0.tintColor = .darkGray }
        
        backButton.addTarget(self, action: #selector(previousStep), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTutorial), for: .touchUpInside)
        
        addSubview(bubleView)
        
        //preventing touches go through to dimming view
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        addGestureRecognizer(tapGesture)
        
        setup(with: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func placeHint(by viewModel: ViewModel, anchorDirection: AnchorDirection, anchorAlignment: inout AnchorAlignment) {
        guard let view = viewModel.step.views.first  else {
            fatalError("Step model doesn't contains any views")
        }
        
        let convertedFrame = view.convert(view.bounds, to: viewModel.boundingView)
        
        func originX() -> CGFloat {
            let centerX = convertedFrame.midX
            
            if centerX - bubleView.frame.width > minHorizontalInset {
                anchorAlignment = .right
                return centerX - bubleView.frame.width
            } else if centerX + bubleView.frame.width < viewModel.boundingView.bounds.width - minHorizontalInset {
                anchorAlignment = .left
                return centerX
            } else {
                anchorAlignment = .center
                return centerX - bounds.width / 2
            }
        }
        
        func originY() -> CGFloat {
            switch anchorDirection {
            case .toTop:
                return convertedFrame.maxY
            case .toBottom:
                return convertedFrame.minY - bounds.height
            default:
                return .zero
                //TODO
            }
        }
        
        frame.origin = CGPoint(x: originX(), y: originY())
    }
    
    private func fitAndPlace(with size: CGSize, anchorDirection: AnchorDirection) {
        var bubleHeight = bubleInsets.top
        var selfHeight: CGFloat = .zero
        
        [closeButton, backButton, nextButton].forEach { $0.frame.size = buttonSize }
        
        var availableWidthForLabel = size.width - bubleInsets.left - bubleInsets.right
        
        switch anchorDirection {
        case .toLeft:
            bubleView.frame.origin.x = anchorSize
            availableWidthForLabel -= anchorSize
        case .toRight:
            bubleView.frame.origin.x = .zero
            availableWidthForLabel -= anchorSize
        case .toTop:
            bubleView.frame.origin.y = anchorSize
            selfHeight += anchorSize
        case .toBottom:
            bubleView.frame.origin.y = .zero
            selfHeight += anchorSize
        default:
            break
        }
        
        if !closeButton.isHidden {
            bubleHeight += closeButton.frame.height + bubleInnerSpacing
        }
        
        let labelSize = textLabel.sizeThatFits(CGSize(width: availableWidthForLabel,
                                                      height: .greatestFiniteMagnitude))
        textLabel.frame = CGRect(origin: CGPoint(x: bubleInsets.left,
                                                 y: bubleHeight),
                                 size: labelSize)
        bubleHeight += labelSize.height
        
        let width = labelSize.width + bubleInsets.left + bubleInsets.right
        
        if !closeButton.isHidden {
            closeButton.frame.origin = CGPoint(x: width - buttonSize.width - bubleInsets.right,
                                               y: bubleInsets.top)
        }
        
        if backButton.isHidden && nextButton.isHidden {
            bubleHeight += bubleInsets.bottom
        } else {
            
            nextButton.frame.origin = CGPoint(x: width - buttonSize.width - bubleInsets.right,
                                              y: bubleHeight + bubleInnerSpacing)
            backButton.frame.origin = CGPoint(x: bubleInsets.left,
                                              y: bubleHeight + bubleInnerSpacing)
            bubleHeight += backButton.bounds.height + bubleInnerSpacing + bubleInsets.bottom
        }
        
        selfHeight += bubleHeight
        
        frame.size = CGSize(width: width, height: selfHeight)
        
        bubleView.frame.size = CGSize(width: width, height: bubleHeight)
    }
    
    private func setup(with viewModel: ViewModel) {
        guard let view = viewModel.step.views.first else {
            fatalError("Step model doesn't contains any snapshots")
        }
        
        let convertedFrame = view.convert(view.bounds, to: viewModel.boundingView)
        
        backButton.isHidden = !viewModel.showBackButton
        nextButton.isHidden = !viewModel.showNextButton
        closeButton.isHidden = !viewModel.showCloseButton
        textLabel.text = viewModel.step.text
        
        let bounds = viewModel.boundingView.bounds
        let safeAreaInsets: UIEdgeInsets
        
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            safeAreaInsets = keyWindow.safeAreaInsets
        } else {
            safeAreaInsets = .zero
        }
        
        let viewMinX = convertedFrame.minX
        let viewMaxX = convertedFrame.maxX
        let viewMinY = convertedFrame.minY
        let viewMaxY = convertedFrame.maxY
        
        let availableHeight = bounds.height - safeAreaInsets.bottom - safeAreaInsets.top
        let topSpace = viewMinY - safeAreaInsets.top
        let bottomSpace = bounds.maxY - safeAreaInsets.bottom - viewMaxY
        let leftSpace = viewMinX
        let rightSpace = bounds.width - viewMaxX
        
        var anchorDirection = AnchorDirection.none
        var anchorAlignment = AnchorAlignment.center
        
        if topSpace > bottomSpace {
            anchorDirection = .toBottom
            fitAndPlace(with: CGSize(width: bounds.width, height: topSpace), anchorDirection: anchorDirection)
        } else if topSpace < bottomSpace {
            anchorDirection = .toTop
            fitAndPlace(with: CGSize(width: bounds.width, height: bottomSpace), anchorDirection: anchorDirection)
        } else if leftSpace > rightSpace {
            anchorDirection = .toRight
            fitAndPlace(with: CGSize(width: leftSpace, height: availableHeight), anchorDirection: anchorDirection)
        } else if leftSpace < rightSpace {
            anchorDirection = .toLeft
            fitAndPlace(with: CGSize(width: rightSpace, height: availableHeight), anchorDirection: anchorDirection)
        } else {
            anchorDirection = .none
            fitAndPlace(with: CGSize(width: bounds.width, height: availableHeight), anchorDirection: anchorDirection)
        }
        
        placeHint(by: viewModel, anchorDirection: anchorDirection, anchorAlignment: &anchorAlignment)
        
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

