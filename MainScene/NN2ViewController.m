//
//  NN2ViewController.m
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright SK 2010. All rights reserved.
//

#import "NN2ViewController.h"
#import "NN2LineanNormalize.h"
#import "NN2NeuralNetwork.h"
#import "NN2Helpers.h"
#import "NN2DataSource.h"

@implementation NN2ViewController

@synthesize resultTextField;
@synthesize s1;
@synthesize s2;

- (void) touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
    [resultTextField resignFirstResponder];
    [s1 resignFirstResponder];
    [s2 resignFirstResponder];
    [super touchesBegan: touches
              withEvent: event];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
    // Return YES for supported orientations
    return (YES);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc {
    [resultTextField release];
    [s1 release];
    [s2 release];
    [super dealloc];
}

//---implementation for the btnCalculate: action---
- (IBAction) btnCalculate: (id) sender {
    [self doComputeNeuralNetwork];
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
    
    [self presentResult: output];
}

- (NSArray*) inputData {
    float ds1 = [s1.text floatValue];
    float ds2 = [s2.text floatValue];
    if ((ds1 < 1) || (ds1 > 10) || (ds2 < 1) || (ds2 > 10)) {
        [self showError];
        return nil;
    }
    
    NSNumber* op1 = [NSNumber numberWithFloat: ds1];
    NSNumber* op2 = [NSNumber numberWithFloat: ds2];
    NSArray* input = [NSArray arrayWithObjects: op1, op2, nil];
    return input;
}

- (void) presentResult: (float) result {
    resultTextField.text = [NSString stringWithFormat: @"%f", result];
}

- (void) showError {
    //---display an alert view---
    [NN2Helpers alert: @"Warning!" message: @"s1 and s2 must be in (1..10) range!" sender: self];
}

@end
