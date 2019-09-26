//
//  ViewController.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 21/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

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
        
        let redView = UIView(frame: CGRect(x: 16, y: 50, width: 160, height: 160))
        let blueView = UIView(frame: CGRect(x: 210, y: 100, width: 100, height: 60))
        
        redView.backgroundColor = .red
        redView.layer.mask = self.makeShape()
        blueView.backgroundColor = .blue
        
        redView.accessibilityIdentifier = "redView"
        blueView.accessibilityIdentifier = "blueView"
        
        self.view.addSubview(redView)
        self.view.addSubview(blueView)
        
        CTXTutorialEngine.shared.observe(self, contentType: .dynamic)
        CTXTutorialEngine.shared.delegate = self
        CTXTutorialEngine.shared.start()
    }
    
    func makeShape() -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 40, y: 40, width: 50, height: 50), cornerRadius: 50).cgPath
        layer.fillColor = UIColor.red.cgColor
        
        return layer
    }
}

extension ViewController: CTXTutorialEngineDelegate {
    
    func engineDidEndShow(tutorial: CTXTutorial) {
        
        let greenView = UIView(frame: CGRect(x: 150, y: 150, width: 150, height: 150))
        
        greenView.backgroundColor = .green
        greenView.accessibilityIdentifier = "greenView"
        self.view.addSubview(greenView)
        
        if tutorial.id == 1 {
            CTXTutorialEngine.shared.unobserve(self)
        }
    }
}
