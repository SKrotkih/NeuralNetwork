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
    weak var learningToolBar: LearningToolBar!
    
    required init(_ output: ViewModeOutput) {
        self.output = output
    }
    
    /// The Result Data labels for the output
    fileprivate var traningResults: [[Float]] = []
    fileprivate var traningData: [[Float]] = []

    private var index: Int = 0
    
    /// The Neural Network 🚀
    fileprivate lazy var neuralNetwork: NeuralNetwork = {
        return NeuralNetwork()
    }()
    
    fileprivate lazy var modelWorker: ModelWorker = {
        return ModelWorker()
    }()
    
    func addTraningImage(_ image: UIImage) {
        traningResults.append(Settings.traningResults[index])
        let input: [Float] = modelWorker.returnImageBlock(image)
        traningData = traningData + [input]
    }
    
    func learnNetwork(trainingImages: [[UIImage?]]) {
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
