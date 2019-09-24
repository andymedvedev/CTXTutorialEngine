//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

final class CTXTutorialPresenterImpl: CTXTutorialPresenter {
    
    var router: CTXTutorialRouter?
    var view: CTXTutorialView?
    
    func present(_ tutorial: CTXTutorial,
                 with models: [CTXTutorialStepModel],
                 and delegate: CTXTutorialEngineDelegate?) {
        
        CTXTutorialEventBus.shared.isLocked = true
        
        self.view?.show(tutorial,
                        with: models,
                        and: delegate)
    }
    
    func onTutorialPrepared(startHandler: @escaping () -> (),
                            cleaningCallback: @escaping () -> ()) {
        
        self.router?.showTutorial(startHandler: startHandler,
                                  hideCompletion: cleaningCallback)
    }
    
    func onHideTutorial() {
        
        self.router?.hideTutorial()
        
        CTXTutorialEventBus.shared.isLocked = false
    }
}
