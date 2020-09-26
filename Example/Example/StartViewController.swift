//
//  MainViewController.swift
//  SceneDelegateExample
//
//  Created by Andrey Medvedev on 24.09.2020.
//  Copyright © 2020 Andrey Medvedev. All rights reserved.
//

import UIKit

final class StartViewController: UIViewController {
    
    private let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.setTitle("Start", for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 26)
        startButton.addTarget(self, action: #selector(start(_:)), for: .touchUpInside)
        startButton.sizeToFit()
        
        view.backgroundColor = .white
        view.addSubview(startButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        startButton.center = view.center
    }
    
    @objc private func start(_ sender: UIButton) {
        let examplesVC = ExamplesViewController()
        
        present(examplesVC, animated: true)
    }
}
