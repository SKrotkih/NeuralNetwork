//
//  NN2MainViewProtocol.h
//  NeuralNetwork
//
//  Created by Сергей Кротких on 25/09/2018.
//  Copyright © 2018 SK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NN2MainViewProtocol

- (void) presentResult: (float) result;

- (void) showError;

@property (nonatomic, readonly) NSString* operand1;

@property (nonatomic, readonly) NSString* operand2;

@property (nonatomic, assign) Boolean onButtonPressedObservable;

@end
