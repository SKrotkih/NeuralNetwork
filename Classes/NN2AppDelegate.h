//
//  NN2AppDelegate.h
//  NN2
//
//  Created by Sergey Krotkih.
//  Copyright SK 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NN2ViewController;

@interface NN2AppDelegate: NSObject <UIApplicationDelegate> {
    UIWindow *window;
    NN2ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NN2ViewController *viewController;

@end

