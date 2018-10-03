//
//  NN2NeuralNetwork.m
//  NeuralNetwork
//

#import "NN2NeuralNetwork.h"
#import "NN2DataSource.h"

@implementation NN2NeuralNetwork

@synthesize dataSrc;

// Main procedure of the Neural network algorithm.
- (void) compute {
	for (int layer = 0; layer <= [dataSrc LC] - 2; layer++){
		int layerEntersNumber = [[dataSrc Config: layer] intValue] - 1;
		int neuronsNumber = [[dataSrc Config: layer + 1] intValue] - 1;
		for (int neuron = 0; neuron <= neuronsNumber; neuron++){
			float weightedSum = 0;
			for (int n = 0; n <= layerEntersNumber; n++){
				float g = [[dataSrc LayerOutput: layer column: n] floatValue];
				float w = [[dataSrc W: layer index2: n index3: neuron] floatValue];
				weightedSum  = weightedSum + w * g;
			}
	
			// adding offset point
			weightedSum = weightedSum + [[dataSrc WT: layer index2: neuron] floatValue];
			float sigma = [self sigmoid: weightedSum];
			[dataSrc setLayerOutput: sigma
                                row: layer + 1
                             column: neuron];
		}
	}

	return; 	
}

// activation function
- (float) sigmoid: (float) weightedSum {
    return 1 / (1 + exp( -[dataSrc Alpha] * weightedSum ));
}    // sigmoid

@end
