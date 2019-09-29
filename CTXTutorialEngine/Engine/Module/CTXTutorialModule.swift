//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

struct CTXTutorialModule {
    
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
                 and delegate: CTXTutorialEngineDelegate?,
                 completion: @escaping () -> ()) {
        
        self.presenter?.present(tutorial,
                                with: stepModels,
                                and: delegate,
                                completion: completion)
    }
}
