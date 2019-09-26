//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

enum SnapshotError: Error {
    
    case snapshotFailed
    
}


final class CTXTutorialContainerViewController: UIViewController {
    
    var presenter: CTXTutorialPresenter?
    
    private weak var delegate: CTXTutorialEngineDelegate?
    
    private var snapshotStepModels = [CTXTutorialStepModel]()
    
    private var tutorial: CTXTutorial?
    private let tutorialContainer = CTXTutorialContainerView()
    private var currentStep = 0
    private var totalStepsCount = 1
    private var statusBarStyle: UIStatusBarStyle?
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle ?? .default
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.tutorialContainer
    }
}

extension CTXTutorialContainerViewController: CTXTutorialView {
    
    func show(_ tutorial: CTXTutorial,
              with stepModels: [CTXTutorialStepModel],
              and delegate: CTXTutorialEngineDelegate?) {
        
        self.tutorial = tutorial
        self.delegate = delegate
        self.totalStepsCount = stepModels.count

        let window = UIApplication.shared.keyWindow
        
        guard let backgroundVC = UIApplication.getTopViewController(),
            let backgroundView = backgroundVC.view,
            let backgroundSnapshot = backgroundView.snapshotView(afterScreenUpdates: true) else { return }
        
        window?.pause()
        
        var topPresentedVC: UIViewController? = backgroundVC
        
        while let presentedVC = topPresentedVC?.presentedViewController {
            topPresentedVC = presentedVC
        }
        
        if topPresentedVC === backgroundVC {
            topPresentedVC = nil
        }
        
        
        self.statusBarStyle = backgroundVC.preferredStatusBarStyle
        
        self.snapshotStepModels = self.getSnapshotsModels(by: stepModels)
        
        if let topPresentedVC = topPresentedVC {
            
            let presentedViewSnapshot = topPresentedVC.view.snapshotView(afterScreenUpdates: true)
            
            if let presentedViewSnapshot = presentedViewSnapshot,
                let presentedView = topPresentedVC.view {
                
                let cornerRadius = delegate?.cornerRadiusForModalViewSnapshot() ?? CTXTutorialConstants.modalViewCornerRaius
                
                presentedViewSnapshot.frame.origin = presentedView.convert(CGPoint.zero, to: nil)
                presentedViewSnapshot.layer.cornerRadius = cornerRadius
                presentedViewSnapshot.layer.masksToBounds = true
                
                self.statusBarStyle = topPresentedVC.preferredStatusBarStyle
                
                backgroundSnapshot.addSubview(presentedViewSnapshot)
            }
        }

        let overlayColor = delegate?.tutorialOverlayColor() ?? CTXTutorialConstants.tutorialOverlayColor
        
        self.tutorialContainer.configure(backgroundSnapshot: backgroundSnapshot,
                                         overlayColor: overlayColor) { [weak self] in
            
            self?.presenter?.onHideTutorial()
        }
        
        self.presenter?.onTutorialPrepared(startHandler: { [weak self] in
                                               self?.onNextStep()
                                           },
                                           cleaningCallback: { [weak self, weak window] in
                                            
                                                if let tutorial = self?.tutorial {
                                                    delegate?.engineDidEndShow(tutorial: tutorial)
                                                }
                                            
                                                self?.presenter = nil
                                                window?.resume()
                                           })
    }
}

private extension CTXTutorialContainerViewController {

    //TODO: work with it
//    func getSafeArea() {
//        let topSafeArea: CGFloat
//        let bottomSafeArea: CGFloat
//
//        self?.view.layoutIfNeeded()
//
//        if #available(iOS 11.0, *) {
//            topSafeArea = self?.view.safeAreaInsets.top ?? 0
//            bottomSafeArea = self?.view.safeAreaInsets.bottom ?? 0
//        } else {
//            topSafeArea = self?.topLayoutGuide.length ?? 0
//            bottomSafeArea = self?.bottomLayoutGuide.length ?? 0
//        }
//
//        return (topSafeArea, bottomSafeArea)
//    }
    
    func getSnapshotsModels(by stepModels: [CTXTutorialStepModel]) -> [CTXTutorialStepModel] {
        
        let snapshotsModels = stepModels.map { model -> CTXTutorialStepModel in
            
            let snapshots = model.views.compactMap{ view -> UIView? in
                
                let snapshot = view.snapshotView(afterScreenUpdates: true)

                snapshot?.accessibilityIdentifier = view.accessibilityIdentifier
                snapshot?.frame.origin = view.convert(CGPoint.zero, to: nil)
                snapshot?.layer.cornerRadius = view.layer.cornerRadius
                snapshot?.layer.masksToBounds = true

                return snapshot
            }
            
            return CTXTutorialStepModel(text: model.text,
                                                     views: snapshots)
        }
        
        return snapshotsModels
    }
    
    func onNextStep() {
        
        guard let tutorial = self.tutorial else { return }
        
        let snapshotStepModel = self.snapshotStepModels.removeFirst()
        
        let hintView: CTXTutorialHintViewType
        
        if let customHintView = self.delegate?.hintViewFor(for: tutorial, with: snapshotStepModel) {
            
            hintView = customHintView
        } else {
            
            hintView = CTXTutorialHintView()
        }
        
        var nextStepHandler: (() -> ())?
        
        if !self.snapshotStepModels.isEmpty {
            nextStepHandler = { [weak self] in
                self?.onNextStep()
            }
        }
        
        hintView.configure(with: snapshotStepModel.text,
                           closeTutorialHandler: { [weak self] in
                            self?.presenter?.onHideTutorial()
                           }, nextStepHandler: nextStepHandler)
        
        let stepPresentationInfo = CTXTutorialStepPresentationInfo(step: self.currentStep,
                                                                   stepsCount: self.totalStepsCount,
                                                                   stepModel: snapshotStepModel)
        
        self.tutorialContainer.showNextStep(with: hintView, snapshots: snapshotStepModel.views)
        self.delegate?.engineDidShowTutorialStep(tutorial: tutorial, with: stepPresentationInfo)
        self.currentStep += 1
    }
}
