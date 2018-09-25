//
//  NN2NeuralNetwork.h
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NN2NeuralNetwork: NSObject {
    id datasrc;
}
@property (assign) id datasrc;

// singleton
+ (NN2NeuralNetwork*) instance;

// Compute Neural network
- (void) compute;

- (float) sigmoid: (float) weighted_sum;

@end

