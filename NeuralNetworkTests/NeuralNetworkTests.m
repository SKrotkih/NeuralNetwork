//
//  NeuralNetworkTests.m
//  NeuralNetworkTests
//
//  Created by Сергей Кротких on 26/09/2018.
//  Copyright © 2018 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NN2LineanNormalize.h"
#import "NN2NeuralNetwork.h"
#import "NN2DataSource.h"

@interface NeuralNetworkTests : XCTestCase

@end

@implementation NeuralNetworkTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testResultSummarize {
    for (float op1 = 1.0; op1 < 9.0; op1 += 1.0) {
        for (float op2 = 1.0; op2 < 10.0; op2 += 1.0) {
            [self compute: op1 with: op2];
        }
    }
}

- (void) compute: (float) s1 with: (float) s2 {
    NN2DataSource* mDataSource = [[NN2DataSource alloc] init];
    NN2NeuralNetwork* mNeuralNetwork = [[NN2NeuralNetwork alloc] init];
    NN2LineanNormalize* mNormalizeObject = [[NN2LineanNormalize alloc] init];
    NSNumber* op1 = [NSNumber numberWithFloat: s1];
    NSNumber* op2 = [NSNumber numberWithFloat: s2];
    NSArray* input = [NSArray arrayWithObjects: op1, op2, nil];
    
    mNeuralNetwork.dataSrc = mDataSource;
    mDataSource.normalizeObject = mNormalizeObject;
    if ([mDataSource initData] != nil) {
        [mDataSource normalizeInput: input];
        [mNeuralNetwork compute];
        [mDataSource denormalizeOutput];
        float output = [[mDataSource output] floatValue];
        
        NSLog(@"[%.3f:%.3f]: Computed result is '%.3f'. Expected result is '%.3f'", s1, s2, roundf(output), s1 + s2);
        
        XCTAssertEqual(roundf(output), s1 + s2, @"Total result is not expected!");
        
    } else {
        XCTAssert(false, @"Failed data source initialized");
    }
}

@end
