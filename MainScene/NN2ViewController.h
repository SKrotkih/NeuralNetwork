//
//  NN2ViewController.h
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright SK 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NN2ViewController: UIViewController {
	IBOutlet UITextField* resultTextField;
	IBOutlet UITextField* s1;
	IBOutlet UITextField* s2;
}

- (IBAction) btnCalculate: (id) sender;

@property (nonatomic,retain) IBOutlet UITextField* resultTextField;
@property (nonatomic,retain) IBOutlet UITextField* s1;
@property (nonatomic,retain) IBOutlet UITextField* s2;

@end

