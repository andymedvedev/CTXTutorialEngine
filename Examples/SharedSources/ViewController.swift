//
//  ViewController.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 21/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit
import CTXTutorialEngine

class ViewController: UIViewController {
    
    private let redView = UIView(frame: CGRect(x: -50, y: 50, width: 50, height: 50))
    private let greenView = UIView(frame: CGRect(x: -150, y: 150, width: 50, height: 50))
    private let blueView = UIView(frame: CGRect(x: -250, y : 250, width: 50, height: 50))
    private let customView = UIView(frame: CGRect(x: 0, y: 350, width: 40, height: 60))
    private let button = UIButton(type: .custom)
    
    private let engine = CTXTutorialEngine.shared
    private let eventsBus = CTXTutorialEventBus.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        redView.backgroundColor = .red
        blueView.backgroundColor = .blue
        greenView.backgroundColor = .green
        customView.backgroundColor = .systemPink
        
        redView.layer.mask = roundLayer()
        greenView.layer.mask = triangleLayer()
        
        redView.accessibilityIdentifier = "redView"
        greenView.accessibilityIdentifier = "greenView"
        blueView.accessibilityIdentifier = "blueView"
        customView.accessibilityIdentifier = "myCustomView"
        button.accessibilityIdentifier = "button"
        
        button.backgroundColor =  UIColor(red: 100 / 255.0, green: 151 / 255.0, blue: 177 / 255.0, alpha: 1.0)
        button.setTitle("Tap me", for: .normal)
        button.titleLabel?.textColor = .white
        button.frame.size = CGSize(width: 100, height: 50)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        self.view.addSubview(redView)
        self.view.addSubview(greenView)
        self.view.addSubview(blueView)
        self.view.addSubview(customView)
        self.view.addSubview(button)
        
        customView.center.x = view.center.x
        button.center.x = view.center.x
        button.frame.origin.y = customView.frame.maxY + 50
        
        customView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        engine.observe(self, contentType: .dynamic)
        engine.delegate = self
        engine.start()
        
        UIView.animate(withDuration: 2,
                      delay: .zero,
                       options: [.autoreverse, .curveEaseInOut, .repeat],
                       animations: {
                        self.redView.transform = CGAffineTransform(translationX: 100, y: 0)
                        self.greenView.transform = CGAffineTransform(translationX: 200, y: 0)
                        self.blueView.transform = CGAffineTransform(translationX: 300, y: 0)
        })
    }
    
    private func roundLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 50), cornerRadius: 50).cgPath
        
        return layer
    }
    
    private func triangleLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 50))
        path.addLine(to: CGPoint(x: 25, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 50))
        path.close()
        path.fill()
        layer.path = path.cgPath
        
        return layer
    }
}

private extension ViewController {
    
    @objc func tap() {
        eventsBus.push(MyEvent.tapButton)
    }
}

extension ViewController: CTXTutorialEngineDelegate {

    func preferredTutorialStatusBarStyle() -> UIStatusBarStyle? {
        return .lightContent
    }
    
    func engine(_ engine: CTXTutorialEngine,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel,
                isHavePreviousStep: Bool,
                isHaveNextStep: Bool) -> CTXTutorialHintView? {
        
        let origin = CGPoint(x: currentStepModel.views[0].frame.midX,
                             y: currentStepModel.views[0].frame.maxY + 16)
        let hintView = MyHintView()
        
        hintView.configure(with: currentStepModel.text,
                           isHavePreviousStep: isHavePreviousStep,
                           isHaveNextStep: isHaveNextStep,
                           isHaveCloseButton: true)
        
        hintView.frame = CGRect(origin: origin, size: hintView.sizeThatFits(view.bounds.size))
        
        hintView.center.x = view.center.x
        
        return hintView
    }
    
    func engineDidEndShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial) {
        if tutorial.id == 0 {
            customView.alpha = 1
        }
        
        if tutorial.id == 1 {
            engine.unobserve(self)
        }
    }
}
