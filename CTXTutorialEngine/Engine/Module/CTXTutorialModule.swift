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
        router.rootViewController = view
        presenter.view = view
        presenter.router = router
        
        self.presenter = presenter
    }
    
    func presentTutorial(with stepModels: [CTXTutorialStepModel],
                         completion: @escaping () -> ()) {
        
        presenter?.presentTutorial(with: stepModels,
                                   completion: completion)
    }
}

extension CTXTutorialModule: CTXTutorialContainerDelegate {
    
    func containerDidEndShowTutorial(_ container: CTXTutorialContainerViewController) {
        delegate?.moduleDidEndShowTutorial(self)
    }
    
    func containerDidShowTutorialStep(_ container: CTXTutorialContainerViewController,
                                      with stepInfo: CTXTutorialStepPresentationInfo) {
        
        delegate?.moduleDidShowTutorialStep(self, with: stepInfo)
    }
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat? {
        return delegate?.cornerRadiusForModalViewSnapshot()
    }
    
    func preferredTutorialStatusBarStyle() -> UIStatusBarStyle? {
         return delegate?.preferredTutorialStatusBarStyle()
    }
    
    func tutorialOverlayColor() -> UIColor? {
        return delegate?.tutorialOverlayColor()
    }
    
    func container(_ container: CTXTutorialContainerViewController,
                   hintViewForTutorialWith currentStepModel: CTXTutorialStepModel,
                   previousStepHandler: VoidClosure?,
                   nextStepHandler: VoidClosure?,
                   closehandler: VoidClosure?) -> UIView? {
    
        return delegate?.module(self,
                                hintViewForTutorialWith: currentStepModel,
                                previousStepHandler: previousStepHandler,
                                nextStepHandler: nextStepHandler,
                                closehandler: closehandler)
    }
}
