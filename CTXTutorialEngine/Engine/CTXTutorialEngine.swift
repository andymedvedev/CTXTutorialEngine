//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit



public final class CTXTutorialEngine {
    
    public static let shared = CTXTutorialEngine()
    
    public weak var delegate: CTXTutorialEngineDelegate?
    
    public var pollingInterval: TimeInterval = 0.1 {
        didSet {
            if (self.pollingTimer?.isValid ?? false) {
                self.start()
            }
        }
    }
    
    public var provideSortedViewsSlices = true {
        didSet {
            self.weakViewControllers.forEach {
                $0.provideSortedViewsSlices = provideSortedViewsSlices
            }
        }
    }
    
    var eventTypes: [CTXTutorialEvent.Type]?
    var eventConfigTypes: [CTXTutorialEventConfig.Type]?
    
    private let bus = CTXTutorialEventBus.shared
    private let visibilityChecker = CTXTutorialViewVisibilityChecker()
    private var weakViewControllers = [CTXTutorialWeakViewController]()
    private var tutorials = [CTXTutorial]()
    private var pollingTimer: Timer?
    private var stoppedByUser = false
    
    private init() {}
    
    public func addTutorials<M: Meta>(from configName: String = "CTXTutorialConfig",
                                      with eventTypes: [CTXTutorialEvent.Type],
                                      eventConfigMetaType: M.Type,
                                      completion: (CTXTutorialAdditionError?) -> ()) where M.Element == CTXTutorialEventConfig {
        
        self.eventTypes = eventTypes
        
        let tutorialConfigs = try! CTXTutorialConfigLoader().loadConfigs(from: configName,
                                                                         eventConfigMetaType: eventConfigMetaType)
        
        tutorialConfigs.forEach { tutorialConfig in
            
            if tutorials.first(where: {$0.id == tutorialConfig.id}) != nil {
                
                completion(CTXTutorialAdditionError())
            }
        }
        
        self.tutorials = tutorialConfigs.map { tutorialConfig in
            
            let tutorial = CTXTutorial(with: tutorialConfig)
            
            tutorial.delegate = self
            bus.add(tutorial)
            
            return tutorial
        }
        
        completion(nil)
    }
    
    public func add(_ tutorial: CTXTutorial, completion: (CTXTutorialAdditionError?) -> ()) {
        
        if tutorials.first(where: {$0.id == tutorial.id}) != nil {
            
            completion(CTXTutorialAdditionError())
        }
        
        tutorial.delegate = self
        
        bus.add(tutorial)
        tutorials.append(tutorial)
        
        completion(nil)
    }
    
    public func start() {
        
        pollingTimer?.invalidate()
        pollingTimer = Timer.scheduledTimer(withTimeInterval: pollingInterval,
                                            repeats: true,
                                            block: pollingFunction(_:))
    }
    
    public func stop() {
        
        stoppedByUser = true
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    
    public func observe(_ viewController: UIViewController,
                        contentType: CTXTutorialViewControllerContentType) {
        
        weakViewControllers.removeAll(where: { $0.viewController == nil })
        
        let weakVC = CTXTutorialWeakViewController(with: viewController,
                                                   contentType: contentType,
                                                   visibilityChecker: visibilityChecker)
        
        weakViewControllers.append(weakVC)
    }
    
    public func unobserve(_ viewController: UIViewController) {
        
        weakViewControllers.removeAll(where: { $0.viewController === viewController })
    }
}

private extension CTXTutorialEngine {
    
    func pollingFunction(_ timer: Timer) {
        
        guard timer.isValid else { return }
        
        weakViewControllers.forEach { weakVC in
            
            guard let vc = weakVC.viewController else { return }
            
            if vc.view.window != nil
                && vc.presentedViewController == nil
                && visibilityChecker.isVisible(vc.view, inSafeArea: false) {//vc currently on screen and visible
                
                let visibleViewsDict = weakVC.visibleAccessibilityViewsDict
                var viewsToProcess = [UIView]()
                
                if let delegate = delegate {
                    
                    viewsToProcess = delegate.selectedViewsToProcess(in: visibleViewsDict)
                } else {
                    
                    visibleViewsDict.forEach { (_, viewsArr) in
                        viewsToProcess.append(viewsArr[0][0])
                    }
                }
                    
                bus.push(CTXTutorialViewsShownEvent(with: viewsToProcess))
            }
        }
    }
}

extension CTXTutorialEngine: CTXTutorialDelegate {
    func tutorialWillShow(_ tutorial: CTXTutorial) {
        delegate?.engineWillShow(self, tutorial: tutorial)
        
        //prevent handling incoming events by stopping polling
        if !stoppedByUser {
            stop()
            stoppedByUser = false
        }
    }
    
    func tutorialDidEndShow(_ tutorial: CTXTutorial) {
        delegate?.engineDidEndShow(self, tutorial: tutorial)
        
        tutorials.removeAll(where: { $0 === tutorial })
        bus.remove(tutorial)
        
        if tutorials.isEmpty {
            stop()
            stoppedByUser = false
        } else if !stoppedByUser {
            start()
        }
    }
    
    func tutorialDidShowTutorialStep(_ tutorial: CTXTutorial,
                                     with stepInfo: CTXTutorialStepPresentationInfo) {
        
        delegate?.engineDidShowTutorialStep(self, tutorial: tutorial, with: stepInfo)
    }
    
    func cornerRadiusForModalViewSnapshot() -> CGFloat? {
        return delegate?.cornerRadiusForModalViewSnapshot()
    }
    
    func tutorialOverlayColor() -> UIColor? {
        return delegate?.tutorialOverlayColor()
    }
    
    func tutorialHintView(_ tutorial: CTXTutorial,
                          with currentStepModel: CTXTutorialStepModel) -> CTXTutorialHintViewType? {
        
        return delegate?.engine(self, hintViewFor: tutorial, with: currentStepModel)
    }
}
