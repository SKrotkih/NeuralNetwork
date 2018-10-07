import Foundation

class Layer {
    
    private var output: [Float]
    private var input: [Float]
    private var weights: [Float]
    private var previousWeights: [Float]
    
    init(inputSize: Int, outputSize: Int) {
        self.output = [Float](repeating: 0, count: outputSize)
        self.input = [Float](repeating: 0, count: inputSize + 1)
        self.weights = (0..<(1 + inputSize) * outputSize).map { _ in
            return (Settings.minWeight...Settings.maxWeight).random()
        }
        previousWeights = [Float](repeating: 0, count: weights.count)
    }
    
    public func run(input: [Float]) -> [Float] {
        self.input = input
        self.input[self.input.count - 1] = 1
        var offSet = 0
        for i in 0..<output.count {
            for (j, inputItem) in self.input.enumerated() {
                output[i] += weights[offSet + j] * inputItem
            }
            output[i] = ActivationFunction.sigmoid(x: output[i])
            offSet += self.input.count
        }
        return output
    }
    
    public func train(error: [Float]) -> [Float] {
        var offset = 0
        var nextError = [Float](repeating: 0, count: input.count)
        for i in 0..<output.count {
            let delta = error[i] * ActivationFunction.sigmoidDerivative(x: output[i])
            for j in 0..<input.count {
                let weightIndex = offset + j
                nextError[j] = nextError[j] + weights[weightIndex] * delta
                let dw = input[j] * delta * Settings.learningRate
                weights[weightIndex] += previousWeights[weightIndex] * Settings.momentum + dw
                previousWeights[weightIndex] = dw
            }
            offset += input.count
        }
        return nextError
    }
}
