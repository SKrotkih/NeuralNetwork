//
//  ModelWorker.swift
//  CleverBoard
//

import UIKit

struct ModelWorker {
    
    /// The Image Processor
    fileprivate lazy var imgProcessor: ImageProcessor = {
        let imgProcessor = ImageProcessor()
        return imgProcessor
    }()

    mutating func returnImageBlock(_ image: UIImage?) -> [Float] {
        guard let image = image, let mnistImage = self.imgProcessor.resize(image: image) else {
            return []
        }
        print(self.imgProcessor.imageBlock(image: mnistImage))
        return self.imgProcessor.imageBlock(image: mnistImage)
    }
}
