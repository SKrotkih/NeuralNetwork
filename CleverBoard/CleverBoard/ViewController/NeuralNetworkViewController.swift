import UIKit
import RxSwift
import RxCocoa
import AudioToolbox

public class NeuralNetworkViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    private func configureView() {
        setupConstraints()
        listeningTrainingData()
        configureStatusView(for: 0)
        bindPlaySectionButton()
        bindTeachSectionButton()
        bindTeachButton()
    }
    
    /// The current section
    fileprivate var currentSection: Section = .teach {
        didSet {
            drawView.clear()
            configure(view: contentView)
            configure(view: emojiLabel)
            configure(view: teachButton)
        }
    }
    
    /// The index to update the UI
    fileprivate var index: Int = 0  {
        didSet {
            configure(view: self.emojiLabel)
        }
    }

    /// The Image Processor
    fileprivate lazy var imgProcessor: ImageProcessor = {
        return ImageProcessor()
    }()
    
    /// The ProgressView for the Learning
    fileprivate lazy var progressView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        view.backgroundColor = Color.progressBgrColor
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    // MARK: - Configure Labels
    
    /// The EmojiAnimation Label
    fileprivate lazy var emojiAnimationLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = true
        label.text = "🙂"
        label.font = UIFont.systemFont(ofSize: 70.0)
        return label
    }()
    
    fileprivate var drawedImage: UIImage? {
        return self.drawView.getImage()
    }
    
    /// The Status Label
    fileprivate lazy var statusLabel: UILabel = {
       let label = UILabel()
        label.text = "🤖 TEACH ME..."
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The Explain Label
    fileprivate lazy var explainLabel: UILabel = {
        let label = UILabel()
        label.text = "DRAW A SMILE"
        label.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The Emoji Label
    fileprivate lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "🙂"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 70.0)
        return label
    }()
    
    // MARK: - Configure Buttons
    
    /// The Play Section Button
    fileprivate lazy var playSectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("PLAY", for: .normal)
        button.setTitleColor(Color.graySectionColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    /// The Teach Section Button
    fileprivate lazy var teachSectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("TEACH", for: .normal)
        button.setTitleColor(Color.sectionColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    /// The Teach Button
    fileprivate lazy var teachButton: UIButton = {
        let button = UIButton()
        button.setTitle("TEACH HAPPY", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundColor(color: Color.sectionColor, forState: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        return button
    }()

    // MARK: Bind button
    
    /// Bind "teach" button to the select section
    private func bindTeachSectionButton() {
        teachSectionButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.emojiAnimationLabel.isHidden = true
            self.currentSection = .teach
        }).disposed(by: disposeBag)
    }

    /// Bind "play" button to the select section
    private func bindPlaySectionButton() {
        playSectionButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.currentSection = .play
        }).disposed(by: disposeBag)
    }
    
    /// Bind "teach", "predict" button
    private func bindTeachButton() {
        teachButton.rx.tap.bind(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }
            switch self.currentSection {
            case .teach:
                self.addTraningImage()
                self.drawView.clear()
            case .play:
                self.run()
            }
        }).disposed(by: disposeBag)
    }

    private func addTraningImage() {
        guard let image = self.drawedImage else {
            return
        }
        self.teachButton.isHidden = true
        self.explainLabel.isHidden = false
        self.viewModel.addTraningImage(image, index: self.index)
        self.index = self.index == Settings.outputSize - 1 ? 0 : self.index + 1
    }
    
    // MARK: -
    
    /// The Draw View
    fileprivate lazy var drawView: DrawView = {
        let view = DrawView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    /// The Emoji Data Set which will be trained
    fileprivate var emojis: [NNEmoji] = {
        return Settings.emojis
    }()
    
    private func listeningTrainingData() {
        viewModel.traningData.subscribe(onNext: { trainingData in
            self.configureStatusView(for: trainingData.count)
        }).disposed(by: disposeBag)
    }
    
}

extension NeuralNetworkViewController {
    
    private func configure(view: UIView) {
        switch view {
        case self.contentView:
            if currentSection == .play {
                self.emojiLabel.fadeOut(withDuration: 0.3)
                self.playSectionButton.setTitleColor(Color.sectionColor, for: .normal)
                self.teachSectionButton.setTitleColor(Color.graySectionColor, for: .normal)
                self.explainLabel.text = "DRAW YOUR SHAPE"
                self.drawView.clear()
            } else {
                self.playSectionButton.setTitleColor(Color.graySectionColor, for: .normal)
                self.teachSectionButton.setTitleColor(Color.sectionColor, for: .normal)
                self.emojiLabel.fadeIn(withDuration: 0.3)
                self.teachButton.fadeIn(withDuration: 0.3)
                self.explainLabel.text = emojis[index].drawText
                self.drawView.clear()
            }
        case emojiLabel:
            if currentSection == .play {
                self.teachButton.setTitle("RUN", for: .normal)
            } else {
                emojiLabel.text = emojis[index].emoji
                explainLabel.text = emojis[index].drawText
                teachButton.setTitle(emojis[index].buttonText, for: .normal)
            }
            
        case emojiAnimationLabel:
            self.emojiAnimationLabel.isHidden = false
            let x = self.imgProcessor.centerOf(image: self.drawedImage!).midX
            let y = self.imgProcessor.centerOf(image: self.drawedImage!).midY
            self.emojiAnimationLabel.center = CGPoint(x: x, y: y)
          
        case teachButton:
            if self.currentSection == .play, let image = self.drawedImage {
                let hidden = imgProcessor.imageBlock(image: image).count == 0
                self.teachButton.isHidden = hidden
            }
            
        default:
            break
        }
    }

    private func configureStatusView(for trainingItemsCount: Int) {
        if trainingItemsCount == Settings.middleTrainingImages {
            statusLabel.textColor = UIColor.white
        } else if trainingItemsCount == Settings.maxTrainingImages {
            learnNetwork()
        } else if trainingItemsCount >= 0 {
            updateProgress(for: trainingItemsCount)
        }
    }
    
    /// Sart the learning process
    private func learnNetwork() {
        currentSection = .play
        statusLabel.text = "🤖 LEARNING AND THINKING 💭"
        statusLabel.startBlink()
        viewModel.learnNetwork() {
            DispatchQueue.main.async {
                // Learning is finished
                self.statusLabel.stopBlink()
                self.statusLabel.text = "🚀 Start drawing..."
            }
        }
    }
    
    /// Update progress view
    private func updateProgress(for index: Int) {
        var w: Double = 0.0
        if index > 0  {
            w = Double(self.contentView.frame.width) /  (Double(Settings.maxTrainingImages) / Double(index))
        }
        progressView.frame = CGRect(x: 0, y: 0, width: w, height: 30)
        statusLabel.text = "left \(Settings.maxTrainingImages - index)"
    }
    
    private func setupConstraints() {
        self.contentView.addSubview(drawView)
        self.drawView.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
        self.drawView.heightAnchor.constraint(equalToConstant: contentView.frame.height).isActive = true
        self.contentView.addSubview(explainLabel)
        self.explainLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.explainLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        self.contentView.addSubview(teachButton)
        self.teachButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 1.0).isActive = true
        self.teachButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.teachButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        self.teachButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0).isActive = true
        self.contentView.addSubview(emojiLabel)
        self.emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.emojiLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65.0).isActive = true
        self.contentView.addSubview(teachSectionButton)
        self.teachSectionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 45.0).isActive = true
        self.teachSectionButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 60).isActive = true
        self.contentView.addSubview(playSectionButton)
        self.playSectionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 45.0).isActive = true
        self.playSectionButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -60).isActive = true
        self.contentView.addSubview(emojiAnimationLabel)
        self.contentView.addSubview(progressView)
        self.contentView.addSubview(statusLabel)
        self.statusLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        self.statusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}

// MARK: - Run to recognize smile symbol for the current image

extension NeuralNetworkViewController {
    
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
        self.configure(view: self.emojiAnimationLabel)
        self.emojiAnimationLabel.transformAnimation()
        self.emojiAnimationLabel.text = "🤔"
        SystemSoundID.playFileNamed(fileName: "wrong", withExtenstion: "wav")
    }
    
    private func showSuccess(_ index: Int) {
        self.configure(view: self.emojiAnimationLabel)
        self.emojiAnimationLabel.transformAnimation()
        self.emojiAnimationLabel.text = self.emojis[index].emoji
        SystemSoundID.playFileNamed(fileName: "correct", withExtenstion: "wav")
    }
    
    private func showNotReady() {
        let alertController = UIAlertController(title: "Too hurry!", message: "You should train the network before. Left just \(Settings.maxTrainingImages - index) shapes", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - DrawViewDelegate

extension NeuralNetworkViewController: DrawViewDelegate {
    
    public func drawViewWillStart() {
        drawView.clear()
    }
    
    public func drawViewMoved(view: DrawView) {
        if self.currentSection == .teach {
            self.teachButton.isHidden = false
            self.explainLabel.isHidden = true
        } else {
            self.emojiAnimationLabel.isHidden = true
        }
    }

    public func drawViewDidFinishDrawing(view: DrawView) {
        configure(view: teachButton)
    }
}
