//
//  NN2AppDelegate.m
//  NN2
//
//  Created by Sergey Krotkih.
//  Copyright SK 2010. All rights reserved.
//

#import "NN2AppDelegate.h"
#import "NN2ViewController.h"

@implementation NN2AppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL) application: (UIApplication*)application didFinishLaunchingWithOptions: (NSDictionary*)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview: viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
