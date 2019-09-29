//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

protocol CTXTutorialObserver: AnyObject {
    
    func tutorialWillShow(_ tutorial: CTXTutorial)
    func tutorialDidFinish(_ tutorial: CTXTutorial)
}


protocol CTXTutorialSubject {
    
    func add(_ observer: CTXTutorialObserver)
    func remove(_ observer: CTXTutorialObserver)
}


public protocol CTXTutorialProtocol {
    var id: Int {get}
    var name: String? {get}
}

class sss: CTXTutorial {
    
}

public class CTXTutorial: CTXTutorialProtocol {
    
    public let id: Int
    public var name: String?
    
    var delegate: CTXTutorialEngineDelegate?
    
    var observers = [CTXTutorialObserver]()
    
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

extension CTXTutorial: CTXTutorialSubject {
    
    func add(_ observer: CTXTutorialObserver) {
        
        self.observers.append(observer)
    }
    
    func remove(_ observer: CTXTutorialObserver) {
        
        if let index = self.observers.firstIndex(where: { $0 === observer}) {
            self.observers.remove(at: index)
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
            
            self.delegate?.engineWillShow(tutorial: self)
            
            self.observers.forEach{ $0.tutorialWillShow(self) }
            
            module.present(self, with: models, and: self.delegate) { [weak self] in
                guard let self = self else {return}
                self.observers.forEach { $0.tutorialDidFinish(self) }
            }
        }
    }
}
