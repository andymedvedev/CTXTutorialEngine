//
//  ViewController.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 21/09/2019.
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit
import CTXTutorialEngine

class ExamplesViewController: UIViewController, CTXTutorialShowing {
    
    private let redView = UIView()
    private let greenView = UIView()
    private let blueView = UIView()
    private let customView = UIView(frame: CGRect(x: 0, y: 350, width: 40, height: 60))
    private let button = UIButton(type: .system)
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CollectionCell.cellSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var isTutorialShowing: Bool = false
    
    private let engine = CTXTutorialEngine.shared
    private var isFirstLayout = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isTutorialShowing {
            return .lightContent
        } else {
            return .darkContent
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
        button.tintColor = .yellow
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(redView)
        view.addSubview(greenView)
        view.addSubview(blueView)
        view.addSubview(customView)
        view.addSubview(button)
        view.addSubview(collectionView)
        
        customView.center.x = view.center.x
        button.center.x = view.center.x
        button.frame.origin.y = customView.frame.maxY + 50
        
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseId)
        
        customView.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLayout {
            isFirstLayout = false
            
            redView.frame = CGRect(x: 50, y: -50, width: 50, height: 50)
            greenView.frame = CGRect(x: view.center.x - 25, y: -150, width: 50, height: 50)
            blueView.frame = CGRect(x: view.bounds.maxX - 100, y : -250, width: 50, height: 50)
            button.frame.size = CGSize(width: 100, height: 50)
            button.center = view.center
            collectionView.frame = CGRect(x: 0,
                                          y: view.bounds.height - view.safeAreaInsets.bottom - 150,
                                          width: view.bounds.width,
                                          height: CollectionCell.cellSize.height)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        engine.observe(self, contentType: .dynamic)
        engine.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        engine.unobserve(self)
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
        layer.path = path.cgPath
        
        return layer
    }
}

extension ExamplesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseId, for: indexPath) as? CollectionCell {
            cell.configure(by: indexPath.item)
            return cell
        } else {
            fatalError("Can't dequeue cell")
        }
    }
}

private extension ExamplesViewController {
    
    @objc func tap() {
        engine.closeCurrentTutorial()
    }
}

extension ExamplesViewController: CTXTutorialEngineDelegate {

    func preferredTutorialStatusBarStyle() -> UIStatusBarStyle? {
        return .lightContent
    }
    
    func engineDidEndShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial) {
        if tutorial.id == 0 {
            let safeAreaTop = view.safeAreaInsets.top
            
            UIView.animate(withDuration: 2, delay: .zero, options: [.curveEaseInOut], animations: {
                self.redView.transform = CGAffineTransform(translationX: .zero, y: safeAreaTop + 100)
                self.greenView.transform = CGAffineTransform(translationX: .zero, y: safeAreaTop + 200)
                self.blueView.transform = CGAffineTransform(translationX: .zero, y: safeAreaTop + 300)
            })
        } else if tutorial.id == 1 {
            customView.alpha = 1
            UIView.animate(withDuration: 2,
                          delay: .zero,
                           options: [.curveEaseInOut],
                           animations: {
                            self.customView.transform = CGAffineTransform(translationX: 0, y: 100)
            })
        }
    }
}
