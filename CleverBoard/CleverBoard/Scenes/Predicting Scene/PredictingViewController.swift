//
//  PredictingViewController.swift
//  CleverBoard
//
//  Created by Сергей Кротких on 06/10/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AudioToolbox

class PredictingViewController: UIViewController {

    enum StateView {
        case prepareToDraw
        case readyToRun
        case showResult
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
    
    private var stateView: StateView = .prepareToDraw {
        didSet {
            switch stateView {
            case .prepareToDraw:
                drawView.clear()
                resultBackgroundView.isHidden = true
                runButtonBackgroundView.isHidden = true
                explainLabel.isHidden = false
                explainLabel.text = "DRAW A DECIMAL NUMBER"
            case .readyToRun:
                runButtonBackgroundView.isHidden = false
            case .showResult:
                explainLabel.isHidden = false
                resultBackgroundView.isHidden = false
                runButtonBackgroundView.isHidden = true
            case .failedPredict:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        stateView = .prepareToDraw
    }
    
    private func configureViews() {
        configure(view: self.view)
        configure(view: drawView)
        configure(view: resultBackgroundView)
        bindRunButton()
        bindBackButton()
    }
    
    private func configure(view: UIView) {
        switch view {
        case self.view:
            title = "PREDICTION"
        case resultBackgroundView:
            resultBackgroundView.layer.borderColor = UIColor.red.cgColor
            resultBackgroundView.layer.borderWidth = 1.0
            resultBackgroundView.layer.cornerRadius = resultBackgroundView.bounds.height / 2.0
        case drawView:
            drawView.delegate = self
            drawView.isUserInteractionEnabled = true
        default:
            break
        }
    }

    private func bindRunButton() {
        runButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.run()
        }).disposed(by: disposeBag)
    }

    private func bindBackButton() {
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
                self.showWrong()
            case .success(let index):
                self.showSuccess(index)
                self.stateView = .showResult
            }
        }
    }
    
    private func showWrong() {
        self.resultLabel.text = "?"
        SystemSoundID.playFileNamed(fileName: "wrong", withExtenstion: "wav")
    }
    
    private func showSuccess(_ index: Int) {
        self.stateView = .showResult
        self.resultLabel.text = "\(index + 1)"
        SystemSoundID.playFileNamed(fileName: "correct", withExtenstion: "wav")
    }
    
    private func showNotReady() {
        let alertController = UIAlertController(title: "Too hurry!", message: "You should train the network before. shapes", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: - DrawViewDelegate

extension PredictingViewController: DrawViewDelegate {
    
    public func drawViewWillStart() {
        drawView.clear()
        explainLabel.isHidden = true
    }
    
    public func drawViewMoved(view: DrawView) {

    }
    
    public func drawViewDidFinishDrawing(view: DrawView) {
        stateView = .readyToRun
    }
}
