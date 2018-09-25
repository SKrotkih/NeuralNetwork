//
//  NN2MainViewController.m
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright SK 2010. All rights reserved.
//

#import "NN2MainViewController.h"
#import "NN2Helpers.h"

@implementation NN2MainViewController

@synthesize resultTextField;
@synthesize s1;
@synthesize s2;
@synthesize viewModel;
@synthesize operand1;
@synthesize operand2;
@synthesize onButtonPressedObservable;

//---implementation for the btnCalculate: action---
- (IBAction) btnCalculate: (id) sender {
    self.onButtonPressedObservable = true;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[NN2MainViewModel alloc] init];
    self.viewModel.view = self;
    self.viewModel.viewController = self; // It's necessary just for JVO impl!
    [self.viewModel configure];
}

- (void) dealloc {
    [resultTextField release];
    [s1 release];
    [s2 release];
    [super dealloc];
}

- (void) touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
    [resultTextField resignFirstResponder];
    [s1 resignFirstResponder];
    [s2 resignFirstResponder];
    [super touchesBegan: touches
              withEvent: event];
}

// MARK: - NN2MainViewProtocol implementation

- (NSString*) operand1 {
    return s1.text;
}

- (NSString*) operand2 {
    return s2.text;
}

- (void) presentResult: (float) result {
    resultTextField.text = [NSString stringWithFormat: @"%f", result];
}

- (void) showError {
    //---display an alert view---
    [NN2Helpers alert: @"Warning!" message: @"s1 and s2 must be in (1..10) range!" sender: self];
}

@end
