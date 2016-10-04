//
//  AdvancedMap_Objective_C_UITests.m
//  AdvancedMap.Objective-C.UITests
//
//  Created by Aare Undo on 04/10/16.
//  Copyright © 2016 Nutiteq. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LauncherListController.h"

@interface AdvancedMap_Objective_C_UITests : XCTestCase

@property (nonatomic) LauncherListController *controller;
@property (nonatomic) XCUIApplication* app;

@end

@implementation AdvancedMap_Objective_C_UITests

- (void)setUp {
    [super setUp];
    
    self.controller = [[LauncherListController alloc]init];
    [self.controller performSelectorOnMainThread:@selector(viewDidLoad) withObject:nil waitUntilDone:YES];
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    
    // UI tests must launch the application that they test.
    // Doing this in setup will make sure it happens for each test method.
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
    sleep(1);
}

- (void)tearDown {
    // This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample1 {

    XCUIElementQuery *tablesQuery = self.app.tables;
    XCUIElementQuery* cells = tablesQuery.element.cells;

    for (int i = 0; i < [cells count]; i++) {
        
//        if (i > 0) {
            // TODO -> && [cells elementBoundByIndex:i - 1] frame.bottom ~= self.app.frame.bottom
//            [self.app swipeUp];
//        }
        
        XCUIElement* element = [cells elementBoundByIndex:i];
        [element tap];
        
        XCUIElement* backButton = [self.app.buttons elementBoundByIndex:0];
        [backButton tap];
    }
}

@end





