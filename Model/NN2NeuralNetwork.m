//
//  NN2NeuralNetwork.m
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import "NN2NeuralNetwork.h"
#import "NN2DataSource.h"
#import "NN2LineanNormalize.h"

@implementation NN2NeuralNetwork

static NN2NeuralNetwork* _instance = nil;

@synthesize datasrc;

// implementation of NeuralNetwork singleton 
+ (NN2NeuralNetwork*) instance
{
	@synchronized([NN2NeuralNetwork class])
	{
		if (!_instance)
			[[self alloc] init];
		
		return _instance;
	}
	
	return nil;
}	// instant

+ (id) alloc
{
	@synchronized([NN2NeuralNetwork class])
	{
		NSAssert(_instance == nil, @"Attempted to allocate a second instance of a singleton.");
		_instance = [super alloc];
		return _instance;
	}
	
	return nil;
}	// alloc

// activation function
- (float) sigmoid: (float) weighted_sum {
	return 1 / (1 + exp( -[datasrc Alpha] * weighted_sum ));
}	// sigmoid

// Main procedure of the Neural network algorithm.
- (void) compute {
	for (int layer = 0; layer <= [datasrc LC] - 2; layer++){
		int layerEntersNumber = [[datasrc Config:layer] intValue] - 1;
		int neuronsNumber = [[datasrc Config:layer + 1] intValue] - 1;
		for (int neuron = 0; neuron <= neuronsNumber; neuron++){
			float weighted_sum = 0;
			for (int n = 0; n <= layerEntersNumber; n++){
				float g = [[datasrc LayerOutput: layer c: n] floatValue];
				float w = [[datasrc W: layer index2: n index3: neuron] floatValue];
				weighted_sum  = weighted_sum + w * g;
			}
	
			// adding offset point
			weighted_sum = weighted_sum + [[datasrc WT: layer index2: neuron] floatValue];
			float sigma = [self sigmoid: weighted_sum];
			[datasrc setLayerOutput: sigma r: layer + 1 c: neuron];
		}
	}

	return; 	
}

@end
