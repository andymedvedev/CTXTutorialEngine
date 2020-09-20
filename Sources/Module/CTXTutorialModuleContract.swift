//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

protocol CTXTutorialView: AnyObject {
    
    var delegate: CTXTutorialContainerDelegate? { get set }
    
    func show(with stepModels: [CTXTutorialStepModel])
}


protocol CTXTutorialPresenter: AnyObject {
    
    func presentTutorial(with stepModels: [CTXTutorialStepModel],
                         completion: @escaping () -> ())
    
    func onTutorialPrepared(startHandler: @escaping () -> (),
                            cleaningBlock: @escaping () -> ())
    func onHideTutorial()
}


protocol CTXTutorialRouter {
    
    func showTutorial(startHandler: @escaping () -> (),
                      hideCompletion: @escaping () -> Void)
    func hideTutorial()
}
