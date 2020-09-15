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
    
    private let redView = UIView(frame: CGRect(x: 16, y: 50, width: 50, height: 50))
    private let greenView = UIView(frame: CGRect(x: 100, y: 50, width: 100, height: 50))
    private let blueView = UIView(frame: CGRect(x: 230, y : 50, width: 70, height: 50))
    private let pinkView = UIView(frame: CGRect(x: 16, y: 150, width: 150, height: 100))
    private let customView = UIView(frame: CGRect(x: 16, y: 300, width: 40, height: 60))
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
        pinkView.backgroundColor = UIColor(red: 1.0, green: 182/255.0, blue: 193/255.0, alpha: 1.0)
        customView.backgroundColor = .brown
        
        redView.layer.mask = makeRoundShapeLayer()
        pinkView.layer.mask = makeStarShapeLayer()
        
        redView.accessibilityIdentifier = "redView"
        greenView.accessibilityIdentifier = "greenView"
        blueView.accessibilityIdentifier = "blueView"
        pinkView.accessibilityIdentifier = "pinkView"
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
        self.view.addSubview(pinkView)
        self.view.addSubview(customView)
        self.view.addSubview(button)
        
        button.center = view.center
        
        customView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        engine.observe(self, contentType: .dynamic)
        engine.delegate = self
        engine.start()
    }
    
    private func makeRoundShapeLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 50), cornerRadius: 50).cgPath
        
        return layer
    }
    
    private func makeStarShapeLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 45.25, y: 0))
        path.addLine(to: CGPoint(x: 61.13, y: 23))
        path.addLine(to: CGPoint(x: 88.29, y: 30.75))
        path.addLine(to: CGPoint(x: 70.95, y: 52.71))
        path.addLine(to: CGPoint(x: 71.85, y: 80.5))
        path.addLine(to: CGPoint(x: 45.25, y: 71.07))
        path.addLine(to: CGPoint(x: 18.65, y: 80.5))
        path.addLine(to: CGPoint(x: 19.55, y: 52.71))
        path.addLine(to: CGPoint(x: 2.21, y: 30.75))
        path.addLine(to: CGPoint(x: 29.37, y: 23))
        path.close()
        path.stroke()
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
        
        setNeedsStatusBarAppearanceUpdate()
        
        if tutorial.id == 0 {
            UIView.animate(withDuration: 2,
                           delay: .zero,
                            options: [.autoreverse, .curveEaseInOut, .repeat],
                            animations: {
                             self.pinkView.transform = CGAffineTransform.init(translationX: 100, y: 0)
             })
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
                _ in
                
                self.eventsBus.push(MyEvent.handlePinkView)
            }
        }
        
        if tutorial.id == 1 {
            customView.alpha = 1
        }
        
        if tutorial.id == 2 {
            engine.unobserve(self)
        }
    }
    
    func preferredTutorialStatusBarStyle() -> UIStatusBarStyle? {
        return .lightContent
    }
}
