//
//  NN2MainViewModel.m
//  NeuralNetwork
//
//  Created by Сергей Кротких on 25/09/2018.
//  Copyright © 2018 SK. All rights reserved.
//

#import "NN2MainViewModel.h"
#import "NN2LineanNormalize.h"
#import "NN2NeuralNetwork.h"
#import "NN2DataSource.h"

NSString* kObservableKeyPath = @"onButtonPressedObservable";

@implementation NN2MainViewModel {
    NN2DataSource* mDataSource;
    NN2NeuralNetwork* mNeuralNetwork;
    NN2LineanNormalize* mNormalizeObject;
}

@synthesize view;

- (id) init {
    self = [super init];
    if (self != nil) {
        mDataSource = [[NN2DataSource alloc] init];
        mNeuralNetwork = [[NN2NeuralNetwork alloc] init];
        mNormalizeObject = [[NN2LineanNormalize alloc] init];
    }
    
    return self;
} // init

- (void) dealloc {
    [self.view removeObserver: self
                   forKeyPath: kObservableKeyPath];
    [super dealloc];
}

- (void) configure {
    [self bindButton];
}

- (void) bindButton {
    [self.view addObserver: self
                forKeyPath: kObservableKeyPath
                   options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                   context: nil];
}

- (void) observeValueForKeyPath: (NSString*) keyPath
                       ofObject: (id) object
                         change: (NSDictionary*) change
                        context: (void *)context {
    if ([keyPath isEqualToString: kObservableKeyPath] && [change[@"kind"] isEqualToNumber: [NSNumber numberWithInt: 1]] && [change[@"new"] isEqualToNumber: [NSNumber numberWithInt: 1]]) {
        [self doComputeNeuralNetwork];
    }
}

- (void) doComputeNeuralNetwork {
    NSArray* input = [self inputData];
    if (input == nil) {
        return;
    }
    
    // Define data source agregation object for neural network object
    // call method of singleton xlass
    mNeuralNetwork.dataSrc = mDataSource;
    
    // Linear algorithm for Normalize data on (object for data source object)
    mDataSource.normalizeObject = mNormalizeObject;
    // for example
    //dataSource.normalizeMethod = [normalizeObject normalizeMethod];
    
    [mDataSource initData];
    
    [mDataSource normalizeInput: input];
    
    // Compute Neural network
    [mNeuralNetwork compute];
    
    [mDataSource denormalizeOutput];
    
    float output = [[mDataSource output] floatValue];
    
    [self.view outputResult: output];
}

- (NSArray*) inputData {
    float ds1 = [self.view.operand1 floatValue];
    float ds2 = [self.view.operand2 floatValue];
    if ((ds1 < 1) || (ds1 > 10) || (ds2 < 1) || (ds2 > 10)) {
        [self.view outputError];
        return nil;
    }
    NSNumber* op1 = [NSNumber numberWithFloat: ds1];
    NSNumber* op2 = [NSNumber numberWithFloat: ds2];
    NSArray* input = [NSArray arrayWithObjects: op1, op2, nil];
    return input;
}

@end
