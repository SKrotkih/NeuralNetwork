//
//  LearningViewModel.swift
//  CleverBoard
//

import UIKit
import RxSwift

enum LearningStage {
    case started
    case finished
    case cancelled
}

enum LearningErrors: Error {
    case dataAbsent
}

protocol TrainingNumberable: class {
    var selectedNumberItem: PublishSubject<LearningToolbarItem> {get}
    var selectedNumber: PublishSubject<Int> {get}
    var index: Int {get}
}

protocol TrainingImagesProviding: class {
    var trainingImages: [[UIImage]]? {get}
}

final class LearningViewModel {
  
    deinit {
        Log()
    }
    
    var learningStage = PublishSubject<LearningStage>()
    var predictionResult = PublishSubject<LearningToolbarPredictedIndex>()
    var currentTrainedNumber = PublishSubject<Int>()
    
    weak var trainingImagesProvider: TrainingImagesProviding!
    
    weak var trainingNumberItem: TrainingNumberable! {
        didSet {
            subscribeToSelectedNumberItem()
            subscribeToSelectedNumber()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    func cancelProcess() {
        neuralNetwork.cancelProcess()
    }
    
    /// The Neural Network 🚀
    private lazy var neuralNetwork: NeuralNetwork = {
        return NeuralNetwork()
    }()
    
    private lazy var modelWorker: ModelWorker = {
        return ModelWorker()
    }()

    var percentageProgress: PublishSubject<Float> {
        return neuralNetwork.percentageProgress
    }
    
    private func data(for number: Int) throws -> [[Float]] {
        guard let inputImages = self.trainingImagesProvider.trainingImages,
            inputImages[number].count > 0 else {
                throw LearningErrors.dataAbsent
        }
        var input: [[Float]] = []
        inputImages[number].forEach({ image in
            input.append(modelWorker.returnImageBlock(image))
        })
        return input
    }
    
    func learnNetwork() throws {
        let number = trainingNumberItem.index
        let input = try data(for: number)
        learningStage.onNext(.started)
        neuralNetwork.learn(number: number, input: input) { [weak self] state in
            if state == .finished {
                self?.learningStage.onNext(.finished)
            } else if state == .cancelled {
                self?.learningStage.onNext(.cancelled)
            }
        }
    }
    
    private func predictNumber(for selectedItem: LearningToolbarItem) {
        let input = modelWorker.returnImageBlock(selectedItem.image)
        neuralNetwork.predict(input: input) { [weak self] result in
            guard let `self` = self else {
                return
            }
            switch result {
            case .noimage, .isnottrained:
                break
            case .wrong:
                break
            case .success(let index):
                self.predictionResult.onNext((index, selectedItem.number, selectedItem.index))
                break
            }
        }
    }
}

// Listening to Learning toolbar

extension LearningViewModel {
    
    private func subscribeToSelectedNumberItem() {
        trainingNumberItem.selectedNumberItem.subscribe(onNext: { [weak self] selectedItem in
            guard let `self` = self else { return }
            self.predictNumber(for: selectedItem)
        }).disposed(by: disposeBag)
    }
    
    private func subscribeToSelectedNumber() {
        trainingNumberItem.selectedNumber.subscribe(onNext: { [weak self] selectedNumber in
            guard let `self` = self else { return }
            self.currentTrainedNumber.onNext(selectedNumber)
        }).disposed(by: disposeBag)
    }
}
