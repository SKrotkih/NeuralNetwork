//
//  LearningViewModel.swift
//  CleverBoard
//

import UIKit

protocol ViewModeOutput: class {
    func setupNextNumber(_ nextItemNumber: Int)
    func setupLeftNumbers(_ leftItemsCount: Int)
    func willStartLearning()
    func didFinishLearning()
}

class LearningViewModel {
  
    weak var output: ViewModeOutput!
    
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
        let leftItems = Settings.maxTrainingImages - traningData.count
        if leftItems == 0 {
            learnNetwork()
        } else {
            index = index == Settings.outputSize - 1 ? 0 : index + 1
            output.setupNextNumber(index)
            output.setupLeftNumbers(leftItems)
        }
    }
    
    private func learnNetwork() {
        output.willStartLearning()
        neuralNetwork.learn(input: traningData, target: traningResults) { [weak self] in
            self?.output.didFinishLearning()
        }
    }
}
