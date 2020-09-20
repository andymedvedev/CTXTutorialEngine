//
//  CTXLayerManager.swift
//  CTXTutorialEngine
//
//  Created by Andrey Medvedev on 15.09.2020.
//

import UIKit

final class CTXTutorialViewManager {
    
    private let view: UIView
    private var layersSpeeds = [Float]()
    
    init(for view: UIView) {
        self.view = view
    }
    
    func pause() {
        CALayer.pauseAll(on: view.layer, layerSpeeds: &layersSpeeds)
    }
    
    func resume() {
        CALayer.resumeAll(on: view.layer, layerSpeeds: &layersSpeeds)
    }
}

extension CALayer {
    
    static func pauseAll(on layer: CALayer, layerSpeeds: inout [Float]) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        
        layerSpeeds.append(layer.speed)
        layer.speed = .zero
        layer.timeOffset = pausedTime
        
        layer.sublayers?.forEach { CALayer.pauseAll(on: $0, layerSpeeds: &layerSpeeds) }
    }
    
    static func resumeAll(on layer: CALayer, layerSpeeds: inout [Float]) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        
        layer.speed = layerSpeeds.removeFirst()
        layer.timeOffset = .zero
        layer.beginTime = .zero
        
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        
        layer.beginTime = timeSincePause
        
        layer.sublayers?.forEach { CALayer.resumeAll(on: $0, layerSpeeds: &layerSpeeds) }
    }
}
