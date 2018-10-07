//
//  NeuralNetwork.swift
//  CleverBoard
//

import Foundation

public class NeuralNetwork {
    
    private var layers: [Layer] = []
    
    public init() {
        configureLayers()
    }
    
    /// Learn Neural Network
    func learn(input: [[Float]], target: [[Float]], completed: @escaping () -> Void) {
        guard input.count == target.count else {
            fatal()
        }
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
            completed()
        }
    }
    
    /// Predict value according of the input value
    func predict(input: [Float], completion: (PredictionResult) -> Void ) {
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
    
    private func configureLayers() {
        // Input -> Hidden layer
        let ihLayer = Layer(inputSize: Settings.inputSize, outputSize: Settings.hiddenSize)
        // Hidden -> Output layer
        let hoLayer = Layer(inputSize: Settings.hiddenSize, outputSize: Settings.outputSize)
        layers.append(ihLayer)
        layers.append(hoLayer)
    }
    
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

