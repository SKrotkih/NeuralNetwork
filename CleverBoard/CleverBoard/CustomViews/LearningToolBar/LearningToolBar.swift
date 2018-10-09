//
//  LearningToolBar.swift
//  CleverBoard
//

import UIKit
import RxSwift
import RxCocoa

class LearningToolBar: UIView, TrainingImagesProviding {

    weak var drawView: DrawView!
    weak var explainLabel: UILabel! {
        didSet {
            self.index = 0
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var n0bg: UIView!
    @IBOutlet weak var n1bg: UIView!
    @IBOutlet weak var n2bg: UIView!
    @IBOutlet weak var n3bg: UIView!
    @IBOutlet weak var n4bg: UIView!
    @IBOutlet weak var n5bg: UIView!
    @IBOutlet weak var n6bg: UIView!
    @IBOutlet weak var n7bg: UIView!
    @IBOutlet weak var n8bg: UIView!
    @IBOutlet weak var n9bg: UIView!

    @IBOutlet weak var im1: UIImageView!
    @IBOutlet weak var im2: UIImageView!
    @IBOutlet weak var im3: UIImageView!
    @IBOutlet weak var im4: UIImageView!
    @IBOutlet weak var im5: UIImageView!
    
    private var bgs: [UIView] = []
    private var imgs: [UIImageView] = []
    private var paints: [[UIImage?]]!
    private let disposeBag = DisposeBag()
    
    var trainingImages: [[UIImage]]? {
        var _images: [[UIImage]]?
        for trainingImages in paints {
            let images = trainingImages.filter { (image) -> Bool in
                return image != nil
                } as! [UIImage]
            if images.count > 0 {
                if _images == nil {
                    _images = [images]
                } else {
                    _images!.append(images)
                }
            }
        }
        return _images
    }
    
    static func getInstance(for superView: UIView) -> LearningToolBar {
        if let view = UIView.loadFrom(nibNamed: "LearningToolBar") as? LearningToolBar {
            view.frame = superView.bounds
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            superView.addSubview(view)
            return view
        } else {
            assert(false, "LearningToolBar is not defined!")
            return LearningToolBar()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        bgs = [n0bg, n1bg, n2bg, n3bg, n4bg, n5bg, n6bg, n7bg, n8bg, n9bg]
        imgs = [im1, im2, im3, im4, im5]
        paints = Array(repeating: Array(repeating: nil, count: 5), count: Settings.outputSize)
        bindButtons()
        bindImages()
        restoreImages()
    }
    
    private var index: Int = -1 {
        didSet {
            if oldValue == index {
                return
            }
            bgs.forEach { (view) in
                view.layer.borderColor = UIColor.white.cgColor
                view.backgroundColor = UIColor.lightGray
                view.layer.borderWidth = 1.0
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.bgs[self.index].backgroundColor = UIColor.red
            })
            imgs.enumerated().forEach { (arg) in
                let (i, imageView) = arg
                imageView.image = paints[index][i]
            }
            drawView.clear()
            self.explainLabel.isHidden = false
            explainLabel.text = "DRAW NUMBER \(index)"
        }
    }
    
    private func restoreImages() {
        for index in 0..<paints.count {
            for itemIndex in 0..<5 {
                let fileName = "\(index)_\(itemIndex).png"
                if let image = UIImage.retrieve(fileName: fileName) {
                    paints[index][itemIndex] = image
                }
            }
        }
    }
    
    private func selectImg(_ index: Int) {
        guard let image = self.drawView.getImage() else {
            return
        }
        imgs[index].image = image
        paints[self.index][index] = image
        do {
            try image.save(to: "\(self.index)_\(index)")
        } catch(let error) {
            print("\(error)")
        }
        drawView.clear()
        explainLabel.isHidden = false
        explainLabel.text = "DRAW NUMBER \(self.index)"
    }
    
    private func removeImg(_ index: Int) {
        imgs[index].image = nil
    }
    
    private func bindButtons() {
        bgs.forEach { (view) in
            /// Select button with a number for starting to paint next training image
            let tapGesture = UITapGestureRecognizer()
            tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
                self?.index = view.tag
            }).disposed(by: disposeBag)
            view.addGestureRecognizer(tapGesture)

        }
    }
    
    private func bindImages() {
        imgs.forEach { (imageView) in
            /// Add image to the current number pane
            let tapGesture = UITapGestureRecognizer()
            tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
                self?.selectImg(imageView.tag)
            }).disposed(by: disposeBag)
            imageView.addGestureRecognizer(tapGesture)
            
            /// Swipe down gesture for cleaning current image view
            let swipeGesture = UISwipeGestureRecognizer()
            swipeGesture.direction = .down
            swipeGesture.rx.event.bind(onNext: { [weak self] recognizer in
                self?.removeImg(imageView.tag)
            }).disposed(by: disposeBag)
            imageView.addGestureRecognizer(swipeGesture)
        }
    }
}
