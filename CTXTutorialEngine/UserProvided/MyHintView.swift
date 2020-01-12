//
//  MyHintView.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 08.12.2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public final class MyHintView: UIView {

    private var previousStepHandler: VoidClosure?
    private var nextStepHandler: VoidClosure?
    private var closeTutorialHandler: VoidClosure?

    private let textLabel = UILabel()
    private let buttonsStackView = UIStackView()
    private let horizontalInset: CGFloat = 16
    private let topInset: CGFloat = 8
    private let verticalSpacing: CGFloat = 16

    let anchor: CGPoint
    
    init(anchor: CGPoint) {
        self.anchor = anchor
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelSize = textLabel.sizeThatFits(CGSize(width: bounds.width - 2 * horizontalInset,
                                                      height: .greatestFiniteMagnitude))
        let stackSize = CGSize(width: 300, height: 50)
        
        textLabel.frame = CGRect(x: bounds.minX + horizontalInset,
                                 y: bounds.minY + topInset,
                                 width: labelSize.width,
                                 height: labelSize.height)
        
        buttonsStackView.frame = CGRect(x: bounds.minX,
                                    y: textLabel.frame.maxY + verticalSpacing,
                                    width: stackSize.width,
                                    height: stackSize.height)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = textLabel.sizeThatFits(CGSize(width: size.width - 2 * horizontalInset,
                                                      height: .greatestFiniteMagnitude))
        let stackSize = CGSize(width: 300, height: 50)
        
        return CGSize(width: max(labelSize.width + 2 * horizontalInset, stackSize.width),
                      height: labelSize.height + stackSize.height + verticalSpacing + topInset)
    }
    
    public func configure(with text: String?,
                          previousStepHandler: VoidClosure?,
                          nextStepHandler: VoidClosure?,
                          closeTutorialHandler: VoidClosure?) {
        
        self.previousStepHandler = previousStepHandler
        self.nextStepHandler = nextStepHandler
        self.closeTutorialHandler = closeTutorialHandler
        
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 13)
        
        let previousButton = UIButton(type: .custom)
        let nextButton = UIButton(type: .custom)
        let closeButton = UIButton(type: .custom)
        
        previousButton.addTarget(self, action: #selector(previousStep), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTutorial), for: .touchUpInside)

        previousButton.setTitle("PREV", for: .normal)
        nextButton.setTitle("NEXT", for: .normal)
        closeButton.setTitle("CLOSE", for: .normal)

        [previousButton, nextButton, closeButton].forEach {
            $0.backgroundColor = UIColor(red: 100 / 255.0, green: 151 / 255.0, blue: 177 / 255.0, alpha: 1.0)
            $0.setTitleColor(.white, for: .normal)
            $0.titleEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            
            buttonsStackView.addArrangedSubview($0)
        }
        
        previousButton.isHidden = previousStepHandler == nil
        nextButton.isHidden = nextStepHandler == nil
        closeButton.isHidden = closeTutorialHandler == nil
        
        buttonsStackView.axis = .horizontal
        buttonsStackView.addArrangedSubview(closeButton)
        buttonsStackView.distribution = .fillEqually
        
        self.addSubview(textLabel)
        self.addSubview(buttonsStackView)
        
        self.backgroundColor = .white
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.yellow.cgColor
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
