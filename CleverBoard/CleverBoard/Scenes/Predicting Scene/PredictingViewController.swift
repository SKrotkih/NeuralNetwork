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

    private let viewModel = PredictingViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var resultBackgroundView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var runButton: UIButton!

    fileprivate var drawedImage: UIImage? {
        return self.drawView.getImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView(resultBackgroundView)
        bindButton()
    }
    
    private func configureView(_ view: UIView) {
        switch view {
        case resultBackgroundView:
            resultBackgroundView.layer.borderColor = UIColor.red.cgColor
            resultBackgroundView.layer.borderWidth = 1.0
            resultBackgroundView.layer.cornerRadius = resultBackgroundView.bounds.height / 2.0
        default:
            break
        }
    }

    private func bindButton() {
        runButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.run()
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
                self.drawView.clear()
            case .wrong:
                self.showWrong()
            case .success(let index):
                self.showSuccess(index)
            }
        }
    }
    
    private func showWrong() {
        self.resultLabel.text = "?"
        SystemSoundID.playFileNamed(fileName: "wrong", withExtenstion: "wav")
    }
    
    private func showSuccess(_ index: Int) {
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
