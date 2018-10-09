//
//  LearningViewModel.swift
//  CleverBoard
//

import UIKit
import RxSwift

enum LearningState {
    case start
    case finish
}

class LearningViewModel {
  
    var processState = PublishSubject<LearningState>()
    weak var learningToolBar: LearningToolBar!
    
    /// The Neural Network 🚀
    fileprivate lazy var neuralNetwork: NeuralNetwork = {
        return NeuralNetwork()
    }()
    
    fileprivate lazy var modelWorker: ModelWorker = {
        return ModelWorker()
    }()
    
    func learnNetwork() {
        let trainingImages = self.learningToolBar.images
        guard trainingImages.count == Settings.outputSize else {
            return
        }
        var traningResults: [[Float]] = []
        var traningData: [[Float]] = []
        for index in 0..<Settings.outputSize {
            for dataIndex in 0..<trainingImages[index].count {
                let image = trainingImages[index][dataIndex]
                let input: [Float] = modelWorker.returnImageBlock(image)
                traningResults.append(Settings.traningResults[index])
                traningData = traningData + [input]
            }
        }
        processState.onNext(.start)
        neuralNetwork.learn(input: traningData, target: traningResults) { [weak self] in
            self?.processState.onNext(.finish)
        }
    }
}
