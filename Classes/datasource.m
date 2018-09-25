//
//  datasource.m
//  NN2
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import "datasource.h"

@implementation DataSource

@synthesize normalizeObject;
@synthesize LC=fLC;
@synthesize Alpha=fAlpha;

static DataSource * _instance = nil;

+ (DataSource*) instance {
	@synchronized([DataSource class])
	{
		if (!_instance)
			[[self alloc] init];
		
		return _instance;
	}
	
	return nil;
}

+ (id) alloc
{
	@synchronized([DataSource class])
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
	}
	
	return self;
} // init

- (id) initData {
	fW = [NSArray arrayWithObjects: [NSNumber numberWithFloat: 1.88436421955477],
		  [NSNumber numberWithFloat: 1.09436537111843],
		  [NSNumber numberWithFloat: 2.2901761847617],
		  [NSNumber numberWithFloat: 1.70436421955478],
		  [NSNumber numberWithFloat: 0.574365371118406],
		  [NSNumber numberWithFloat: 2.23017618476171],
		  [NSNumber numberWithFloat: 4.25597733015697],
		  [NSNumber numberWithFloat: 3.11238189250291],
		  [NSNumber numberWithFloat: 3.91917004197399],
		  nil];
		
	fWT = [NSArray arrayWithObjects: [NSNumber numberWithFloat: -3.59276885024955],
		   [NSNumber numberWithFloat: -1.04124724491013],
		   [NSNumber numberWithFloat: 3.82886355094158],
		   [NSNumber numberWithFloat: -4.77655231133209],
		   nil];
		
	fConfig = [NSArray arrayWithObjects: [NSNumber numberWithFloat: 2],
			   [NSNumber numberWithFloat: 3],
			   [NSNumber numberWithFloat: 1],
			   nil];
		
	fLayerOutput =  [NSMutableArray arrayWithObjects: [NSNumber numberWithFloat: -0.8],
					 [NSNumber numberWithFloat: -0.6],
					 [NSNumber numberWithFloat: 0.00218734129189037],
					 [NSNumber numberWithFloat: 0.0943741744669016],
					 [NSNumber numberWithFloat: 0.658949624082696],
					 nil];
		
	fLC = 3;
	fAlpha = 1;
		
	return self;
} // init

- (NSNumber*) W: (int)index1: (int) index2: (int) index3 {
	int ind = 0;
	if (1 == index1) {
		ind = index1 * 6 + index2;
	}
	else if (0 == (index1 + index2)){
		ind = index3;
	}
	else {
		ind = index2 * 3 +index3;
	}
	NSAssert(ind < [fW count], @"fW: Index is out of range");
	NSNumber *itemdata = [fW objectAtIndex:ind];	
    return (itemdata);
}	// fWAtIndex

- (NSNumber*) WT: (int) index1: (int) index2 {
	int index = index1 * 3 + index2;
	NSNumber *itemdata = [fWT objectAtIndex: index];	
	return (itemdata);
}	// fWTAtIndex

- (NSNumber *) Config: (int)index{
	NSNumber *itemdata = [fConfig objectAtIndex: index];	
    return (itemdata);
}	// fConfigAtIndex

- (NSNumber *) LayerOutput: (int) index1: (int) index2 {
	int index = index1 * 2 + index2;
	NSAssert(index < [fLayerOutput count], @"fLayerOutput: Index is out of range");
	NSNumber *itemdata = [fLayerOutput objectAtIndex: index];	
    return (itemdata);
}	// fLayerOutputAtIndex


- (void) setLayerOutput: (float) itemdata: (int) index1: (int) index2 {
	int index = index1 * 2 + index2;
	NSAssert(index < [fLayerOutput count], @"fLayerOutput: Index is out of range");
	NSNumber *d= [NSNumber numberWithFloat:itemdata];
    [fLayerOutput replaceObjectAtIndex: index
					withObject: d];
	
} // setOutputData:atIndex:

- (void) normalize_input: (NSArray*) inputdata {
	int i;
	NSAssert(2 == [inputdata count], @"This neural network works with 2 args only!");
	for (i = 0; i < [inputdata count]; i++) {
		NSNumber *d = [inputdata objectAtIndex: i];
		//id dn =[normalizeObject performSelector:[normalizeObject normalizeMethod] withObject: d];
		id dd = [normalizeObject normalize:d];
		[self setLayerOutput:[dd floatValue]:0:i];
	}
}	// normalizeData

- (void) denormalize_output {
	int r = fLC - 1;
	int c = 0;
	NSNumber *d = [self LayerOutput:r:c];
	float dd = [[normalizeObject denormalize: d] floatValue];
	[self setLayerOutput: dd: r: c];
}	// denormalizeData

- (id) output {
	int r = fLC - 1;
	int c = 0;
	NSNumber *d = [self LayerOutput: r: c];
	return d;
}	// output

@end
