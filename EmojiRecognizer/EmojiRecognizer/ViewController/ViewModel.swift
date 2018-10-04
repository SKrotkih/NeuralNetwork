import UIKit
import RxSwift

enum PredictionResult {
    case noimage
    case isnottrained
    case wrong
    case success
}

class ViewModel {
    
    /// The Result Data labels for the output
    fileprivate var traningResults: [[Float]] = []

    var traningData = BehaviorSubject<[[Float]]>(value: [])
    
    // The Network is Ready to predict
    fileprivate var isReady: Bool = false

    /// The Neural Network 🚀
    fileprivate lazy var neuralNetwork: NeuralNetwork = {
        let neuralNetWork = NeuralNetwork(inputSize: Settings.inputSize, hiddenSize: Settings.hiddenSize, outputSize: Settings.outputSize)
        return neuralNetWork
    }()
    
    /// The Image Processor
    fileprivate lazy var imgProcessor: ImageProcessor = {
        let imgProcessor = ImageProcessor()
        return imgProcessor
    }()
    
    func addTraningImage(_ image: UIImage, index: Int) {
        var traningResults: [[Float]] = Settings.traningResults
        self.traningResults.append(traningResults[index])
        let input: [Float] = self.returnImageBlock(image)
        do {
            try self.traningData.onNext(self.traningData.value() + [input])
        } catch  {
            fatal()
        }
    }
    
    func learnNetwork(_ completed: @escaping () -> Void) {
        DispatchQueue.global(qos: DispatchQoS.userInteractive.qosClass).async {
            for iterations in 0..<Settings.iterations {
                for i in 0..<self.traningResults.count {
                    do {
                        self.neuralNetwork.train(input: try self.traningData.value()[i], targetOutput: self.traningResults[i], learningRate: Settings.learningRate, momentum: Settings.momentum)
                    } catch  {
                        fatal()
                    }
                }
                
                for i in 0..<self.traningResults.count {
                    do {
                        let data = try self.traningData.value()[i]
                        let _ = self.neuralNetwork.run(input: data)
                    } catch  {
                        fatal()
                    }
                }
                print("Iterations: \(iterations)")
            }
            
            self.isReady = true
            completed()
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
        
        let inputData: [Float] = self.returnImageBlock(image)
        let prediction = self.neuralNetwork.run(input: inputData).filter { $0 >= Settings.predictionThreshold }
        if prediction.count == 0 {
           completion(.wrong)
        } else {
            self.neuralNetwork.run(input: inputData).enumerated().forEach { index, element in
                if element >= Settings.predictionThreshold {
                    completion(.success)
                }
            }
        }
    }
}

// MARK: - Provate methods

extension ViewModel {
    
    private func returnImageBlock(_ image: UIImage?) -> [Float] {
        guard let image = image, let mnistImage = self.imgProcessor.resize(image: image) else {
            return []
        }
        print(self.imgProcessor.imageBlock(image: mnistImage))
        return self.imgProcessor.imageBlock(image: mnistImage)
    }
}

/// The example Never function return
func fatal() -> Never {
    fatalError("Something very, very bad happened! Crash the app!")
}
