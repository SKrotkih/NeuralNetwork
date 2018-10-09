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
    
    private var learningToolBar: LearningToolBar!
    
    private lazy var viewModel = {
        return LearningViewModel()
    }()

    private var drawedImage: UIImage? {
        return self.drawView.getImage()
    }

    private var isLearningInProcess = false {
        didSet {
            if isLearningInProcess {
                drawView.clear()
                drawView.isUserInteractionEnabled = false
                teachButtonBackgroundView.isHidden = true
                learningToolBar.isHidden = true
                explainLabel.isHidden = false
                explainLabel.text = "LEARNING..."
                explainLabel.startBlink()
            } else {
                teachButtonBackgroundView.isHidden = false
                explainLabel.stopBlink()
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
            case .start:
                self.isLearningInProcess = true
            case .finish:
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    // Learning is finished
                    self.isLearningInProcess = false
                    self.performSegue(withIdentifier: "predict", sender: self)
                }
            }
        }).disposed(by: disposeBag)
    }
}
