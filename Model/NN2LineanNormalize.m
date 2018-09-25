//
//  NN2LineanNormalize.m
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import "NN2LineanNormalize.h"

@implementation NN2LineanNormalize

static NN2LineanNormalize* _instance = nil;

@synthesize normalizeMethod;

+ (NN2LineanNormalize*) instance {
	@synchronized([NN2LineanNormalize class])
	{
		if (!_instance)
			[[self alloc] init];
		
		return _instance;
	}
	
	return nil;
}

+ (id) alloc
{
	@synchronized([NN2LineanNormalize class])
	{
		NSAssert(_instance == nil, @"Attempted to allocate a second instance of a singleton.");
		_instance = [super alloc];
		return _instance;
	}
	
	return nil;
}

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
