//
//  NeuralNetwork.h
//  NN2
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "datasource.h"

@interface NeuralNetwork : NSObject {
	id datasrc;
}
@property (assign) id datasrc;

// singleton
+ (NeuralNetwork*) instance;

// Compute Neural network
- (void) Compute;

- (float) sigmoid: (float) weighted_sum;

@end
