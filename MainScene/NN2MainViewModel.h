//
//  NN2MainViewModel.h
//  NeuralNetwork
//
//  Created by Сергей Кротких on 25/09/2018.
//  Copyright © 2018 SK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NN2MainViewProtocol.h"

@class NN2MainViewController;

@interface NN2MainViewModel: NSObject

@property(nonatomic, readwrite, weak) id<NN2MainViewProtocol> view;
@property(nonatomic, readwrite, weak) NN2MainViewController* viewController;

- (void) configure;

@end