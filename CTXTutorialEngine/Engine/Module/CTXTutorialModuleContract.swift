//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

protocol CTXTutorialView: AnyObject {
    
    func show(_ tutorial: CTXTutorial,
              with stepModels: [CTXTutorialStepModel],
              and delegate: CTXTutorialEngineDelegate?)
}


protocol CTXTutorialPresenter: AnyObject {
    
    func present(_ tutorial: CTXTutorial,
                 with stepModels: [CTXTutorialStepModel],
                 and delegate: CTXTutorialEngineDelegate?,
                 completion: @escaping () -> ())
    
    func onTutorialPrepared(startHandler: @escaping () -> (),
                            cleaningCallback: @escaping () -> ())
    func onHideTutorial()
}


protocol CTXTutorialRouter {
    
    func showTutorial(startHandler: @escaping () -> (),
                      hideCompletion: @escaping () -> Void)
    func hideTutorial()
}
