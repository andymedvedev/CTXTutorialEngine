//
//  Copyright © 2019 Andrey Medvedev. All rights reserved.
//

import UIKit



public final class CTXTutorialEngine {
    
    public static let shared = CTXTutorialEngine()
    
    public weak var delegate: CTXTutorialEngineDelegate? {
        didSet {
            self.tutorials.forEach { $0.delegate = self.delegate }
        }
    }
    
    public var pollingInterval: TimeInterval = 1 {
        didSet {
            if (self.pollingTimer?.isValid ?? false) {
                self.start()
            }
        }
    }
    
    public var provideSortedViewsSlices = true {
        didSet {
            self.weakViewControllers.forEach {
                $0.provideSortedViewsSlices = self.provideSortedViewsSlices
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
    
    private init() {}
    
    public func setup<M: Meta>(with configName: String? = nil,
                      eventTypes: [CTXTutorialEvent.Type],
                      eventConfigMetaType: M.Type) where M.Element == CTXTutorialEventConfig {
        
        self.eventTypes = eventTypes
        
        let tutorialConfigs = try! CTXTutorialConfigLoader().loadConfigs(eventConfigMetaType: eventConfigMetaType)
        
        self.tutorials = tutorialConfigs.map { tutorialConfig in
            
            let tutorial = CTXTutorial(with: tutorialConfig)
            
            tutorial.add(self)
            self.bus.add(tutorial)
            
            return tutorial
        }
    }
    
    public func add(_ tutorial: CTXTutorial) {
        
        tutorial.add(self)
        
        self.bus.add(tutorial)
        self.tutorials.append(tutorial)
    }
    
    public func start() {
        
        self.pollingTimer?.invalidate()
        self.pollingTimer = Timer.scheduledTimer(withTimeInterval: self.pollingInterval,
                                                 repeats: true,
                                                 block: self.pollingFunction(_:))
    }
    
    public func stop() {
        
        self.pollingTimer?.invalidate()
        self.pollingTimer = nil
    }
    
    public func observe(_ viewController: UIViewController,
                        contentType: CTXTutorialViewControllerContentType) {
        
        self.weakViewControllers.removeAll(where: { $0.viewController == nil })
        
        let weakVC = CTXTutorialWeakViewController(with: viewController,
                                                   contentType: contentType,
                                                   visibilityChecker: self.visibilityChecker)
        
        self.weakViewControllers.append(weakVC)
    }
    
    public func unobserve(_ viewController: UIViewController) {
        
        self.weakViewControllers.removeAll(where: { $0.viewController === viewController })
    }
}

private extension CTXTutorialEngine {
    
    func pollingFunction(_ timer: Timer) {
        
        guard timer.isValid else { return }
        
        self.weakViewControllers.forEach { weakVC in
            
            guard let vc = weakVC.viewController else { return }
            
            if vc.view.window != nil &&
                vc.presentedViewController == nil &&
                self.visibilityChecker.isVisible(vc.view, inSafeArea: false) {//vc currently on screen and visible
                
                let visibleViewsDict = weakVC.visibleAccessibilityViewsDict
                var viewsToProcess = [UIView]()
                
                if let delegate = self.delegate {
                    
                    viewsToProcess = delegate.selectedViewsToProcess(in: visibleViewsDict)
                } else {
                    
                    visibleViewsDict.forEach { (_, viewsArr) in
                        viewsToProcess.append(viewsArr[0][0])
                    }
                }
                    
                self.bus.push(CTXTutorialViewsShownEvent(with: viewsToProcess))
            }
        }
    }
}

extension CTXTutorialEngine: CTXTutorialObserver {
    
    func tutorialWillShow(_ tutorial: CTXTutorial) {
        
        self.tutorials.removeAll(where: { $0 === tutorial })
        self.bus.remove(tutorial)
        
        if self.tutorials.isEmpty {
            self.stop()
        }
    }
}
