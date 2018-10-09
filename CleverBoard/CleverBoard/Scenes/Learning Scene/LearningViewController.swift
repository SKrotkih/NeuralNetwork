//
//  LearningViewController.swift
//  CleverBoard
//

import UIKit
import RxSwift
import RxCocoa

class LearningViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var teachButtonBackgroundView: UIView!
    @IBOutlet weak var teachButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var learningInProgressView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var learningLabel: UILabel!

    private var learningToolBar: LearningToolBar!
    
    deinit {
        Log()
    }

    private lazy var viewModel = {
        return LearningViewModel()
    }()

    private var drawedImage: UIImage? {
        return self.drawView.getImage()
    }

    private var isLearningInProcess = false {
        didSet {
            if isLearningInProcess {
                explainLabel.isHidden = true
                learningInProgressView.isHidden = false
                learningLabel.text = "LEARNING..."
                learningLabel.startBlink()
            } else {
                learningInProgressView.isHidden = true
                learningLabel.stopBlink()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    private func configureViews() {
        configure(view: self.view)
        configure(view: drawView)
        configure(view: explainLabel)
        configure(view: toolBar)
        configure(view: learningInProgressView)
        bindTeachButton()
        bindBackButton()
        subscribeOnDrawingProcessState()
    }
    
    private func configure(view: UIView) {
        switch view {
        case self.view:
            title = "LEARNING"
        case explainLabel:
            explainLabel.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
            explainLabel.textColor = UIColor.lightGray
            explainLabel.textAlignment = .center
        case drawView:
            drawView.isUserInteractionEnabled = true
        case toolBar:
            createToolBar()
        case learningInProgressView:
            learningInProgressView.isHidden = true
        default:
            break
        }
    }

    private func createToolBar() {
        learningToolBar = LearningToolBar.getInstance(for: toolBar)
        DispatchQueue.main.async {
            self.learningToolBar.drawView = self.drawView
            self.learningToolBar.explainLabel = self.explainLabel
            self.viewModel.trainingImagesProvider = self.learningToolBar
        }
    }
    
    private func bindBackButton() {
        backButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.viewModel.cancelProcess()
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindTeachButton() {
        teachButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.learn()
        }).disposed(by: disposeBag)
    }
    
    private func subscribeOnDrawingProcessState() {
        drawView.drawingState.subscribe(onNext: { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .started:
                self.drawView.clear()
                self.explainLabel.isHidden = true
            case .inProcess:
                break
            case .finished:
                break
            }
        }).disposed(by: disposeBag)
    }
}

extension LearningViewController {
    
    private func learn() {
        do {
            subscribeOnLearningStateChanging()
            subscribeOnPercentageProcess()
            try self.viewModel.learnNetwork()
        } catch(let error) {
            if error as! LearningErrors == .dataAbsent {
                let alertController = UIAlertController(title: "", message: "Every tab has to have at least one image! Please check it", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
                }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    private func subscribeOnLearningStateChanging() {
         viewModel.processState.subscribe(onNext: { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .started:
                self.isLearningInProcess = true
            case .finished:
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    // Learning is finished
                    self.isLearningInProcess = false
                    self.performSegue(withIdentifier: "predict", sender: self)
                }
            case .cancelled:
                self.isLearningInProcess = false
            }
        }).disposed(by: disposeBag)
    }
    
    private func subscribeOnPercentageProcess() {
        viewModel.percentageProgress.subscribe(onNext: { [weak self] percent in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.progressView.progress = percent
            }
        }).disposed(by: disposeBag)
    }
}
