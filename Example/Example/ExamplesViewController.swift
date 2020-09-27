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
    
    fileprivate enum ShapesTutorialStep: String, CaseIterable {
        case red, green, blue
    }
    
    fileprivate enum TutorialID: Int {
        case welcomeTutorial = 100
        case shapesButtonTutorial = 0
        case shapesTutorial = 1
        case cellTutorial = 2
    }
    
    private let libraryNameLabel = UILabel()
    private let libraryNameContainerView = UIView()
    private let redView = UIView()
    private let greenView = UIView()
    private let blueView = UIView()
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
        
        redView.backgroundColor = UIColor(named: "red")
        greenView.backgroundColor = UIColor(named: "green")
        blueView.backgroundColor = UIColor(named: "blue")
        button.backgroundColor = UIColor(named: "yellow")
        
        redView.layer.mask = roundLayer()
        greenView.layer.mask = triangleLayer()
        
        libraryNameContainerView.accessibilityIdentifier = "libraryNameContainer"
        redView.accessibilityIdentifier = "redView"
        greenView.accessibilityIdentifier = "greenView"
        blueView.accessibilityIdentifier = "blueView"
        button.accessibilityIdentifier = "button"
        
        let font = UIFont.systemFont(ofSize: 16)
        let attrString = NSMutableAttributedString()
        attrString.append(.init(string: "● ",
                                attributes: [
                                    .font: font,
                                    .foregroundColor: UIColor(named: "red") as Any,
        ]))
        attrString.append(.init(string: "▲ ",
                                attributes: [
                                    .font: font,
                                    .foregroundColor: UIColor(named: "green") as Any,
        ]))
        attrString.append(.init(string: "■",
                                attributes: [
                                    .font: font,
                                    .foregroundColor: UIColor(named: "blue") as Any,
        ]))
        button.setAttributedTitle(attrString, for: .normal)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        button.layer.cornerRadius = 10
        
        [redView, greenView, blueView, button, collectionView, libraryNameContainerView].forEach {
            view.addSubview($0)
            $0.alpha = .zero
        }
        
        libraryNameContainerView.alpha = 1
        libraryNameContainerView.addSubview(libraryNameLabel)
        libraryNameContainerView.layer.cornerRadius = 12
        
        libraryNameLabel.font = .systemFont(ofSize: 32)
        libraryNameLabel.text = "CTXTutorialEngine"
        libraryNameLabel.sizeToFit()
        
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLayout {
            isFirstLayout = false
            
            libraryNameContainerView.frame.size = CGSize(width: libraryNameLabel.frame.width + 32,
                                                         height: libraryNameLabel.frame.height + 32)
            libraryNameContainerView.center = view.center
            libraryNameLabel.center = CGPoint(x: libraryNameContainerView.bounds.midX,
                                              y: libraryNameContainerView.bounds.midY)
            [redView, greenView, blueView].forEach {
                $0.frame.size = CGSize(width: 50, height: 50)
                $0.center = view.center
            }
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

var animated = false

private extension ExamplesViewController {
    
    @objc func tap() {
        engine.closeCurrentTutorial()
        
        [redView, greenView, blueView].forEach {
            $0.transform = .identity
            $0.alpha = 1
        }

        UIView.animateKeyframes(withDuration: 2, delay: .zero, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.redView.transform = CGAffineTransform(translationX: -100, y: -100)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.25) {
                self.greenView.transform = CGAffineTransform(translationX: 0, y: -100)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.25) {
                self.blueView.transform = CGAffineTransform(translationX: 100, y: -100)
            }
        })
    }
    
    func animateLibraryNameShapesButton() {
        UIView.animate(withDuration: 1, delay: .zero, options: [.curveEaseOut], animations:  {
            self.libraryNameContainerView.transform = CGAffineTransform(translationX: 0, y: -200)
        }) {
            _ in
            
            UIView.animate(withDuration: 1) {
                self.button.alpha = 1
            }
        }
    }
    
    func animateCollectionView() {
        UIView.animate(withDuration: 1) {
            self.collectionView.alpha = 1
        }
    }
}

extension ExamplesViewController: CTXTutorialEngineDelegate {

    func preferredTutorialStatusBarStyle() -> UIStatusBarStyle? {
        return .lightContent
    }
    
    func engineWillShowTutorialStep(_ engine: CTXTutorialEngine, tutorial: CTXTutorial, with stepInfo: CTXTutorialStepPresentationInfo) {
        guard let tutorialId = TutorialID(rawValue: tutorial.id) else {
            print("cant create TutorialID with rawValue: \(tutorial.id)")
            return
        }
        
        let config = engine.defaultHintViewConfig
        let tintColor = tutorialId.tintColor
        config.gradientColors = tutorialId.gradientColors(for: stepInfo.stepIndex)
        config.textColor = tintColor
        config.backButtonTintColor = tintColor
        config.nextButtonTintColor = tintColor
        config.closeButtonTintColor = tintColor

    }
    
    func engineDidEndShow(_ engine: CTXTutorialEngine, tutorial: CTXTutorial) {
        guard let tutorialId = TutorialID(rawValue: tutorial.id) else {
            print("cant create TutorialID with rawValue: \(tutorial.id)")
            return
        }
        
        switch tutorialId {
        case .welcomeTutorial:
            animateLibraryNameShapesButton()
        case .shapesTutorial:
            animateCollectionView()
        default:
            break
        }
    }
}

extension ExamplesViewController.TutorialID {
    
    func gradientColors(for stepIndex: Int) -> [UIColor?] {
        let outerName: String
        let innerName: String
        
        switch self {
        case .welcomeTutorial:
            outerName = "violetLight"
            innerName = "violet"
        case .shapesButtonTutorial:
            outerName = "peach"
            innerName = "yellow"
        case .shapesTutorial:
            let shapeStep = ExamplesViewController.ShapesTutorialStep.allCases[stepIndex]
            switch shapeStep {
            case .red:
                outerName = "pink"
                innerName = "red"
            case .green:
                outerName = "greenLight"
                innerName = "green"
            case .blue:
                outerName = "blueLight"
                innerName = "blue"
            }
        case .cellTutorial:
            outerName = "atomicTangerine"
            innerName = "burntSienna"
        }
        
        return [outerName, innerName, innerName, outerName].map(UIColor.init(named:))
    }
    
    var tintColor: UIColor? {
        switch self {
        case .welcomeTutorial, .shapesTutorial:
            return UIColor(named: "yellow")
        case .shapesButtonTutorial:
            return UIColor(named: "regalBlue")
        case .cellTutorial:
            return .white
        }
    }
}
