//
//  datasource.h
//  NN2
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Normalize.h"

@interface DataSource : NSObject {
	id<Normalize> normalizeObject;
	// selectors 
	//SEL normalizeMethod;	
    //SEL denormalizeMethod;		
	
	NSArray* fW;					//array of coefficients [][][]
	NSArray* fWT;					//array of offsets starting point [][]
	NSArray* fConfig;				//array of layers configuration []
	NSMutableArray* fLayerOutput;	//array of exits layers fLayerOutput[0]-enter []
	int fLC;
	float fAlpha;
}

// singleton
+ (DataSource*) instance;

//@property SEL normalizeMethod;
//@property SEL denormalizeMethod;
@property (assign) id normalizeObject;
@property (assign) int LC;
@property (assign) float Alpha;

- (id) initData;

- (void) normalize_input: (NSArray*) array;

- (void) denormalize_output;

- (NSNumber*) W: (int) index1: (int) index2: (int) index3;

- (NSNumber*) WT: (int) index1: (int) index2;

- (NSNumber*) Config: (int) index;

- (NSNumber*) LayerOutput: (int) index1: (int) index2;

- (void) setLayerOutput: (float) itemdata: (int) index1: (int) index2;

- (id) output;

@end
