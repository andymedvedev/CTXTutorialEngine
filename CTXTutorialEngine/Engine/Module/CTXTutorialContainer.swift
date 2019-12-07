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
        
        darkOverlay.addGestureRecognizer(tapGesture)
        darkOverlay.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(backgroundSnapshot: UIView,
                   overlayColor: UIColor,
                   closeHandler: @escaping () -> Void) {
        
        self.closeHandler = closeHandler
        darkOverlay.backgroundColor = overlayColor
        
        addSubview(backgroundSnapshot)
        addSubview(darkOverlay)
        
        NSLayoutConstraint.activate([
            darkOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            darkOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            darkOverlay.topAnchor.constraint(equalTo: topAnchor),
            darkOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func showNextStep(with hintView: CTXTutorialHintViewType, snapshots: [UIView]) {
        
        self.hintView?.removeFromSuperview()
        self.snapshots?.forEach{ $0.removeFromSuperview() }
        
        self.hintView = hintView
        self.snapshots = snapshots
        
        if let snapshots = self.snapshots {
            snapshots.forEach{ addSubview($0) }
        }
        
        if let hintView = self.hintView {
            addSubview(hintView)
            hintView.center = center
        }
    }
}

private extension CTXTutorialContainerView {
    
    @objc func closeTutorial() {
        closeHandler?()
    }
}
