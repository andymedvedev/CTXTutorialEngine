//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

class CTXTutorialModule {

    weak var delegate: CTXTutorialModuleDelegate?
    
    private var presenter: CTXTutorialPresenter?
    
    init() {
        
        let presenter = CTXTutorialPresenterImpl()
        let view = CTXTutorialContainerViewController()
        let router = CTXTutorialRouterImpl()
        
        view.presenter = presenter
        view.delegate = self
        router.tutorialViewController = view
        presenter.view = view
        presenter.router = router
        
        self.presenter = presenter
    }
    
    func presentTutorial(with stepModels: [CTXTutorialStepModel],
                         completion: @escaping () -> ()) {
        
        presenter?.presentTutorial(with: stepModels,
                                   completion: completion)
    }
    
    func closeTutorial() {
        presenter?.onHideTutorial()
    }
}

extension CTXTutorialModule: CTXTutorialContainerDelegate {
    
    func containerDidEndShowTutorial(_ container: CTXTutorialContainerViewController) {
        delegate?.moduleDidEndShowTutorial(self)
    }
    
    func containerWillShowTutorialStep(_ container: CTXTutorialContainerViewController,
                                       with stepInfo: CTXTutorialStepPresentationInfo) {
        delegate?.moduleWillShowTutorialStep(self, with: stepInfo)
    }
    
    func containerDidShowTutorialStep(_ container: CTXTutorialContainerViewController,
                                      with stepInfo: CTXTutorialStepPresentationInfo) {
        
        delegate?.moduleDidShowTutorialStep(self, with: stepInfo)
    }
    
    func container(_ container: CTXTutorialContainerViewController,
                   hintViewForTutorialWith currentStepModel: CTXTutorialStepModel,
                   isHavePreviousStep: Bool,
                   isHaveNextStep: Bool) -> CTXTutorialHintView? {
    
        return delegate?.module(self,
                                hintViewForTutorialWith: currentStepModel,
                                isHavePreviousStep: isHavePreviousStep,
                                isHaveNextStep: isHaveNextStep)
    }
}
