import UIKit

struct Settings {
    static let imageResolution = 8
    static let inputSize = Settings.imageResolution * Settings.imageResolution
    static let hiddenSize = 20
    static let outputSize = 10
    static let predictionThreshold: Float = 0.8
    
    static let minWeight: Float = -2.0
    static let maxWeight: Float = 2.0
    
    // learning rate and moment are used for the backpropagation
    // algorithm for improving performance (trial and error).
    // Momentum determines the percent of the previous iteration's
    // weight change that should be applied to this iteration.
    // Momentum is optional.
    static let learningRate: Float = 0.3
    static let momentum: Float = 0.6
    
    static let iterations: Int = 1000 // 70000
    
    static let traningTargets: [[Float]] = [
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
