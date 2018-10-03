//
//  NN2LineanNormalize.m
//  NeuralNetwork
//

#import "NN2LineanNormalize.h"

@implementation NN2LineanNormalize

@synthesize normalizeMethod;

- (id) init {
	self = [super init];
	if (self != nil) {
		min = 0;
		max = 10;
		max_res = 20;
	}
	
	return self;
}

- (id) denormalize: (id) data {
	if (strcmp([data objCType], @encode(float)) == 0) {
		@synchronized([NN2LineanNormalize class])
		{
			float val = [data floatValue];
			val = val * (max_res - min) + min;
			NSNumber *res = [NSNumber numberWithFloat:val];
			return res;
		}
	}
	
	return nil;
}

- (id) normalize: (id) data {
	// this is an algorithm of linear normalize data 
	if (strcmp([data objCType], @encode(float)) == 0) {
		@synchronized([NN2LineanNormalize class])
		{
			float val = [data floatValue];
			val = (val - min)/(max - min);
			val = val * 2 - 1;
			NSNumber *res = [NSNumber numberWithFloat:val];
			return res;
		}
	}
	return nil;
}


- (SEL) normalizeMethod {
	return @selector(normalize:);
}

- (SEL) denormalizeMethod{
	return @selector(denormalize:);
}

@end
