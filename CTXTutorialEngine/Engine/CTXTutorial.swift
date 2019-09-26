//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import Foundation

protocol CTXTutorialObserver: AnyObject {
    
    func tutorialWillShow(_ tutorial: CTXTutorial)
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

open class CTXTutorial: CTXTutorialProtocol {
    
    public let id: Int
    public var name: String?
    
    var delegate: CTXTutorialEngineDelegate?
    
    var observers = [CTXTutorialObserver]()
    
    private var chain = [CTXTutorialEvent]()
    private var poppedEventsChain = [CTXTutorialEvent]()
    
    init<M: Meta>(with config: CTXTutorialConfig<M>) {
        
        self.id = config.id
        self.name = config.name
        self.makeChain(from: config)
    }
}

extension CTXTutorial: CTXTutorialEventObserver {
    
    func push(_ event: CTXTutorialEvent) {
        
        if let currentEvent = self.chain.first {
            
            if let index = self.poppedEventsChain.firstIndex(where: {
                $0.compare(with: event) == .mutuallyExclusive}) {
                
                self.chain = self.poppedEventsChain.dropFirst(index) + self.chain
            }
            
            if currentEvent.compare(with: event) == .equal {
                
                self.poppedEventsChain.append(self.chain.removeFirst())
            }
            
            if self.chain.isEmpty {
                
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
        
        self.chain = config.eventConfigs.array.compactMap{ eventConfig -> CTXTutorialEvent? in
            
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
            
            for config in configuredEvent.stepConfigs {
                
                let viewsForModel = views.filter{ view in
                    
                    config.accessibilityIdentifiers.first(where: { view.accessibilityIdentifier == $0 }) != nil
                }
                
                let model = CTXTutorialStepModel(text: config.text, views: viewsForModel)
                
                models.append(model)
            }
            
            let module = CTXTutorialModule()
            
            self.delegate?.engineWillShow(tutorial: self)
            
            module.present(self, with: models, and: self.delegate)
            
            self.observers.forEach { $0.tutorialWillShow(self) }
        }
    }
}
