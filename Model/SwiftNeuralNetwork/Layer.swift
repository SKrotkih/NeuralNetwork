import Foundation


public class Layer {
    
    private var inputSize: Int = 0
    private var outputSize: Int = 0
    
    private lazy var output: [Float] = {
        return [Float](repeating: 0, count: outputSize)
    }()
    
    private lazy var input: [Float] = {
        return [Float](repeating: 0, count: inputSize + 1)
    }()
    
    private lazy var weights: [Float] = {
        let weights = (0..<(1 + inputSize) * outputSize).map { _ in
            return (self.inputMinValue...self.inputMaxValue).random()
        }
        return weights
    }()
    
    private lazy var previousWeights: [Float] = {
        return [Float](repeating: 0, count: weights.count)
    }()
    
    private lazy var settings: Settings = {
        var settings = Settings()
        settings.configure()
        return settings
    }()
    
    /// Learning rate
    private lazy var inputMinValue: Float = {
        return settings.inputMinValue
    }()

    /// Learning rate
    private lazy var inputMaxValue: Float = {
        return settings.inputMaxValue
    }()

    /// Learning rate
    fileprivate lazy var learningRate: Float = {
        return settings.learningRate
    }()
    
    /// Momentum
    fileprivate lazy var momentum: Float = {
        return settings.momentum
    }()
    
    init(inputSize: Int, outputSize: Int) {
        self.inputSize = inputSize
        self.outputSize = outputSize
    }
}

// MARK: - 

extension Layer {
    
    public func train(error: [Float]) -> [Float] {
        
        var offset = 0
        var nextError = [Float](repeating: 0, count: input.count)
        
        for i in 0..<output.count {
            
            let delta = error[i] * ActivationFunction.sigmoidDerivative(x: output[i])
            
            for j in 0..<input.count {
                let weightIndex = offset + j
                nextError[j] = nextError[j] + weights[weightIndex] * delta
                let dw = input[j] * delta * learningRate
                weights[weightIndex] += previousWeights[weightIndex] * momentum + dw
                previousWeights[weightIndex] = dw
            }
            
            offset += input.count
        }
        
        return nextError
    }
    
    public func run(inputArray: [Float]) -> [Float] {
        
        for i in 0..<inputArray.count {
            input[i] = inputArray[i]
        }
        
        input[input.count-1] = 1
        var offSet = 0
        
        for i in 0..<output.count {
            for j in 0..<input.count {
                output[i] += weights[offSet+j] * input[j]
            }
            
            output[i] = ActivationFunction.sigmoid(x: output[i])
            offSet += input.count
            
        }
        
        return output
    }
}
