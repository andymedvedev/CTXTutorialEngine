//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

final class CTXTutorialContainerView: UIView {
    
    private var closeHandler: (() -> Void)?
    private var hintView: UIView?
    private let darkOverlay = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTutorial))
        
        darkOverlay.addGestureRecognizer(tapGesture)
        darkOverlay.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        darkOverlay.frame = self.bounds
    }
    
    func configure(overlayColor: UIColor,
                   closeHandler: @escaping () -> Void) {
        
        self.closeHandler = closeHandler
        darkOverlay.backgroundColor = overlayColor
        
        addSubview(darkOverlay)
    }
    
    func showStep(with hintView: UIView, views: [UIView]) {
        
        self.hintView?.removeFromSuperview()
        
        self.hintView = hintView
        
        if let view = views.first {
            let mask = maskLayer(for: view)
            darkOverlay.layer.mask = mask
            darkOverlay.clipsToBounds = true
        }
        
        if let hintView = self.hintView {
            addSubview(hintView)
        }
    }
}

private extension CTXTutorialContainerView {
    
    @objc func closeTutorial() {
        closeHandler?()
    }
    
    func maskLayer(for view: UIView) -> CALayer? {
        guard let origin = view.layer.presentation()?.frame.origin else {
            return nil
        }
        
        let maskLayer = CAShapeLayer()
        let layer = view.layer
        let maskedCorners = layer.maskedCorners

        let bezierPath = UIBezierPath(rect: darkOverlay.bounds)
        var subPath = UIBezierPath()
        
        if layer.cornerRadius == .zero {
            if let path = (layer as? CAShapeLayer)?.path {
                subPath.cgPath = path
            } else if let maskShapeLayerPath = (layer.mask as? CAShapeLayer)?.path {
                subPath.cgPath = maskShapeLayerPath
            } else {
                subPath = UIBezierPath(rect: view.bounds)
            }
        } else if let maskPath = (view.mask?.layer as? CAShapeLayer)?.path {
            subPath.cgPath = maskPath
        } else {
            subPath = UIBezierPath(roundedRect: layer.bounds,
                                   byRoundingCorners: maskedCorners.asRectCorner,
                                   cornerRadii: CGSize(width: layer.cornerRadius,
                                                       height: layer.cornerRadius))
        }
        
        subPath.apply(CGAffineTransform(translationX: origin.x, y: origin.y))
        bezierPath.append(subPath)
        maskLayer.path = bezierPath.cgPath
        maskLayer.fillRule = .evenOdd
        
        return maskLayer
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
