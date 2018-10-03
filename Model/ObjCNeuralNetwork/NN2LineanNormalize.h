//
//  NN2LineanNormalize.h
//  NeuralNetwork
//

#import <Foundation/Foundation.h>
#import "NN2Normalizible.h"

@interface NN2LineanNormalize: NSObject <NN2Normalizible> {
@private
	float min;
	float max;
	float max_res;
@public
	SEL normalizeMethod;	
}

- (id) normalize: (id) data;

- (id) denormalize: (id) data;

- (SEL) normalizeMethod;

- (SEL) denormalizeMethod;

@property (readonly) SEL normalizeMethod;

@end
