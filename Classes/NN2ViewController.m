//
//  NN2ViewController.m
//  NN2
//
//  Created by Sergey Krotkih.
//  Copyright SK 2010. All rights reserved.
//

#import "NN2ViewController.h"
#import "lineanNormalize.h"
#import "NeuralNetwork.h"
#import "NN2Helpers.h"

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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[resultTextField release];
	[s1 release];
	[s2 release];	
	[super dealloc];
}

//---implementation for the btnCalculate: action--- 
- (IBAction) btnCalculate: (id) sender {

	// Define data source agregation object for neural network object 
	// call method of singleton xlass 	
	[NeuralNetwork instance].datasrc = [DataSource instance]; 

	// Linear algorithm for Normalize data on (object for data source object)
	[DataSource instance].normalizeObject = [LineanNormalize instance]; 
	// for example 
	//[DataSource instance].normalizeMethod=[[LineanNormalize instance] normalizeMethod];	
	
	float ds1 = [s1.text floatValue];
	float ds2 = [s2.text floatValue];	
	if ((ds1 < 1)||(ds1 > 10)||(ds2 < 1)||(ds2 > 10)) {
		//---display an alert view---
        [NN2Helpers alert: @"Warning!" message: @"s1 and s2 must be in (1..10) range!" sender: self];
		return;
	}
	
	NSArray *input = [NSArray arrayWithObjects: [NSNumber numberWithFloat:ds1],
			[NSNumber numberWithFloat:ds2],
			nil];

	[[DataSource instance] initData];

	[[DataSource instance] normalize_input:input];
	
	// Compute Neural network
	[[NeuralNetwork instance] Compute];

	[[DataSource instance] denormalize_output];
	
	float output = [[[DataSource instance] output] floatValue];
	
	resultTextField.text=[NSString stringWithFormat: @"%f", output];
}

@end
