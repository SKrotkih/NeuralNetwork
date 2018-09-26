//
//  Datasource.m
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import "NN2DataSource.h"

@implementation NN2DataSource

@synthesize normalizeObject;
@synthesize LC = fLC;
@synthesize Alpha = fAlpha;

- (id) init {
	self = [super init];
	if (self != nil) {
	}
	
	return self;
} // init

- (id) initData {
    NSString* plistpath = [[NSBundle mainBundle] pathForResource: @"model" ofType: @"plist"];
    NSDictionary* data = [NSDictionary dictionaryWithContentsOfFile: plistpath];
    NSArray* fWData = [data objectForKey: @"fW"];
    NSArray* fWTData = [data objectForKey: @"fWT"];
    NSArray* fConfigData = [data objectForKey: @"fConfig"];
    NSArray* fLayerOutputData = [data objectForKey: @"fLayerOutput"];
    
    NSLog(@"Data source\nfw=%@;\nfWT=%@\nfConfig=%@\nfLayerOutput=%@", fWData.description, fWTData.description, fConfigData.description, fLayerOutputData.description);
    
    fW = [NSMutableArray arrayWithCapacity: [fWData count]];
    for (int index = 0; index < [fWData count]; index++) {
        [fW addObject: [NSNumber numberWithFloat: [[fWData objectAtIndex: index] floatValue]]];
    }
    
    fWT = [NSMutableArray arrayWithCapacity: [fWTData count]];
    for (int index = 0; index < [fWTData count]; index++) {
        [fWT addObject: [NSNumber numberWithFloat: [[fWTData objectAtIndex: index] floatValue]]];
    }

    fConfig = [NSMutableArray arrayWithCapacity: [fConfigData count]];
    for (int index = 0; index < [fConfigData count]; index++) {
        [fConfig addObject: [NSNumber numberWithFloat: [[fConfigData objectAtIndex: index] floatValue]]];
    }

    fLayerOutput = [NSMutableArray arrayWithCapacity: [fLayerOutputData count]];
    for (int index = 0; index < [fLayerOutputData count]; index++) {
        [fLayerOutput addObject: [NSNumber numberWithFloat: [[fLayerOutputData objectAtIndex: index] floatValue]]];
    }
		
	fLC = [[data objectForKey: @"fLC"] intValue];
	fAlpha = [[data objectForKey: @"fAlpha"] floatValue];
		
	return self;
} // init

- (NSNumber*) W: (int) index1 index2: (int) index2 index3: (int) index3 {
	int ind = 0;
	if (1 == index1) {
		ind = index1 * 6 + index2;
	} else if (0 == (index1 + index2)){
		ind = index3;
	} else {
		ind = index2 * 3 + index3;
	}
	NSAssert(ind < [fW count], @"fW: Index is out of range");
	NSNumber* itemdata = [fW objectAtIndex: ind];
    return (itemdata);
}	// fWAtIndex

- (NSNumber*) WT: (int) index1 index2: (int) index2 {
	int index = index1 * 3 + index2;
	NSNumber* itemdata = [fWT objectAtIndex: index];
	return (itemdata);
}	// fWTAtIndex

- (NSNumber*) Config: (int) index {
	NSNumber* itemdata = [fConfig objectAtIndex: index];
    return (itemdata);
}	// fConfigAtIndex

- (NSNumber*) LayerOutput: (int) row column: (int) column {
	int index = row * 2 + column;
	NSAssert(index < [fLayerOutput count], @"fLayerOutput: Index is out of range");
	NSNumber* itemdata = [fLayerOutput objectAtIndex: index];
    return (itemdata);
}	// fLayerOutputAtIndex


- (void) setLayerOutput: (float) itemdata row: (int) row column: (int) column {
	int index = row * 2 + column;
	NSAssert(index < [fLayerOutput count], @"fLayerOutput: Index is out of range");
	NSNumber* d= [NSNumber numberWithFloat: itemdata];
    [fLayerOutput replaceObjectAtIndex: index
					withObject: d];
	
} // setOutputData:atIndex:

- (void) normalizeInput: (NSArray*) inputdata {
	int i;
	NSAssert(2 == [inputdata count], @"This neural network works with 2 args only!");
	for (i = 0; i < [inputdata count]; i++) {
		NSNumber* d = [inputdata objectAtIndex: i];
		//id dn =[normalizeObject performSelector:[normalizeObject normalizeMethod] withObject: d];
		id dd = [normalizeObject normalize: d];
		[self setLayerOutput: [dd floatValue] row: 0 column: i];
	}
}	// normalizeData

- (void) denormalizeOutput {
	int row = fLC - 1;
	int column = 0;
	NSNumber* d = [self LayerOutput: row column: column];
	float dd = [[normalizeObject denormalize: d] floatValue];
	[self setLayerOutput: dd row: row column: column];
}	// denormalizeData

- (id) output {
	int r = fLC - 1;
	int c = 0;
	NSNumber* d = [self LayerOutput: r column: c];
	return d;
}	// output

@end
