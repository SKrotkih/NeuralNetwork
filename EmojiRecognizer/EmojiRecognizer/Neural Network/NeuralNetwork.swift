import Foundation

public class NeuralNetwork {
    private var layers: [Layer] = []
    
    public init(inputSize: Int, hiddenSize: Int, outputSize: Int) {
        let ioLayer = Layer(inputSize: inputSize, outputSize: hiddenSize)
        let hoLayer = Layer(inputSize: hiddenSize, outputSize: outputSize)
        self.layers.append(ioLayer)
        self.layers.append(hoLayer)
    }
    
    public func train(input: [Float], targetOutput: [Float], learningRate: Float, momentum: Float) {
        let calculatedOutput = run(input: input)
        var error = zip(targetOutput, calculatedOutput).map { $0 - $1 }
        for i in (0...layers.count - 1).reversed() {
            error = layers[i].train(error: error)
        }
    }

    public func run(input: [Float]) -> [Float] {
        var activations = input
        layers.forEach { layer in
            activations = layer.run(inputArray: activations)
        }
        return activations
    }
}
