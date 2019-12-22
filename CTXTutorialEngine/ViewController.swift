//
//  ViewController.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 21/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let redView = UIView(frame: CGRect(x: 16, y: 50, width: 50, height: 50))
    let blueView = UIView(frame: CGRect(x: 100, y: 50, width: 100, height: 50))
    let pinkView = UIView(frame: CGRect(x: 230, y : 50, width: 70, height: 50))
    let greenView = UIView(frame: CGRect(x: 16, y: 150, width: 150, height: 100))
    let customView = UIView(frame: CGRect(x: 16, y: 300, width: 40, height: 60))
    let button = UIButton(type: .custom)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        redView.backgroundColor = .red
        blueView.backgroundColor = .blue
        pinkView.backgroundColor = UIColor(red: 1.0, green: 182/255.0, blue: 193/255.0, alpha: 1.0)
        greenView.backgroundColor = .green
        customView.backgroundColor = .brown
        
        
        redView.layer.mask = makeMaskShape()
        
        redView.accessibilityIdentifier = "redView"
        blueView.accessibilityIdentifier = "blueView"
        pinkView.accessibilityIdentifier = "pinkView"
        greenView.accessibilityIdentifier = "greenView"
        customView.accessibilityIdentifier = "myCustomView"
        button.accessibilityIdentifier = "button"
        
        button.backgroundColor =  UIColor(red: 100 / 255.0, green: 151 / 255.0, blue: 177 / 255.0, alpha: 1.0)
        button.setTitle("Tap me", for: .normal)
        button.titleLabel?.textColor = .white
        button.frame.size = CGSize(width: 100, height: 50)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        self.view.addSubview(redView)
        self.view.addSubview(blueView)
        self.view.addSubview(pinkView)
        self.view.addSubview(greenView)
        self.view.addSubview(customView)
        self.view.addSubview(button)
        
        button.center = view.center
        
        greenView.isHidden = true
        customView.alpha = 0
        
        CTXTutorialEngine.shared.observe(self, contentType: .dynamic)
        CTXTutorialEngine.shared.delegate = self
        CTXTutorialEngine.shared.start()
    }
    
    func makeMaskShape() -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 50), cornerRadius: 50).cgPath
        layer.fillColor = UIColor.red.cgColor
        
        return layer
    }
}

private extension ViewController {
    
    @objc func tap() {
        CTXTutorialEventBus.shared.push(MyEvent.tapButton)
    }
}

extension ViewController: CTXTutorialEngineDelegate {

    func engine(_ engine: CTXTutorialEngine,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel,
                previousStepHandler: VoidClosure?,
                nextStepHandler: VoidClosure?,
                closehandler: VoidClosure?) -> UIView? {
        
        let anchor = CGPoint(x: currentStepModel.views[0].frame.midX,
                             y: currentStepModel.views[0].frame.maxY + 16)
        let hintView = MyHintView(anchor: anchor)
        
        hintView.configure(with: currentStepModel.text,
                           snapshottedViews: currentStepModel.views,
                           previousStepHandler: previousStepHandler,
                           nextStepHandler: nextStepHandler,
                           closeTutorialHandler: closehandler)
        
        hintView.frame = CGRect(origin: anchor, size: hintView.sizeThatFits(view.bounds.size))
        
        hintView.center.x = view.center.x
        
        return hintView
    }
    
    func engineDidEndShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial) {
        
        if tutorial.id == 0 {
            greenView.isHidden = false
        }
        
        if tutorial.id == 1 {
            customView.alpha = 1
        }
        
        if tutorial.id == 2 {
            CTXTutorialEngine.shared.unobserve(self)
        }
    }
}
