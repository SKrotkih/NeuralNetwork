//
//  LearningViewModel.swift
//  CleverBoard
//

import UIKit
import RxSwift

class LearningViewModel {
  
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
    
    func learnNetwork(_ completed: @escaping () -> Void) {
        do {
            neuralNetwork.learn(input: try self.traningData.value(), target: self.traningResults) {
                self.isReady = true
                completed()
            }
        } catch  {
            fatal()
        }
    }
}

// MARK: - Provate methods

extension LearningViewModel {
    
    private func returnImageBlock(_ image: UIImage?) -> [Float] {
        guard let image = image, let mnistImage = self.imgProcessor.resize(image: image) else {
            return []
        }
        print(self.imgProcessor.imageBlock(image: mnistImage))
        return self.imgProcessor.imageBlock(image: mnistImage)
    }
}
