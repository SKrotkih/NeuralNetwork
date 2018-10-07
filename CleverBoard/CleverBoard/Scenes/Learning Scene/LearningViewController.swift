//
//  LearningViewController.swift
//  CleverBoard
//

import UIKit
import RxSwift
import RxCocoa

class LearningViewController: UIViewController {

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

    private lazy var viewModel = {
        return LearningViewModel(self)
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
                explainLabel.isHidden = false
                explainLabel.text = "🤖 LEARNING AND THINKING 💭"
                explainLabel.startBlink()
            } else {
                leftItemsLabel.isHidden = false
                targetBackgroundView.isHidden = false
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
            guard let image = self.drawedImage else {
                return
            }
            self.viewModel.addTraningImage(image)
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let predictVC = segue.destination as? PredictingViewController {
            predictVC.viewModel.neuralNetwork = viewModel.neuralNetwork
        }
    }
    
}

// MARK: - ViewModeOutput

extension LearningViewController: ViewModeOutput {
    
    func setupNextNumber(_ nextItemNumber: Int) {
        self.drawView.clear()
        self.explainLabel.isHidden = false
        self.index = nextItemNumber
    }
    
    func setupLeftNumbers(_ leftItemsCount: Int) {
        self.leftItemsLabel.text = "You have been left just \(leftItemsCount) items"
    }
    
    func willStartLearning() {
        isLearningInProcess = true
    }
    
    func didFinishLearning() {
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
