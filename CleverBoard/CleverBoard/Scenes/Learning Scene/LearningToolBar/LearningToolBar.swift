//
//  LearningToolBar.swift
//  CleverBoard
//

import UIKit
import RxSwift
import RxCocoa

typealias LearningToolbarItem = (image: UIImage, number: Int, index: Int)
typealias LearningToolbarPredictedIndex = (predicted: Int, number: Int, index: Int)

class LearningToolBar: UIView, TrainingImagesProviding, TrainingNumberable {

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
    
    @IBOutlet weak var chkIm1: UIImageView!
    @IBOutlet weak var chkIm2: UIImageView!
    @IBOutlet weak var chkIm3: UIImageView!
    @IBOutlet weak var chkIm4: UIImageView!
    @IBOutlet weak var chkIm5: UIImageView!
    
    private var bgs: [UIView] = []
    private var imgs: [UIImageView] = []
    private var chkImgs: [UIImageView] = []
    private var paints: [[UIImage?]]!
    
    private let disposeBag = DisposeBag()
    
    var selectedNumberItem = PublishSubject<LearningToolbarItem>()
    var selectedNumber = PublishSubject<Int>()
    
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
            assert(false, "Failed to generate LearningToolBar!")
            return LearningToolBar()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        bgs = [n0bg, n1bg, n2bg, n3bg, n4bg, n5bg, n6bg, n7bg, n8bg, n9bg]
        imgs = [im1, im2, im3, im4, im5]
        chkImgs = [chkIm1, chkIm2, chkIm3, chkIm4, chkIm5]
        paints = Array(repeating: Array(repeating: nil, count: 5), count: Settings.outputSize)
        bindTabBarButtonItems()
        bindTabBarItemTemplates()
        restoreImages()
    }
    
    // Index of the tab item
    var index: Int = -1 {
        didSet {
            if oldValue == index {
                return
            }
            // clean borders
            bgs.forEach { (view) in
                view.layer.borderColor = UIColor.white.cgColor
                view.backgroundColor = UIColor.lightGray
                view.layer.borderWidth = 1.0
            }
            // clean all predicted signs
            chkImgs.forEach { (imageView) in
                imageView.isHidden = true
            }
            // highlight border of the selected item
            UIView.animate(withDuration: 0.3, animations: {
                self.bgs[self.index].backgroundColor = UIColor.red
            })
            // fill all images for current tab item
            imgs.enumerated().forEach { (arg) in
                let (i, imageView) = arg
                imageView.image = paints[index][i]
            }
            // start drawing a new training template
            drawView.clear()
            self.explainLabel.isHidden = false
            explainLabel.text = "DRAW NUMBER \(index)"
            selectedNumber.onNext(index)
        }
    }
    
    // restore all training templates from the documents directory
    private func restoreImages() {
        for index in 0..<paints.count {
            for itemIndex in 0..<5 {
                let fName = fileName(index: index, itemIndex: itemIndex)
                if let image = UIImage.retrieve(fileName: fName) {
                    paints[index][itemIndex] = image
                } else {
                    paints[index][itemIndex] = nil
                }
            }
        }
    }
    
    private func fileName(index: Int, itemIndex: Int) -> String {
        return "\(index)_\(itemIndex).png"
    }

    var predictedItem: LearningToolbarPredictedIndex = (0, 0, 0) {
        didSet {
            if predictedItem.predicted == self.index {
                chkImgs[predictedItem.index].isHidden = false
            } else {
                chkImgs[predictedItem.index].isHidden = true
            }
        }
    }
    
    // did touch on the template image
    private func didSelectTemplate(_ index: Int) {
        if let _image = imgs[index].image {
            // there is an image already
            selectedNumberItem.onNext((image: _image, number: self.index, index: index))
            return
        }
        guard let image = self.drawView.getImage() else {
            return
        }
        // copy current image to the toolbar
        imgs[index].image = image
        paints[self.index][index] = image
        do {
            try image.save(to: "\(self.index)_\(index)")
        } catch(let error) {
            print("\(error)")
        }
        // start drawing next template
        drawView.clear()
        explainLabel.isHidden = false
        explainLabel.text = "DRAW NUMBER \(self.index)"
    }
    
    private func removeImg(_ index: Int) {
        let fName = fileName(index: self.index, itemIndex: index)
        UIImage.remove(fileName: fName)
        imgs[index].image = nil
        chkImgs[index].isHidden = true
    }
    
    private func bindTabBarButtonItems() {
        bgs.forEach { (view) in
            /// Select button with a number for starting to paint next training image
            let tapGesture = UITapGestureRecognizer()
            tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
                self?.index = view.tag
            }).disposed(by: disposeBag)
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    private func bindTabBarItemTemplates() {
        imgs.forEach { (imageView) in
            /// Add image to the current number pane
            let tapGesture = UITapGestureRecognizer()
            tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
                self?.didSelectTemplate(imageView.tag)
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
