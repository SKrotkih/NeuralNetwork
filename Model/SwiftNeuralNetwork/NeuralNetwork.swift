import Foundation

@objc
public class NeuralNetwork: NSObject {
    
    private var inputSize: Int = 0
    private var hiddenSize: Int = 0
    private var outputSize: Int = 0
    
    private lazy var layers: [Layer] = {
        var layers: [Layer] = []
        layers.append(Layer(inputSize: inputSize, outputSize: hiddenSize))
        layers.append(Layer(inputSize: hiddenSize, outputSize: outputSize))
        return layers
    }()
    
    fileprivate lazy var settings: Settings = {
        var settings = Settings()
        settings.configure()
        return settings
    }()

    /// Iterations count
    fileprivate lazy var iterations: Int = {
        return settings.iterations
    }()
    
    public required init(inputSize: Int, hiddenSize: Int, outputSize: Int) {
        self.inputSize = inputSize
        self.hiddenSize = hiddenSize
        self.outputSize = outputSize
    }
}

// MARK: -

extension NeuralNetwork {
    
    public func train(input: [Float], targetOutput: [Float]) {
        let calculatedOutput = run(input: input)
        var error = zip(targetOutput, calculatedOutput).map { $0 - $1 }
        layers.reversed().forEach { layer in
            error = layer.train(error: error)
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
