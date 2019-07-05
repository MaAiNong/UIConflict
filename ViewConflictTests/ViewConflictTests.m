//
//  ViewConflictTests.m
//  ViewConflictTests
//
//  Created by xukaitiankevin on 2019/7/5.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QYPlayerViewConflictDefine.h"
@interface ViewConflictTests : XCTestCase

@end

@implementation ViewConflictTests

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

- (void)testQYConflictViewConfig{
    NSDictionary* dic = nil;
    XCTAssert(NO == [QYConflictViewConfig isValidConflictConfig:dic],@"QYConflictViewConfig isValidConflictConfig 空值判断未通过");
}

@end
