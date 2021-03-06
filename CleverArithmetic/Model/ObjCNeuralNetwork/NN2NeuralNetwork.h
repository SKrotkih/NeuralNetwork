//
//  NN2NeuralNetwork.h
//  CleverArithmetic

#import <Foundation/Foundation.h>

@interface NN2NeuralNetwork: NSObject {
    id datasrc;
}
@property (assign) id dataSrc;

// Compute Neural network
- (void) compute;

- (float) sigmoid: (float) weightedSum;

@end

