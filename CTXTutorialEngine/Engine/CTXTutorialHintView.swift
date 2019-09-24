//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public typealias CTXTutorialHintViewType = (UIView & CTXTutorialHintViewProtocol)

public protocol CTXTutorialHintViewProtocol {
    
    func configure(with text: String?,
                   closeTutorialHandler: (() -> ())?,
                   nextStepHandler: (() -> ())?)
}

public final class CTXTutorialHintView: CTXTutorialHintViewType {

    public var closeTutorialHandler: (() -> ())?
    public var nextStepHandler: (() -> ())?

    private var text: String?
    
    public func configure(with text: String?,
                          closeTutorialHandler: (() -> ())?,
                          nextStepHandler: (() -> ())?) {
        
        self.text = text
        self.closeTutorialHandler = closeTutorialHandler
        self.nextStepHandler = nextStepHandler
        
        let textLabel = UILabel()
        
        textLabel.text = text
        textLabel.sizeToFit()
        
        let closeButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 70, height: 30)))
        let nextButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 70, height: 30)))
        let buttonsStack = UIStackView(frame: CGRect(x: 0, y: 70, width: 300, height: 30))
        
        closeButton.addTarget(self, action: #selector(closeTutorial), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        closeButton.setTitle("CLOSE", for: .normal)
        nextButton.setTitle("NEXT", for: .normal)
        closeButton.setTitleColor(.blue, for: .normal)
        nextButton.setTitleColor(.blue, for: .normal)
        
        buttonsStack.axis = .horizontal
        buttonsStack.addArrangedSubview(closeButton)
        buttonsStack.distribution = .fill
        
        if nextStepHandler != nil {
            buttonsStack.addArrangedSubview(nextButton)
        }
        
        self.frame = CGRect(x: 100, y: 150, width: 300, height: 100)
        self.addSubview(textLabel)
        self.addSubview(buttonsStack)
        self.backgroundColor = .white
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.yellow.cgColor
    }
}

private extension CTXTutorialHintView {
    
    @objc func nextStep() {
        self.nextStepHandler?()
    }
    
    @objc func closeTutorial() {
        self.closeTutorialHandler?()
    }
}
