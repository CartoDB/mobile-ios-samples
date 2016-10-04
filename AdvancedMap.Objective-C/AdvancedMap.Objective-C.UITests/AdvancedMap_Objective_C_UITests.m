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

    XCUIElement* element = [cells elementBoundByIndex:0];
    [element tap];
    
//    for (int i = 0; i < count; i++) {
//        XCUIElement* element = [cells elementBoundByIndex:i];
//        [element tap];
//    }
    
}

//- (void)testExample2 {
//    
//    UITableView* table = (UITableView *)self.controller.view;

//    NSString* sampleCount = [NSString stringWithFormat:@"%lu", (unsigned long)[self.controller.samples count]];
//    NSLog(@"SAMPLES COUNT: ");
//    NSLog(sampleCount);
    
//    NSLog(@"SUBVIEW COUNT: ");
//    UITableView* child = (UITableView *)table.subviews[0];
//    NSString *subviewCount = [NSString stringWithFormat:@"%lu", [child.subviews count]];
//    NSLog(subviewCount);
    
//    XCUIElementQuery* query = [self.app.cells containingType:XCUIElementTypeStaticText identifier:@"MapListCell"];
//    NSLog(@"QUERY COUNT: ");
//    NSString *queryCount = [NSString stringWithFormat:@"%lu", [query count]];
//    NSLog(queryCount);
    
//    NSUInteger count = self.controller.samples.count;
//    CGFloat cellheight = 70;
//    CGFloat width = table.frame.size.width;
//    
//    CGFloat y = 10;
//    
//    for (int i = 1; i <= count; i++) {
//        CGVector point = CGVectorMake(width / 2, y);
//        XCUICoordinate* coordinate = [self.app coordinateWithNormalizedOffset:point];
//        
//        sleep(2);
//        [coordinate tap];
//        
//        y += cellheight;
//    }
//}

@end





