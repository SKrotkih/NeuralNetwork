//
//  NN2MainViewController.m
//  CleverArithmetic
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
    
    [self configureViewModel];
    [self configureView];
}

- (void) configureViewModel {
    self.viewModel = [[NN2MainViewModel alloc] init];
    self.viewModel.view = self;
    [self.viewModel configure];
}

- (void) configureView {
    self.titleLabel.text = NSLocalizedString(@"Simple calculator with Neural network", @"Simple calculator with Neural network");
    [self.computeButton setTitle: NSLocalizedString(@"Compute", @"Compute") forState: UIControlStateNormal];
}

- (void) dealloc {
    [resultTextField release];
    [s1 release];
    [s2 release];
    [_titleLabel release];
    [_computeButton release];
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

- (void) outputResult: (float) result {
    resultTextField.text = [NSString stringWithFormat: @"%f", result];
}

- (void) outputError {
    //---display an alert view---
    [NN2Helpers alert: NSLocalizedString(@"Warning!", "Warning!")
              message: NSLocalizedString(@"s1 and s2 must be in (1..10) range!", @"s1 and s2 must be in (1..10) range!")
               sender: self];
}

@end
