//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

final class CTXTutorialPresenterImpl: CTXTutorialPresenter {
    
    var router: CTXTutorialRouter?
    var view: CTXTutorialView?
    var completion: (() -> ())?
    
    func present(_ tutorial: CTXTutorial,
                 with models: [CTXTutorialStepModel],
                 completion: @escaping () -> ()) {
        
        CTXTutorialEventBus.shared.isLocked = true
        
        self.completion = completion
        self.view?.show(tutorial,
                        with: models)
    }
    
    func onTutorialPrepared(startHandler: @escaping () -> (),
                            cleaningBlock: @escaping () -> ()) {
        
        self.router?.showTutorial(startHandler: startHandler,
                                  hideCompletion: {
            cleaningBlock()
            self.completion?()
        })
    }
    
    func onHideTutorial() {
        
        self.router?.hideTutorial()
        
        CTXTutorialEventBus.shared.isLocked = false
    }
}
