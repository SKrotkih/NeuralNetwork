//
//  NN2MainViewController.h
//  NeuralNetwork
//
//  Created by Sergey Krotkih.
//  Copyright SK 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NN2MainViewProtocol.h"
#import "NN2MainViewModel.h"

@interface NN2MainViewController: UIViewController <NN2MainViewProtocol> {
	IBOutlet UITextField* resultTextField;
	IBOutlet UITextField* s1;
	IBOutlet UITextField* s2;
}

- (IBAction) btnCalculate: (id) sender;

@property (nonatomic, retain) IBOutlet UITextField* resultTextField;
@property (nonatomic, retain) IBOutlet UITextField* s1;
@property (nonatomic, retain) IBOutlet UITextField* s2;

@property (nonatomic, strong) NN2MainViewModel* viewModel;
@property (nonatomic, readonly) NSString* operand1;
@property (nonatomic, readonly) NSString* operand2;
@property (nonatomic, assign) Boolean onButtonPressedObservable;

@end

