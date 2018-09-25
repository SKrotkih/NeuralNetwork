//
//  NN2NeuralNetwork.m
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import "NN2NeuralNetwork.h"
#import "NN2DataSource.h"

@implementation NN2NeuralNetwork

@synthesize dataSrc;

// activation function
- (float) sigmoid: (float) weighted_sum {
	return 1 / (1 + exp( -[dataSrc Alpha] * weighted_sum ));
}	// sigmoid

// Main procedure of the Neural network algorithm.
- (void) compute {
	for (int layer = 0; layer <= [dataSrc LC] - 2; layer++){
		int layerEntersNumber = [[dataSrc Config: layer] intValue] - 1;
		int neuronsNumber = [[dataSrc Config: layer + 1] intValue] - 1;
		for (int neuron = 0; neuron <= neuronsNumber; neuron++){
			float weighted_sum = 0;
			for (int n = 0; n <= layerEntersNumber; n++){
				float g = [[dataSrc LayerOutput: layer c: n] floatValue];
				float w = [[dataSrc W: layer index2: n index3: neuron] floatValue];
				weighted_sum  = weighted_sum + w * g;
			}
	
			// adding offset point
			weighted_sum = weighted_sum + [[dataSrc WT: layer index2: neuron] floatValue];
			float sigma = [self sigmoid: weighted_sum];
			[dataSrc setLayerOutput: sigma r: layer + 1 c: neuron];
		}
	}

	return; 	
}

@end
