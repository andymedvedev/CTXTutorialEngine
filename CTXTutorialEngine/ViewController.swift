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
    let greenView = UIView(frame: CGRect(x: 16, y: 150, width: 150, height: 100))
    let customView = UIView(frame: CGRect(x: 16, y: 300, width: 40, height: 60))
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        self.redView.backgroundColor = .red
        self.blueView.backgroundColor = .blue
        self.greenView.backgroundColor = .green
        self.customView.backgroundColor = .brown
        
        
        self.redView.layer.mask = self.makeMaskShape()
        
        self.redView.accessibilityIdentifier = "redView"
        self.blueView.accessibilityIdentifier = "blueView"
        self.greenView.accessibilityIdentifier = "greenView"
        self.customView.accessibilityIdentifier = "myCustomView"
        
        self.view.addSubview(self.redView)
        self.view.addSubview(self.blueView)
        self.view.addSubview(self.greenView)
        self.view.addSubview(self.customView)
        
        self.greenView.isHidden = true
        self.customView.alpha = 0
        
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

extension ViewController: CTXTutorialEngineDelegate {
    
    func engineDidEndShow(tutorial: CTXTutorial) {
        
        if tutorial.id == 0 {
            self.greenView.isHidden = false
        }

        
        if tutorial.id == 1 {
            self.customView.alpha = 1
        }
        
        if tutorial.id == 100 {
            CTXTutorialEngine.shared.unobserve(self)
        }
    }
}
