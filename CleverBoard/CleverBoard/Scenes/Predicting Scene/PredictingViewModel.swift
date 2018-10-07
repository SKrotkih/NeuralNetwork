//
//  PredictingViewModel.swift
//  CleverBoard
//

import UIKit

enum PredictionResult {
    case noimage
    case isnottrained
    case wrong
    case success(Int)
}

class PredictingViewModel {
    
    /// The Neural Network 🚀
    fileprivate lazy var neuralNetwork: NeuralNetwork = {
        return NeuralNetwork()
    }()

    fileprivate lazy var modelWorker: ModelWorker = {
        return ModelWorker()
    }()
    
    func predict(image: UIImage?, completion: (PredictionResult) -> Void ) {
        guard let image = image else {
            completion(.noimage)
            return
        }
        // TODO: Need to load neural network
        
//        guard self.isReady else {
//            completion(.isnottrained)
//            return
//        }
        let input = modelWorker.returnImageBlock(image)
        self.neuralNetwork.predict(input: input, completion: completion)
    }
}
