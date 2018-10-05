import UIKit

struct Settings {
    static let inputSize = 64
    static let hiddenSize = 15
    static let outputSize = 6
    static let predictionThreshold: Float = 0.8
    
    static let minWeight: Float = -2.0
    static let maxWeight: Float = 2.0
    
    static let learningRate: Float = 0.3
    static let momentum: Float = 0.6
    static let iterations: Int = 1000  //70000
    
    static let maxTrainingImages = Settings.outputSize * 3
    static let middleTrainingImages = Settings.outputSize * 2
    
    static let traningResults: [[Float]] = [
        [1,0,0,0,0,0], // 🙂
        [0,1,0,0,0,0], // 😮
        [0,0,1,0,0,0], // 😍
        [0,0,0,1,0,0], // 😴
        [0,0,0,0,1,0], // 😐
        [0,0,0,0,0,1]  // ☹️
    ]
}

struct Color {
    static let sectionColor = UIColor(red: 235.0 / 255.0, green: 28.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    static let graySectionColor = UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
    static let progressBgrColor = UIColor(red: 235.0 / 255.0, green: 28.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
}
