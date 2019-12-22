//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

final class CTXTutorialContainerView: UIView {
    
    private var safeAreaGetter: (() -> (CGFloat, CGFloat))?
    private var closeHandler: (() -> Void)?
    private var hintView: UIView?
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        darkOverlay.frame = self.bounds
    }
    
    func configure(backgroundSnapshot: UIView,
                   overlayColor: UIColor,
                   closeHandler: @escaping () -> Void) {
        
        self.closeHandler = closeHandler
        darkOverlay.backgroundColor = overlayColor
        
        addSubview(backgroundSnapshot)
        addSubview(darkOverlay)
    }
    
    func showStep(with hintView: UIView, snapshots: [UIView]) {
        
        self.hintView?.removeFromSuperview()
        self.snapshots?.forEach{ $0.removeFromSuperview() }
        
        self.hintView = hintView
        self.snapshots = snapshots
        
        if let snapshots = self.snapshots {
            snapshots.forEach{ addSubview($0) }
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
}
