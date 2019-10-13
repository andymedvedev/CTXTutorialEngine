//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

final class CTXTutorialContainerView: UIView {
    
    private var safeAreaGetter: (() -> (CGFloat, CGFloat))?
    private var closeHandler: (() -> Void)?
    private var hintView: CTXTutorialHintViewType?
    private var snapshots: [UIView]?
    private let darkOverlay = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTutorial))
        
        self.darkOverlay.addGestureRecognizer(tapGesture)
        self.darkOverlay.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(backgroundSnapshot: UIView,
                   overlayColor: UIColor,
                   closeHandler: @escaping () -> Void) {
        
        self.closeHandler = closeHandler
        self.darkOverlay.backgroundColor = overlayColor
        self.addSubview(backgroundSnapshot)
        self.addSubview(self.darkOverlay)
        
        NSLayoutConstraint.activate([
            self.darkOverlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.darkOverlay.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.darkOverlay.topAnchor.constraint(equalTo: self.topAnchor),
            self.darkOverlay.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    func showNextStep(with hintView: CTXTutorialHintViewType, snapshots: [UIView]) {
        
        self.hintView?.removeFromSuperview()
        self.snapshots?.forEach{ $0.removeFromSuperview() }
        
        self.hintView = hintView
        self.snapshots = snapshots
        
        if let snapshots = self.snapshots {
            snapshots.forEach{ self.addSubview($0) }
        }
        
        if let hintView = self.hintView {
            self.addSubview(hintView)
            hintView.center = self.center
        }
    }
}

private extension CTXTutorialContainerView {
    
    @objc func closeTutorial() {
        self.closeHandler?()
    }
    
    func centerHintViewX() {
//        guard let hintView = self.hintView else { return }
//
//        if self.destinationSnapshot.center.x -
//            hintView.frame.width / 2 -
//            16 <= self.frame.minX {
//
//            hintView.frame.origin.x = 16
//        } else if self.destinationSnapshot.center.x +
//            hintView.frame.width / 2 +
//            16 >= self.frame.maxX {
//
//            hintView.frame.origin.x = self.frame.maxX -
//                                           hintView.frame.width - 16
//        } else {
//
//            hintView.center.x = self.destinationSnapshot.center.x
//        }
    }
    
    func centerHintViewY() {
//        self.hintView?.center.y = self.destinationSnapshot.center.y
    }
    
    func placeTextContainer() {
        
//        guard let (topSafeArea, bottomSafeArea) = self.safeAreaGetter?() else { return }
//        guard let hintView = self.hintView else { return }
//
//        if hintView.frame.width > self.frame.width - 32 {
//            hintView.fitSize(with: self.frame.width - 32)
//            return
//        }
//
//        let height = hintView.frame.height
//        let width = hintView.frame.width
//        let minX = self.destinationSnapshot.frame.minX
//        let maxX = self.destinationSnapshot.frame.maxX
//        let minY = self.destinationSnapshot.frame.minY
//        let maxY = self.destinationSnapshot.frame.maxY
//        var arrowStart: CGPoint = .zero
//        var arrowEnd: CGPoint = .zero
//
//        let minSpaceAddition: CGFloat = 64
//        let topSpace = minY - topSafeArea
//        let bottomSpace = self.frame.maxY - bottomSafeArea - maxY
//        let leftSpace = minX
//        let rightSpace = self.frame.maxX - maxX
//        var needArrow = true
//
//        defer {
//            if needArrow {
//                let arrowLayer = ArrowLayer(start: arrowStart, end: arrowEnd)
//
//                self.layer.addSublayer(arrowLayer)
//            }
//        }
//
//        if topSpace > bottomSpace && topSpace >= height + minSpaceAddition {
//
//            hintView.frame.origin.y = minY - height - 48
//            self.centerHintViewX()
//
//            arrowStart = CGPoint(x: hintView.midX,
//                                 y: hintView.maxY)
//            arrowEnd = CGPoint(x: self.destinationSnapshot.frame.midX,
//                               y: self.destinationSnapshot.frame.minY)
//            return
//        } else if bottomSpace >= height + minSpaceAddition {
//
//            hintView.frame.origin.y = maxY + 48
//            self.centerHintViewX()
//
//            arrowStart = CGPoint(x: hintView.midX,
//                                 y: hintView.minY)
//            arrowEnd = CGPoint(x: self.destinationSnapshot.frame.midX,
//                               y: self.destinationSnapshot.frame.maxY)
//            return
//        }
//
//        if leftSpace > rightSpace && leftSpace >= width + minSpaceAddition {
//
//            hintView.frame.origin.x = minX - width - 48
//            self.centerHintViewY()
//
//            arrowStart = CGPoint(x: hintView.maxX,
//                                 y: hintView.midY)
//            arrowEnd = CGPoint(x: self.destinationSnapshot.frame.minX,
//                               y: self.destinationSnapshot.frame.midY)
//            return
//        } else if rightSpace >= width + minSpaceAddition {
//
//            hintView.frame.origin.x = maxX + 48
//            self.centerHintViewY()
//
//            arrowStart = CGPoint(x: hintView.minX,
//                                 y: hintView.midY)
//            arrowEnd = CGPoint(x: self.destinationSnapshot.frame.maxX,
//                               y: self.destinationSnapshot.frame.midY)
//            return
//        }
//
//        needArrow = false
//
//        hintView.center = self.destinationSnapshot.center
    }
}
