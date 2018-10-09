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

enum LearningErrors: Error {
    case dataAbsent
}

protocol TrainingImagesProviding: class {
    var trainingImages: [[UIImage]]? {get}
}

class LearningViewModel {
  
    var processState = PublishSubject<LearningState>()
    weak var trainingImagesProvider: TrainingImagesProviding!
    
    /// The Neural Network 🚀
    fileprivate lazy var neuralNetwork: NeuralNetwork = {
        return NeuralNetwork()
    }()
    
    fileprivate lazy var modelWorker: ModelWorker = {
        return ModelWorker()
    }()
    
    func learnNetwork() throws {
        guard let trainingImages = self.trainingImagesProvider.trainingImages, trainingImages.count == Settings.outputSize else {
            throw LearningErrors.dataAbsent
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
