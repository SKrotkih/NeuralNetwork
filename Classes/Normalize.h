//
//  Normalize.h
//  NN2
//
//  Created by Sergey Krotkih.
//  Copyright 2010 SK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Normalize

- (id) normalize: (id) data;

- (id) denormalize: (id) data;

- (SEL) normalizeMethod;

- (SEL) denormalizeMethod;

@end
