//
//  NN2AppDelegate.m
//  CleverArithmetic
//

#import "NN2AppDelegate.h"
#import "NN2MainViewController.h"

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
