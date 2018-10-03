//
//  Settings.swift
//  NeuralNetwork
//

import Foundation

public struct Settings {
    
    private var settings: NSDictionary?
    
    lazy var learningRate: Float = {
        return settings?.object(forKey: "learningRate") as? Float ?? 0.3
    }()
    
    lazy var momentum: Float = {
        return settings?.object(forKey: "momentum") as? Float ?? 0.6
    }()

    lazy var iterations: Int = {
        return settings?.object(forKey: "iterations") as? Int ?? 70000
    }()

    lazy var inputMinValue: Float = {
        return settings?.object(forKey: "inputMinValue") as? Float ?? -2.0
    }()

    lazy var inputMaxValue: Float = {
        return settings?.object(forKey: "inputMaxValue") as? Float ?? 2.0
    }()
    
    mutating func configure() {
        if let path = Bundle.main.path(forResource: "settings", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) {
            self.settings = dict
        }
    }
}
