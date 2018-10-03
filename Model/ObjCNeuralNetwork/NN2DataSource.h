//
//  Datasource.h
//  NeuralNetwork
//

#import <Foundation/Foundation.h>
#import "NN2Normalizible.h"

@interface NN2DataSource: NSObject {
	id<NN2Normalizible> normalizeObject;
	// selectors 
	//SEL normalizeMethod;	
    //SEL denormalizeMethod;		
	
	NSMutableArray* fW;					//array of coefficients [][][]
	NSMutableArray* fWT;					//array of offsets starting point [][]
	NSMutableArray* fConfig;				//array of layers configuration []
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

- (NSNumber*) LayerOutput: (int) r column: (int) c;

- (void) setLayerOutput: (float) itemdata row: (int) row column: (int) column;

- (id) output;

@end
