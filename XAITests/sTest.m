//
//  Test.m
//  XAI
//
//  Created by office on 14-5-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface sTest : XCTestCase

@end

@implementation sTest

- (id)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    //[self setUpBenchmark];
    
    return self;
}

- (void)setUp {
    [super setUp];
    [self setUpBenchmark];
}

- (NSString *)benchmarkPrefix {
    return @"abc_";
}

- (NSArray *)benchmarkMethods:(NSString *) prefix {
    NSArray *methodNames = [self instanceMethodNames];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", prefix];
    NSArray *filteredMethods = [methodNames filteredArrayUsingPredicate:predicate];
    return filteredMethods;
}

- (NSArray *)instanceMethodNames {
    NSUInteger count;
    NSMutableArray *methodNames = [NSMutableArray array];
    Method *methods = class_copyMethodList([self class], &count);
    for (NSUInteger i = 0; i < count; i++) {
        [methodNames addObject:NSStringFromSelector(method_getName(methods[i]))];
    }
    return methodNames;
}

- (void)setUpBenchmark {
    XCTestSuite *suite = [XCTestSuite testSuiteForTestCaseClass:[self class]];
    
    NSArray* test = [suite tests];
    
    NSArray *methodNames = [self benchmarkMethods:[self benchmarkPrefix]];
    for (NSString *methodName in methodNames) {
        SEL benchmarkSelector = NSSelectorFromString(methodName);
        XCTestCase *testCase = [[[self class] alloc] initWithSelector:benchmarkSelector];
        [suite addTest:testCase];
    }
    
    NSLog(@"%d", [self testCaseCount]);
    
    NSArray* ABC = [[self class] testInvocations];
    
    XCTestRun* run =  [XCTestRun testRunWithTest:suite];
    [run start];
    
}


- (void) abc_DK{
    
    NSAssert(1 == 2, @"fakse");
}

- (void) abc_KK{
    
    NSAssert(1 == 2, @"fakse");
    
    NSLog(@"YES");

}

- (void) testA{

}
@end
