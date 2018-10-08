import UIKit

struct Settings {
    static let imageResolution = 8
    static let inputSize = Settings.imageResolution * Settings.imageResolution
    static let hiddenSize = 21
    static let outputSize = 10
    static let predictionThreshold: Float = 0.8
    
    static let minWeight: Float = -2.0
    static let maxWeight: Float = 2.0
    
    static let learningRate: Float = 0.3
    static let momentum: Float = 0.6
    static let iterations: Int = 10000 // 70000
    
    static let maxTrainingImages = Settings.outputSize * 1 // 3
    static let middleTrainingImages = Settings.outputSize * 2
    
    static let traningResults: [[Float]] = [
        [1,0,0,0,0,0,0,0,0,0], // 0
        [0,1,0,0,0,0,0,0,0,0], // 1
        [0,0,1,0,0,0,0,0,0,0], // 2
        [0,0,0,1,0,0,0,0,0,0], // 3
        [0,0,0,0,1,0,0,0,0,0], // 4
        [0,0,0,0,0,1,0,0,0,0], // 5
        [0,0,0,0,0,0,1,0,0,0], // 6
        [0,0,0,0,0,0,0,1,0,0], // 7
        [0,0,0,0,0,0,0,0,1,0], // 8
        [0,0,0,0,0,0,0,0,0,1]  // 9
    ]
}
