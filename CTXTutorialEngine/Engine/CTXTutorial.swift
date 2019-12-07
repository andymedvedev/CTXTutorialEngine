//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public protocol CTXTutorialProtocol {
    var id: Int {get}
    var name: String? {get}
}

public class CTXTutorial: CTXTutorialProtocol {
    
    public let id: Int
    public var name: String?
    
    weak var delegate: CTXTutorialDelegate?
    
    
    private var eventsChain = [CTXTutorialEvent]()
    private var poppedEventsChain = [CTXTutorialEvent]()
    
    init<M: Meta>(with config: CTXTutorialConfig<M>) {
        
        self.id = config.id
        self.name = config.name
        self.makeChain(from: config)
    }
    
    init(id: Int, name: String? = nil, eventsChain: [CTXTutorialEvent]) {
        
        self.id = id
        self.name = name
        self.eventsChain = eventsChain
    }
}

extension CTXTutorial: CTXTutorialEventObserver {
    
    func push(_ event: CTXTutorialEvent) {
        
        if let currentEvent = self.eventsChain.first {
            
            if let index = self.poppedEventsChain.firstIndex(where: {
                $0.compare(with: event) == .mutuallyExclusive}) {
                
                self.eventsChain = self.poppedEventsChain.dropFirst(index) + self.eventsChain
            }
            
            if currentEvent.compare(with: event) == .equal {
                
                self.poppedEventsChain.append(self.eventsChain.removeFirst())
            }
            
            if self.eventsChain.isEmpty {
                
                self.show(with: event)
            }
        }
    }
}

private extension CTXTutorial {
    
    func makeChain<M: Meta>(from config: CTXTutorialConfig<M>) {
        
        guard let eventTypes = CTXTutorialEngine.shared.eventTypes else { return }
        
        self.eventsChain = config.eventConfigs.array.compactMap{ eventConfig -> CTXTutorialEvent? in
            
            //TODO: remove this guard somehow
            guard let eventConfig = eventConfig as? CTXTutorialEventConfig else {
                fatalError("CTXTutorialEngine: one of user defined event config classes not conform to \"CTXTutorialEventConfig\"")
            }
            
            for eventType in eventTypes {

                if let event = eventType.init(with: eventConfig) {
                    return event
                } else if let event = CTXTutorialViewsShownEvent(with: eventConfig) {
                    return event
                }
            }

            return nil
        }
    }
    
    func show(with lastPushedEvent: CTXTutorialEvent) {
        
        if let configuredEvent = self.poppedEventsChain.last as? CTXTutorialViewsShownEvent,
            let event = lastPushedEvent as? CTXTutorialViewsShownEvent {
            
            let views = event.views
            var models = [CTXTutorialStepModel]()
            
            for stepConfig in configuredEvent.stepConfigs {
                
                let viewsForModel = views.filter{ view in
                    
                    stepConfig.accessibilityIdentifier == view.accessibilityIdentifier
                }
                
                let model = CTXTutorialStepModel(text: stepConfig.text, views: viewsForModel)
                
                models.append(model)
            }
            
            let module = CTXTutorialModule()
            
            self.delegate?.tutorialWillShow(self)
                        
            module.present(self, with: models) { [weak self] in
                if let self = self {
                    self.delegate?.tutorialDidEndShow(self)
                }
            }
        }
    }
}

extension CTXTutorial: CTXTutorialModuleDelegate {
    
    func moduleDidEndShow(_ module: CTXTutorialModule, tutorial: CTXTutorial) {
        delegate?.tutorialDidEndShow(self)
    }
    
    func moduleDidShowTutorialStep(_ module: CTXTutorialModule,
                                   tutorial: CTXTutorial,
                                   with stepInfo: CTXTutorialStepPresentationInfo) {
        delegate?.tutorialDidShowTutorialStep(self, with: stepInfo)
    }
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat? {
        return delegate?.cornerRadiusForModalViewSnapshot()
    }
    
    func tutorialOverlayColor() -> UIColor? {
        return delegate?.tutorialOverlayColor()
    }
    
    func module(_ module: CTXTutorialModule,
                hintViewFor tutorial: CTXTutorial,
                with currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType? {
        return delegate?.tutorialHintView(self, with: currentStepModel)
    }
}
