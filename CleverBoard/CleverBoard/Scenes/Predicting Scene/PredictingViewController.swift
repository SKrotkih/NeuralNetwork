//
//  PredictingViewController.swift
//  CleverBoard
//

import UIKit
import RxSwift
import RxCocoa
import AudioToolbox

class PredictingViewController: UIViewController {

    enum StateView {
        case prepareToDraw
        case readyToRun
        case showResult(Int)
        case failedPredict
    }
    
    private let viewModel = PredictingViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var resultBackgroundView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var runButtonBackgroundView: UIView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    fileprivate var drawedImage: UIImage? {
        return self.drawView.getImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateView = .prepareToDraw
        configureViews()
    }
    
    private func configureViews() {
        configure(view: self.view)
        configure(view: drawView)
        configure(view: resultBackgroundView)
        configure(view: explainLabel)
        bindToRunPredictionButton()
        bindToBackButton()
        subscribeToDrawingState()
    }
    
    private func configure(view: UIView) {
        switch view {
        case self.view:
            title = "RECOGNITION"
        case resultBackgroundView:
            resultBackgroundView.layer.borderColor = UIColor.red.cgColor
            resultBackgroundView.layer.borderWidth = 1.0
            resultBackgroundView.layer.cornerRadius = resultBackgroundView.bounds.height / 2.0
        case drawView:
            drawView.isUserInteractionEnabled = true
        case explainLabel:
            explainLabel.isHidden = false
            explainLabel.text = "DRAW A DECIMAL NUMBER"
        default:
            break
        }
    }
    
    private var stateView: StateView = .prepareToDraw {
        didSet {
            switch stateView {
            case .prepareToDraw:
                drawView.clear()
                resultBackgroundView.isHidden = true
                runButtonBackgroundView.isHidden = true
                explainLabel.isHidden = true
            case .readyToRun:
                runButtonBackgroundView.isHidden = false
            case .showResult(let number):
                resultLabel.text = "\(number)"
                explainLabel.isHidden = true
                runButtonBackgroundView.isHidden = true
                resultBackgroundView.isHidden = false
                SystemSoundID.playFileNamed(fileName: "correct", withExtenstion: "wav")
            case .failedPredict:
                resultLabel.text = "?"
                explainLabel.isHidden = true
                runButtonBackgroundView.isHidden = true
                resultBackgroundView.isHidden = false
                SystemSoundID.playFileNamed(fileName: "wrong", withExtenstion: "wav")
            }
        }
    }

    private func bindToRunPredictionButton() {
        runButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.run()
        }).disposed(by: disposeBag)
    }

    private func bindToBackButton() {
        backButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}

// MARK: - Run to recognize smile symbol for the current image

extension PredictingViewController {
    
    private func run() {
        viewModel.predict(image: self.drawedImage) { [weak self] result in
            guard let `self` = self else {
                return
            }
            switch result {
            case .noimage:
                break
            case .isnottrained:
                self.showNotReady()
                self.stateView = .prepareToDraw
            case .wrong:
                stateView = .failedPredict
            case .success(let index):
                self.stateView = .showResult(index)
            }
        }
    }
    
    private func showNotReady() {
        let alertController = UIAlertController(title: "Too hurry!", message: "Neural Network has not trained yet! Please go to TRAINING screen", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func subscribeToDrawingState() {
        drawView.drawingState.subscribe(onNext: { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .started:
                self.stateView = .prepareToDraw
            case .inProcess:
                break
            case .finished:
                self.stateView = .readyToRun
            }
        }).disposed(by: disposeBag)
    }
}
