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
    
    private var stepModels = [CTXTutorialStepModel]()
    
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
        self.stepModels = stepModels
                
        let overlayColor = delegate?.tutorialOverlayColor() ?? CTXTutorialConstants.tutorialOverlayColor
        
        tutorialContainer.configure(overlayColor: overlayColor) {
            [weak self] in
            
            self?.presenter?.onHideTutorial()
        }
        
        presenter?.onTutorialPrepared(startHandler: {
            [weak self] in
            
            self?.handleStep()
            },
            cleaningBlock: {
                [weak self] in
                if let self = self {
                    self.delegate?.containerDidEndShowTutorial(self)
                }
                
                self?.presenter = nil
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
    
    func onPreviousStep() {
        currentStepIndex -= 1
        
        handleStep()
    }
    
    func onNextStep() {
        currentStepIndex += 1
        
        handleStep()
    }
    
    func handleStep() {
        let stepModel = stepModels[currentStepIndex]
        let isHavePreviousStep = totalStepsCount > 1 && currentStepIndex > 0
        let isHaveNextStep = totalStepsCount > 1 && currentStepIndex < totalStepsCount - 1
        
        var hintView: CTXTutorialHintView
        
        if CTXTutorialEngine.shared.useDefaultHintView {
            
        }
        let customHintView = delegate?.container(self,
                                                 hintViewForTutorialWith: stepModel,
                                                 isHavePreviousStep: isHavePreviousStep,
                                                 isHaveNextStep: isHaveNextStep)
        
        customHintView?.previousStepHandler = previousStepHandler()
        customHintView?.nextStepHandler = nextStepHandler()
        customHintView?.closeTutorialHandler = {
            [weak self] in
            
            self?.presenter?.onHideTutorial()
        }
        
        if let customHintView = customHintView {
            tutorialContainer.showStep(with: customHintView, views: stepModel.views)
        }
    
        let stepPresentationInfo = CTXTutorialStepPresentationInfo(stepIndex: currentStepIndex,
                                                                   stepsCount: totalStepsCount,
                                                                   stepModel: stepModel)
        
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
