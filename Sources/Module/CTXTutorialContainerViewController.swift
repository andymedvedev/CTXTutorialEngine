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
    
    override var shouldAutorotate: Bool {
        return false
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
        let stepPresentationInfo = CTXTutorialStepPresentationInfo(stepIndex: currentStepIndex,
                                                                   stepsCount: totalStepsCount,
                                                                   stepModel: stepModel)
        var hintView = delegate?.container(self,
                                           hintViewForTutorialWith: stepModel,
                                           isHavePreviousStep: isHavePreviousStep,
                                           isHaveNextStep: isHaveNextStep)
        
        delegate?.containerWillShowTutorialStep(self, with: stepPresentationInfo)
        
        if hintView == nil && CTXTutorialEngine.shared.useDefaultHintView {
            hintView = CTXTutorialDefaultHintView(with: .init(step: stepModel,
            showBackButton: isHavePreviousStep,
            showNextButton: isHaveNextStep,
            showCloseButton: true))
        }
        
        hintView?.previousStepHandler = previousStepHandler()
        hintView?.nextStepHandler = nextStepHandler()
        hintView?.closeTutorialHandler = {
            [weak self] in
            
            self?.presenter?.onHideTutorial()
        }
        
        if let hintView = hintView {
            tutorialContainer.showStep(with: hintView, views: stepModel.views)
            CTXTutorialEngine.shared.defaultHintViewConfig.onAppear?(hintView)
        }
        
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
