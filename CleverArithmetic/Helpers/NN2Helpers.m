//
//  NN2Helpers.m
//  QuickNotes
//

#import "NN2Helpers.h"

@implementation NN2Helpers

+ (void) alert: (NSString*) title message: (NSString*) message sender: (UIViewController*) viewController
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: title
                                                                   message: message
                                                            preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle: @"OK"
                                                            style: UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction * action) {}];
    
    [alert addAction: defaultAction];
    [viewController presentViewController: alert
                                 animated: YES
                               completion: nil];
}

@end

