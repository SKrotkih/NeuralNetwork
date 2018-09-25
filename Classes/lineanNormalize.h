//
//  lineanNormalize.h
//  NN2
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Normalize.h"

@interface LineanNormalize: NSObject <Normalize> {
@private
	float min;
	float max;
	float max_res;
@public
	SEL normalizeMethod;	
}
// singleton
+ (LineanNormalize*) instance;

- (id) normalize: (id) data;

- (id) denormalize: (id) data;

- (SEL) normalizeMethod;

- (SEL) denormalizeMethod;

@property (readonly) SEL normalizeMethod;

@end
