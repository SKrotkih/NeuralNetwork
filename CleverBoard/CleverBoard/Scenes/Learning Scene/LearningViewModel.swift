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
    var selectItemImage: PublishSubject<SelectedToolbarIndex> {get}
}

final class LearningViewModel {
  
    deinit {
        Log()
    }
    
    var processState = PublishSubject<LearningState>()
    var predictedIndex = PublishSubject<PredictedItem>()
    
    weak var trainingImagesProvider: TrainingImagesProviding! {
        didSet {
            trainingImagesProvider.selectItemImage.subscribe(onNext: { [weak self] selectedItem in
                guard let `self` = self else { return }
                self.check(selectedItem: selectedItem)
            })
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
    
    private func data() throws -> (input: [[Float]], target: [[Float]]) {
        guard let inputImages = self.trainingImagesProvider.trainingImages,
            inputImages.count == Settings.outputSize,
            Settings.traningTargets.count == Settings.outputSize else {
                throw LearningErrors.dataAbsent
        }
        var target: [[Float]] = []
        var input: [[Float]] = []
        for index in 0..<Settings.outputSize {
            for image in inputImages[index] {
                target.append(Settings.traningTargets[index])
                input.append(modelWorker.returnImageBlock(image))
            }
        }
        return (input: input, target: target)
    }
    
    func learnNetwork() throws {
        let (input: input, target: target) = try data()
        processState.onNext(.started)
        neuralNetwork.learn(input: input, target: target) { [weak self] state in
            if state == .finished {
                self?.processState.onNext(.finished)
            } else if state == .cancelled {
                self?.processState.onNext(.cancelled)
            }
        }
    }
    
    private func check(selectedItem: SelectedToolbarIndex) {
        let input = modelWorker.returnImageBlock(selectedItem.0)
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
                self.predictedIndex.onNext((index, selectedItem.1, selectedItem.2))
                break
            }
        }
    }
}
