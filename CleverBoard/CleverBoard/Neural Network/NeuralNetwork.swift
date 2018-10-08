//
//  NeuralNetwork.swift
//  CleverBoard
//

import Foundation

public class NeuralNetwork {
    
    private var storage = Storage()
    
    private lazy var layers: [Layer] = {
        return storage.layers
    }()
    
    func clean() {
        storage.clean()
    }
    
    /// Learn Neural Network
    func learn(input: [[Float]], target: [[Float]], completed: @escaping () -> Void) {
        guard input.count == target.count else {
            fatal()
        }
        // TODO: Need to continue learning
        clean()
        DispatchQueue.global(qos: DispatchQoS.userInteractive.qosClass).async {
            for iterations in 0..<Settings.iterations {
                for i in 0..<input.count {
                    self.train(input: input[i], target: target[i])
                }
                input.forEach({ inputItem in
                    let _ = self.run(input: inputItem)
                })
                print("Iterations: \(iterations)")
            }
            self.storage.save(self.layers)
            completed()
        }
    }
    
    /// Predict value according of the input value
    func predict(input: [Float], completion: (PredictionResult) -> Void ) {
        guard storage.exist else {
            completion(.isnottrained)
            return
        }
        let prediction = self.run(input: input).filter {
            $0 >= Settings.predictionThreshold
        }
        guard prediction.count > 0 else {
            completion(.wrong)
            return
        }
        self.run(input: input).enumerated().forEach { index, element in
            if element >= Settings.predictionThreshold {
                completion(.success(index))
            }
        }
    }
}

// MARK: - Calculate Network. Private methods

extension NeuralNetwork {
    
    private func train(input: [Float], target: [Float]) {
        let calculatedOutput = run(input: input)
        var error = zip(target, calculatedOutput).map { $0 - $1 }
        for i in (0...layers.count - 1).reversed() {
            error = layers[i].train(error: error)
        }
    }
    
    private func run(input: [Float]) -> [Float] {
        var activations = input
        layers.forEach { layer in
            activations = layer.run(input: activations)
        }
        return activations
    }
}

