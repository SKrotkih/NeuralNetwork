//
//  NN2AppDelegate.m
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright SK 2010. All rights reserved.
//

#import "NN2AppDelegate.h"
#import "NN2ViewController.h"

@implementation NN2AppDelegate

@synthesize window;

- (BOOL) application: (UIApplication*) application didFinishLaunchingWithOptions: (NSDictionary*) launchOptions {
	return YES;
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
