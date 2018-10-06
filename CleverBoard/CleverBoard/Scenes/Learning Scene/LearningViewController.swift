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
    @IBOutlet weak var teachButton: UIButton!
    @IBOutlet weak var leftItemsLabel: UILabel!

    /// The index to update the UI
    fileprivate var index: Int = 0  {
        didSet {
            configure(view: self.targetLabel)
        }
    }

    /// The Image Processor
    fileprivate lazy var imgProcessor: ImageProcessor = {
        return ImageProcessor()
    }()
    
    fileprivate var drawedImage: UIImage? {
        return self.drawView.getImage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    private func configureViews() {
        listeningTrainingData()
        configure(view: drawView)
        configure(view: targetBackgroundView)
        configure(view: targetLabel)
        configure(view: explainLabel)
        bindTeachButton()
    }
    
    private func configure(view: UIView) {
        switch view {
        case targetBackgroundView:
            targetBackgroundView.layer.borderColor = UIColor.red.cgColor
            targetBackgroundView.layer.borderWidth = 1.0
            targetBackgroundView.layer.cornerRadius = targetBackgroundView.bounds.height / 2.0
        case targetLabel:
            targetLabel.text = "\(index + 1)"
            explainLabel.text = "DRAW NUMBER \(index + 1)"
            leftItemsLabel.text = "You have been left just \(Settings.maxTrainingImages - index) items"
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
            self.configureStatusView(for: trainingData.count)
        }).disposed(by: disposeBag)
    }

    private func configureStatusView(for trainingItemsCount: Int) {
        if trainingItemsCount == Settings.maxTrainingImages {
            drawView.clear()
            drawView.isUserInteractionEnabled = false
            learnNetwork()
        }
    }
    
    /// Sart the learning process
    private func learnNetwork() {
        explainLabel.text = "🤖 LEARNING AND THINKING 💭"
        explainLabel.startBlink()
        viewModel.learnNetwork() {
            DispatchQueue.main.async {
                // Learning is finished
                self.explainLabel.stopBlink()
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
