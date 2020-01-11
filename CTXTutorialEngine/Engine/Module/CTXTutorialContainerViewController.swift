//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

enum SnapshotError: Error {
    
    case snapshotFailed
}


final class CTXTutorialContainerViewController: UIViewController {
    
    var presenter: CTXTutorialPresenter?
    
    weak var delegate: CTXTutorialContainerDelegate?
    
    private var snapshotStepModels = [CTXTutorialStepModel]()
    
    private let tutorialContainer = CTXTutorialContainerView()
    private var currentStepIndex = 0
    private var totalStepsCount = 1
    private var statusBarStyle: UIStatusBarStyle? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle ?? .default
    }
    
    override func loadView() {
        super.loadView()
        
        view = tutorialContainer
    }
}

extension CTXTutorialContainerViewController: CTXTutorialView {
    
    func show(with stepModels: [CTXTutorialStepModel]) {
        
        totalStepsCount = stepModels.count

        let window = UIApplication.shared.keyWindow
        
        guard let backgroundVC = UIApplication.getTopViewController(),
            let backgroundView = backgroundVC.view,
            let backgroundSnapshot = backgroundView.snapshotView(afterScreenUpdates: true) else { return }
        
        window?.pause()
        
        statusBarStyle =  delegate?.preferredStatusBarStyle() ?? backgroundVC.preferredStatusBarStyle
        
        snapshotStepModels = getSnapshotsModels(by: stepModels)
        
        configure(backgroundSnapshot: backgroundSnapshot, by: backgroundVC)

        let overlayColor = delegate?.tutorialOverlayColor() ?? CTXTutorialConstants.tutorialOverlayColor
        
        tutorialContainer.configure(backgroundSnapshot: backgroundSnapshot,
                                    overlayColor: overlayColor) { [weak self] in
                                        self?.presenter?.onHideTutorial()
        }
        
        presenter?.onTutorialPrepared(startHandler: { [weak self] in
                                         self?.handleStep()
                                      },
                                      cleaningBlock: { [weak self] in
                                         if let self = self {
                                             self.delegate?.containerDidEndShowTutorial(self)
                                         }
                                                
                                         self?.presenter = nil
                                         window?.resume()
                                      })
    }
}

private extension CTXTutorialContainerViewController {
    
    func topPresentedVC(by backgroundVC: UIViewController) -> UIViewController? {
        var topPresentedVC: UIViewController? = backgroundVC
        
        while let presentedVC = topPresentedVC?.presentedViewController {
            topPresentedVC = presentedVC
        }
        
        if topPresentedVC === backgroundVC {
            topPresentedVC = nil
        }
        
        return topPresentedVC
    }
    
    func configure(backgroundSnapshot: UIView, by backgroundVC: UIViewController) {
        if let topPresentedVC = topPresentedVC(by: backgroundVC) {
            
            let presentedViewSnapshot = topPresentedVC.view.snapshotView(afterScreenUpdates: true)
            
            if let presentedViewSnapshot = presentedViewSnapshot,
                let presentedView = topPresentedVC.view {
                
                let cornerRadius = delegate?.cornerRadiusForModalViewSnapshot() ?? CTXTutorialConstants.modalViewCornerRaius
                
                presentedViewSnapshot.frame.origin = presentedView.convert(CGPoint.zero, to: nil)
                presentedViewSnapshot.layer.cornerRadius = cornerRadius
                presentedViewSnapshot.layer.masksToBounds = true
                
                statusBarStyle = delegate?.preferredStatusBarStyle() ?? topPresentedVC.preferredStatusBarStyle
                
                backgroundSnapshot.addSubview(presentedViewSnapshot)
            }
        }
    }
    
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
    
    func onPreviousStep() {
        currentStepIndex -= 1
        
        handleStep()
    }
    
    func onNextStep() {
        currentStepIndex += 1
        
        handleStep()
    }
    
    func handleStep() {
        let snapshotStepModel = snapshotStepModels[currentStepIndex]

        let customHintView = delegate?.container(self,
                                                 hintViewForTutorialWith: snapshotStepModel,
                                                 previousStepHandler: previousStepHandler(),
                                                 nextStepHandler: nextStepHandler(),
                                                 closehandler:{ [weak self] in
                                                    self?.presenter?.onHideTutorial()
                                                 })
        
        if let customHintView = customHintView {
            tutorialContainer.showStep(with: customHintView, snapshots: snapshotStepModel.views)
        }
    
        let stepPresentationInfo = CTXTutorialStepPresentationInfo(stepIndex: currentStepIndex,
                                                                   stepsCount: totalStepsCount,
                                                                   stepModel: snapshotStepModel)
        
        delegate?.containerDidShowTutorialStep(self, with: stepPresentationInfo)
    }
    
    func previousStepHandler() -> VoidClosure? {
        var handler: VoidClosure?
        
        if currentStepIndex > 0 {
            handler = { [weak self] in
                self?.onPreviousStep()
            }
        }
        
        return handler
    }
    
    func nextStepHandler() -> VoidClosure? {
        var handler: VoidClosure?
        
        if currentStepIndex < totalStepsCount - 1 {
            handler = { [weak self] in
                self?.onNextStep()
            }
        }
        
        return handler
    }
}
