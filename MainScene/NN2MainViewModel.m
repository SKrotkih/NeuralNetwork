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

@implementation NN2MainViewModel

@synthesize view;
@synthesize viewController;

- (void) configure {
    [self bindButton];
}

- (void) bindButton {
    [self.viewController addObserver: self
                          forKeyPath: kObservableKeyPath
                             options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                             context: nil];
}

- (void) observeValueForKeyPath: (NSString*) keyPath
                       ofObject: (id) object
                         change: (NSDictionary*) change
                        context: (void *)context {
    
    if ([keyPath isEqualToString: kObservableKeyPath]) {
        [self doComputeNeuralNetwork];
    }
}

- (void) doComputeNeuralNetwork {
    NSArray* input = [self inputData];
    if (input == nil) {
        return;
    }
    
    NN2DataSource* dataSource = [NN2DataSource instance];
    
    // Define data source agregation object for neural network object
    // call method of singleton xlass
    [NN2NeuralNetwork instance].datasrc = dataSource;
    
    // Linear algorithm for Normalize data on (object for data source object)
    dataSource.normalizeObject = [NN2LineanNormalize instance];
    // for example
    //dataSource.normalizeMethod = [[NN2LineanNormalize instance] normalizeMethod];
    
    [dataSource initData];
    
    [dataSource normalize_input: input];
    
    // Compute Neural network
    [[NN2NeuralNetwork instance] compute];
    
    [dataSource denormalize_output];
    
    float output = [[dataSource output] floatValue];
    
    [self.view presentResult: output];
}

- (NSArray*) inputData {
    float ds1 = [self.view.operand1 floatValue];
    float ds2 = [self.view.operand2 floatValue];
    if ((ds1 < 1) || (ds1 > 10) || (ds2 < 1) || (ds2 > 10)) {
        [self.view showError];
        return nil;
    }
    NSNumber* op1 = [NSNumber numberWithFloat: ds1];
    NSNumber* op2 = [NSNumber numberWithFloat: ds2];
    NSArray* input = [NSArray arrayWithObjects: op1, op2, nil];
    return input;
}

@end
