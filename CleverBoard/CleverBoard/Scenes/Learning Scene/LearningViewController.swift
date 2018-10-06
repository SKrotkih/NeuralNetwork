//
//  LearningViewController.swift
//  CleverBoard
//

import UIKit
import RxSwift
import RxCocoa

class LearningViewController: UIViewController {

    private let viewModel = LearningViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var targetBackgroundView: UIView!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var teachButtonBackgroundView: UIView!
    @IBOutlet weak var teachButton: UIButton!
    @IBOutlet weak var leftItemsLabel: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    /// The index to update the UI
    private var index: Int = 0  {
        didSet {
            configure(view: self.targetLabel)
        }
    }

    /// The Image Processor
    private lazy var imgProcessor: ImageProcessor = {
        return ImageProcessor()
    }()
    
    private var drawedImage: UIImage? {
        return self.drawView.getImage()
    }

    private var isLearningInProcess = false {
        didSet {
            if isLearningInProcess {
                drawView.clear()
                drawView.isUserInteractionEnabled = false
                leftItemsLabel.isHidden = true
                targetBackgroundView.isHidden = true
                teachButtonBackgroundView.isHidden = true
                explainLabel.text = "🤖 LEARNING AND THINKING 💭"
                explainLabel.startBlink()
            } else {
                leftItemsLabel.isHidden = false
                targetBackgroundView.isHidden = false
                teachButtonBackgroundView.isHidden = false
                self.explainLabel.stopBlink()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listeningTrainingData()
        configureViews()
    }
    
    private func configureViews() {
        configure(view: self.view)
        configure(view: drawView)
        configure(view: targetBackgroundView)
        configure(view: targetLabel)
        configure(view: explainLabel)
        bindTeachButton()
        bindBackButton()
    }
    
    private func configure(view: UIView) {
        switch view {
        case self.view:
            title = "LEARNING"
        case targetBackgroundView:
            targetBackgroundView.layer.borderColor = UIColor.red.cgColor
            targetBackgroundView.layer.borderWidth = 1.0
            targetBackgroundView.layer.cornerRadius = targetBackgroundView.bounds.height / 2.0
        case targetLabel:
            if isLearningInProcess == false {
                targetLabel.text = "\(index + 1)"
                explainLabel.text = "DRAW NUMBER \(index + 1)"
            }
        case explainLabel:
            explainLabel.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
            explainLabel.textColor = UIColor.lightGray
            explainLabel.textAlignment = .center
        case drawView:
            drawView.delegate = self
            drawView.isUserInteractionEnabled = true
        default:
            break
        }
    }

    private func bindBackButton() {
        backButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindTeachButton() {
        teachButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.drawView.clear()
            self.explainLabel.isHidden = false
            self.addTraningImage()
        }).disposed(by: disposeBag)
    }

    private func addTraningImage() {
        guard let image = self.drawedImage else {
            return
        }
        self.viewModel.addTraningImage(image, index: self.index)
        self.index = self.index == Settings.outputSize - 1 ? 0 : self.index + 1
    }
    
    private func listeningTrainingData() {
        viewModel.traningData.subscribe(onNext: { trainingData in
            let leftItems = Settings.maxTrainingImages - trainingData.count
            if leftItems == 0 {
                self.learnNetwork()
            } else {
                self.leftItemsLabel.text = "You have been left just \(leftItems) items"
            }
        }).disposed(by: disposeBag)
    }
    
    /// Sart the learning process
    private func learnNetwork() {
        isLearningInProcess = true
        viewModel.learnNetwork() {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {
                    return
                }
                // Learning is finished
                self.isLearningInProcess = false
                self.performSegue(withIdentifier: "predict", sender: self)
            }
        }
    }
}

// MARK: - DrawViewDelegate

extension LearningViewController: DrawViewDelegate {
    
    public func drawViewWillStart() {
        drawView.clear()
        self.explainLabel.isHidden = true
    }
    
    public func drawViewMoved(view: DrawView) {
    }
    
    public func drawViewDidFinishDrawing(view: DrawView) {
        configure(view: teachButton)
    }
}
