//
//  LearningViewModel.swift
//  CleverBoard
//

import UIKit

protocol ViewModeOutput: class {
    func willStartLearning()
    func didFinishLearning()
}

class LearningViewModel {
  
    weak var output: ViewModeOutput!
    
    required init(_ output: ViewModeOutput) {
        self.output = output
    }
    
    /// The Neural Network 🚀
    fileprivate lazy var neuralNetwork: NeuralNetwork = {
        return NeuralNetwork()
    }()
    
    fileprivate lazy var modelWorker: ModelWorker = {
        return ModelWorker()
    }()
    
    func learnNetwork(trainingImages: [[UIImage?]]) {
        var traningResults: [[Float]] = []
        var traningData: [[Float]] = []
        for index in 0..<Settings.outputSize {
            for dataIndex in 0..<trainingImages[index].count {
                if let image = trainingImages[index][dataIndex] {
                    let input: [Float] = modelWorker.returnImageBlock(image)
                    traningResults.append(Settings.traningResults[index])
                    traningData = traningData + [input]
                }
            }
        }
        output.willStartLearning()
        neuralNetwork.learn(input: traningData, target: traningResults) { [weak self] in
            self?.output.didFinishLearning()
        }
    }
}
