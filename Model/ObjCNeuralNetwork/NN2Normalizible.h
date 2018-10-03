//
//  NN2Normalizible.h
//  NeuralNetwork
//

#import <UIKit/UIKit.h>

@protocol NN2Normalizible

- (id) normalize: (id) data;

- (id) denormalize: (id) data;

- (SEL) normalizeMethod;

- (SEL) denormalizeMethod;

@end
