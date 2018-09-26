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
@property (assign) id dataSrc;

// Compute Neural network
- (void) compute;

- (float) sigmoid: (float) weightedSum;

@end

