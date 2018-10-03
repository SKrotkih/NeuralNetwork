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
@class NeuralNetwork;

@interface NN2MainViewModel: NSObject

@property(nonatomic, readwrite, weak) NSObject<NN2MainViewProtocol>* view;

- (void) configure;

@end
