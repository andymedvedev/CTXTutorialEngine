//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit

public typealias VoidClosure = () -> Void

public final class CTXTutorialEngine {

    public static let shared = CTXTutorialEngine()
    
    public let appearance = CTXTutorialAppearance()
    public var useDefaultHintView = true
    public var isHaveShownTutorials: Bool {
        return !shownTutorialsIds.isEmpty
    }
    
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
    private let availabilityChecker = CTXTutorialViewAvailabilityChecker()
    private var weakViewControllers = [CTXTutorialWeakViewController]()
    private var tutorials = [CTXTutorial]()
    private var currentTutorial: CTXTutorial?
    private var pollingTimer: Timer?
    private var stoppedByUser = false
    private let defaultsKey = "CTXTutorialEngineTutorialsShownStatus"
    private var shownTutorialsIds: [CTXTutorialID] {
        get {
            return (UserDefaults.standard.array(forKey: defaultsKey) as? [CTXTutorialID]) ?? []
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: defaultsKey)
        }
    }
    
    private init() {}
    
    public func addTutorials(from configName: String = "CTXTutorialConfig",
                             completion: (CTXTutorialAdditionError?) -> ()) {
        addTutorialsWithMeta(from: configName,
                             with: [CTXTutorialViewsShownEvent.self],
                             eventConfigMetaType: CTXTutorialEventConfigMetaType.self,
                             completion: completion)
    }
    
    public func addTutorialsWithMeta<M: Meta>(from configName: String = "CTXTutorialConfig",
                                              with eventTypes: [CTXTutorialEvent.Type],
                                              eventConfigMetaType: M.Type,
                                              completion: (CTXTutorialAdditionError?) -> ()) where M.Element == CTXTutorialEventConfig {
        
        self.eventTypes = eventTypes
        
        let tutorialConfigs = try! CTXTutorialConfigLoader().loadConfigs(from: configName,
                                                                         eventConfigMetaType: eventConfigMetaType)
        
        tutorialConfigs.forEach { tutorialConfig in
            
            if tutorials.first(where: {$0.id == tutorialConfig.id}) != nil {
                
                completion(CTXTutorialAdditionError(id: tutorialConfig.id, name: tutorialConfig.name))
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
            
            completion(CTXTutorialAdditionError(id: tutorial.id, name: tutorial.name))
        }
        
        tutorial.delegate = self
        
        bus.add(tutorial)
        tutorials.append(tutorial)
        
        completion(nil)
    }
    
    public func closeCurrentTutorial() {
        currentTutorial?.close()
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
                                                   availabilityChecker: availabilityChecker)
        
        weakViewControllers.append(weakVC)
    }
    
    public func push(_ event: CTXTutorialEvent) {
        bus.push(event)
    }
    
    public func unobserve(_ viewController: UIViewController) {
        
        weakViewControllers.removeAll(where: { $0.viewController === viewController })
    }
    
    public func resetShownTutorials() {
        shownTutorialsIds = []
    }
}

private extension CTXTutorialEngine {
    
    func pollingFunction(_ timer: Timer) {
        guard timer.isValid else { return }
        
        weakViewControllers.forEach { weakVC in
            
            guard let vc = weakVC.viewController else { return }
            
            if vc.view.window != nil
                && vc.presentedViewController == nil
                && availabilityChecker.isAvailable(vc.view, inSafeArea: false) {//vc currently on screen and visible
                
                let availableViewsDict = weakVC.availableAccessibilityViewsDict
                var viewsToProcess = [UIView]()
                
                if let delegate = delegate {
                    viewsToProcess = delegate.selectedViewsToProcess(in: availableViewsDict)
                } else {
                    availableViewsDict.forEach { (_, viewsArr) in
                        viewsToProcess.append(viewsArr[0][0])
                    }
                }
                
                guard !viewsToProcess.isEmpty else {
                    return
                }
                    
                bus.push(CTXTutorialViewsShownEvent(with: viewsToProcess))
            }
        }
    }
    
    func setTutorial(with id: CTXTutorialID, isShown: Bool) {
        if !shownTutorialsIds.contains(id) {
            shownTutorialsIds.append(id)
        }
    }
}

extension CTXTutorialEngine: CTXTutorialDelegate {
    
    func tutorialShouldProcessEvents(_ tutorial: CTXTutorial) -> Bool {
        return !shownTutorialsIds.contains(tutorial.id)
    }
    
    func tutorialWillShow(_ tutorial: CTXTutorial) {
        currentTutorial = tutorial
        delegate?.engineWillShow(self, tutorial: tutorial)
        
        //prevent handling incoming events by stopping polling
        if !stoppedByUser {
            stop()
            stoppedByUser = false
        }
    }
    
    func tutorialDidEndShow(_ tutorial: CTXTutorial) {
        delegate?.engineDidEndShow(self, tutorial: tutorial)
        setTutorial(with: tutorial.id, isShown: true)
        
        tutorials.removeAll(where: { $0 === tutorial })
        bus.remove(tutorial)
        
        if tutorials.isEmpty {
            stop()
            stoppedByUser = false
        } else if !stoppedByUser {
            start()
        }
    }
    
    func tutorialWillShowTutorialStep(_ tutorial: CTXTutorial,
                                      with stepInfo: CTXTutorialStepPresentationInfo) {
        delegate?.engineWillShowTutorialStep(self, tutorial: tutorial, with: stepInfo)
    }
    
    func tutorialDidShowTutorialStep(_ tutorial: CTXTutorial,
                                     with stepInfo: CTXTutorialStepPresentationInfo) {
        delegate?.engineDidShowTutorialStep(self, tutorial: tutorial, with: stepInfo)
    }
    
    func tutorialHintView(_ tutorial: CTXTutorial,
                          with currentStepModel: CTXTutorialStepModel,
                          isHavePreviousStep: Bool,
                          isHaveNextStep: Bool) -> CTXTutorialHintView? {
        return delegate?.engine(self,
                                hintViewFor: tutorial,
                                with: currentStepModel,
                                isHavePreviousStep: isHavePreviousStep,
                                isHaveNextStep: isHaveNextStep)
    }
}
