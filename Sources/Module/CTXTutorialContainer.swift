//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

final class CTXTutorialContainerView: UIView {
    
    private var closeHandler: VoidClosure?
    private var hintView: UIView?
    private var hintedView: UIView?
    
    func configure(closeHandler: VoidClosure?) {
        
        backgroundColor = CTXTutorialEngine.shared.appearance.overlayColor
        
        self.closeHandler = closeHandler
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTutorial))
        
        addGestureRecognizer(tapGesture)
    }
    
    func showStep(with hintView: UIView, hintedView: UIView) {
        self.hintView?.removeFromSuperview()
        
        self.hintView = hintView
        self.hintedView = hintedView
        
        let mask = maskLayer(for: hintedView)
        layer.mask = mask
        clipsToBounds = true
        
        if let hintView = self.hintView {
            addSubview(hintView)
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = self.hintedView else {
            return nil
        }
        
        let viewPoint = convert(point, to: view)
        
        if let hitTestedView = view.hitTest(viewPoint, with: event) {
            return hitTestedView
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

private extension CTXTutorialContainerView {
    
    @objc func closeTutorial() {
        closeHandler?()
    }
    
    func maskLayer(for view: UIView) -> CALayer? {
        let maskLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(rect: bounds)
        let subPath = path(for: view)
        let convertedOrigin = view.convert(CGPoint.zero, to: self)
        
        subPath.apply(CGAffineTransform(translationX: convertedOrigin.x,
                                        y: convertedOrigin.y))
        bezierPath.append(subPath)
        maskLayer.path = bezierPath.cgPath
        maskLayer.fillRule = .evenOdd
        
        return maskLayer
    }
    
    private func path(for view: UIView) -> UIBezierPath {
        let path = UIBezierPath()
        let viewLayer = view.layer
        
        if viewLayer.cornerRadius == .zero {
            if let cgPath = (viewLayer as? CAShapeLayer)?.path {
                path.cgPath = cgPath
            } else if let maskCGPath = (viewLayer.mask as? CAShapeLayer)?.path {
                path.cgPath = maskCGPath
            } else {
                return UIBezierPath(rect: viewLayer.bounds)
            }
        } else {
            return UIBezierPath(roundedRect: viewLayer.bounds,
                                byRoundingCorners: viewLayer.maskedCorners.asRectCorner,
                                cornerRadii: CGSize(width: viewLayer.cornerRadius,
                                                    height: viewLayer.cornerRadius))
        }
        
        return path
    }
}

private extension CACornerMask {
    
    var asRectCorner: UIRectCorner {
        var result = UIRectCorner()
        if contains(.layerMinXMinYCorner) {
            result.insert(.topLeft)
        }
        if contains(.layerMaxXMinYCorner) {
            result.insert(.topRight)
        }
        if contains(.layerMaxXMaxYCorner) {
            result.insert(.bottomRight)
        }
        if contains(.layerMinXMaxYCorner) {
            result.insert(.bottomLeft)
        }
        return result
    }
}
