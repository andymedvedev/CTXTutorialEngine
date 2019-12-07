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
        router.rootViewController = view
        presenter.view = view
        presenter.router = router
        
        self.presenter = presenter
    }
    
    func present(_ tutorial: CTXTutorial,
                 with stepModels: [CTXTutorialStepModel],
                 completion: @escaping () -> ()) {
        
        self.presenter?.present(tutorial,
                                with: stepModels,
                                completion: completion)
    }
}

extension CTXTutorialModule: CTXTutorialContainerDelegate {
    
    func containerDidEndShow(_ container: CTXTutorialContainerViewController, tutorial: CTXTutorial) {
        delegate?.moduleDidEndShow(self, tutorial: tutorial)
    }
    
    func containerDidShowTutorialStep(_ container: CTXTutorialContainerViewController,
                                      tutorial: CTXTutorial,
                                      with stepInfo: CTXTutorialStepPresentationInfo) {
        
        delegate?.moduleDidShowTutorialStep(self, tutorial: tutorial, with: stepInfo)
    }
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat? {
        return delegate?.cornerRadiusForModalViewSnapshot()
    }
    
    func tutorialOverlayColor() -> UIColor? {
        return delegate?.tutorialOverlayColor()
    }
    
    func container(_ container: CTXTutorialContainerViewController,
                   hintViewFor tutorial: CTXTutorial,
                   with currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType? {
    
        return delegate?.module(self, hintViewFor: tutorial, with: currentStepModel)
    }
}
