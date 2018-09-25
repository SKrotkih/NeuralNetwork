//
//  Datasource.h
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NN2Normalizible.h"

@interface NN2DataSource: NSObject {
	id<NN2Normalizible> normalizeObject;
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

//@property SEL normalizeMethod;
//@property SEL denormalizeMethod;
@property (assign) id normalizeObject;
@property (assign) int LC;
@property (assign) float Alpha;

- (id) initData;

- (void) normalizeInput: (NSArray*) array;

- (void) denormalizeOutput;

- (NSNumber*) W: (int) index1 index2: (int) index2 index3: (int) index3;

- (NSNumber*) WT: (int) index1 index2: (int) index2;

- (NSNumber*) Config: (int) index;

- (NSNumber*) LayerOutput: (int) r c: (int) c;

- (void) setLayerOutput: (float) itemdata r: (int) r c: (int) c;

- (id) output;

@end
