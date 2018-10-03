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
#import "NeuralNetwork-Swift.h"

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
        [self doCompute];
    }
}

- (void) doCompute2 {
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

- (void) doCompute {
    NSArray* terms = [self inputData];
    if (terms == nil) {
        return;
    }

    NeuralNetwork* neuralNetwork = [[NeuralNetwork alloc] init];
    [neuralNetwork configureWithInputSize: 2 hiddenSize: 18 outputSize: 18];
    
    for (int i = 1; i < 10; i++) {
        for (int j = i; j < 10; j++) {
            NSNumber* op1 = [NSNumber numberWithFloat: (float)i];
            NSNumber* op2 = [NSNumber numberWithFloat: (float)j];
            NSNumber* nop1 = [mNormalizeObject normalize: op1];
            NSNumber* nop2 = [mNormalizeObject normalize: op2];
            NSArray* input = @[nop1, nop2];
            NSMutableArray* targets = [@[@0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0,@0.0, @0.0, @0.0] mutableCopy];
            NSNumber* target = [NSNumber numberWithFloat: (float)i + j];
            targets[i + j] = [mNormalizeObject normalize: target];
            [neuralNetwork trainWithInput: input targetOutput: targets];
        }
    }
    
    NSArray* summa = [neuralNetwork runWithInput: terms];
    NSLog(@"Summa=%@", summa);
    
    float result = 0.0;
    int index = 0;
    for (int i = 0; i < [summa count]; i++) {
        if ([summa[i] floatValue] > result) {
            result = [summa[i] floatValue];
            index = i;
        }
    }
    [self.view outputResult: (float)index];
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
