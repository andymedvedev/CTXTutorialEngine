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


open class CTXTutorial {
    
    public let id: Int
    public var name: String?
    
    var delegate: CTXTutorialEngineDelegate?
    
    var observers = [CTXTutorialObserver]()
    
    private var chain = [CTXTutorialEvent]()
    private var poppedEventsChain = [CTXTutorialEvent]()
    
    init(with itemConfig: CTXTutorialItemConfig) {
        
        self.id = itemConfig.id
        self.name = itemConfig.name
        self.makeChain(from: itemConfig)
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
    
    func makeChain(from config: CTXTutorialItemConfig) {
        
        self.chain = config.events.compactMap{ event -> CTXTutorialEvent? in
            
            if let basicEvent = event.basicEvent,
                
                let eventClass = CTXTutorialEngine.shared.eventClass {
                return eventClass.self.init(rawValue: basicEvent)
            } else if let stepEvent = event.stepsEvent {
                
                return CTXTutorialViewsShownEvent(with: stepEvent.steps)
            }
            
            return nil
        }
    }
    
    func show(with lastEvent: CTXTutorialEvent) {
        
        if let event = self.poppedEventsChain.last as? CTXTutorialViewsShownEvent {
            
            let views = event.views
            var models = [CTXTutorialStepModel]()
            
            for config in event.configs {
                
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
