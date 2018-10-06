//
//  PredictingViewModel.swift
//  CleverBoard
//

import UIKit
import RxSwift

class PredictingViewModel {
    
    /// The Result Data labels for the output
    fileprivate var traningResults: [[Float]] = []
    
    var traningData = BehaviorSubject<[[Float]]>(value: [])
    
    // The Network is Ready to predict
    fileprivate var isReady: Bool = false
    
    /// The Neural Network 🚀
    fileprivate lazy var neuralNetwork: NeuralNetwork = {
        return NeuralNetwork()
    }()
    
    /// The Image Processor
    fileprivate lazy var imgProcessor: ImageProcessor = {
        let imgProcessor = ImageProcessor()
        return imgProcessor
    }()
    
    func addTraningImage(_ image: UIImage, index: Int) {
        self.traningResults.append(Settings.traningResults[index])
        let input: [Float] = self.returnImageBlock(image)
        do {
            try self.traningData.onNext(self.traningData.value() + [input])
        } catch  {
            fatal()
        }
    }
    
    func predict(image: UIImage?, completion: (PredictionResult) -> Void ) {
        guard let image = image else {
            completion(.noimage)
            return
        }
        guard self.isReady else {
            completion(.isnottrained)
            return
        }
        let input = self.returnImageBlock(image)
        self.neuralNetwork.predict(input: input, completion: completion)
    }
}

// MARK: - Provate methods

extension PredictingViewModel {
    
    private func returnImageBlock(_ image: UIImage?) -> [Float] {
        guard let image = image, let mnistImage = self.imgProcessor.resize(image: image) else {
            return []
        }
        print(self.imgProcessor.imageBlock(image: mnistImage))
        return self.imgProcessor.imageBlock(image: mnistImage)
    }
}
