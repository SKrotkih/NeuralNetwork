//
//  LearningViewModel.swift
//  CleverBoard
//

import UIKit
import RxSwift

enum LearningState {
    case started
    case finished
    case cancelled
}

enum LearningErrors: Error {
    case dataAbsent
}

protocol TrainingImagesProviding: class {
    var trainingImages: [[UIImage]]? {get}
}

class LearningViewModel {
  
    deinit {
        Log()
    }
    
    var processState = PublishSubject<LearningState>()
    weak var trainingImagesProvider: TrainingImagesProviding!
    
    func cancelProcess() {
        neuralNetwork.cancelProcess()
    }
    
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
        processState.onNext(.started)
        neuralNetwork.learn(input: traningData, target: traningResults) { [weak self] state in
            if state == .finished {
                self?.processState.onNext(.finished)
            } else if state == .cancelled {
                self?.processState.onNext(.cancelled)
            }
        }
    }
}
