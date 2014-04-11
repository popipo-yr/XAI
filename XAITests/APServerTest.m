//
//  APServerTest.m
//  XAI
//
//  Created by office on 14-4-10.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APServerNode.h"

@interface APServerTest : XCTestCase

@end

@implementation APServerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"%i",@"int",
                          @"%0.1g",@"float",
                          @"%i",@"char",
                          
                          nil];
    
	NSNumber *num1 = [NSNumber numberWithFloat:233.3333333];
	NSLog(@"%@",[num1 descriptionWithLocale:dict]);
    
    NSNumber *num2 = [NSNumber numberWithInt:123];
	NSLog(@"%@",[num2 descriptionWithLocale:dict]);
    
    
    NSString *tempNumber;
    tempNumber=@"0x11";
    NSScanner *scanner=[NSScanner scannerWithString:tempNumber];
    unsigned int temp;
    [scanner scanHexInt:&temp];
    NSLog(@"%@:%d",tempNumber,temp);
    
    
    uint32_t   APNS =99;
    
    NSString*  s = [[NSString alloc] initWithBytes:&APNS length:4 encoding:NSUTF8StringEncoding];
    
    
    uint16_t cover = 0x8877;
    
    uint16_t  cover1 =  CFSwapInt16HostToBig(cover);
    uint16_t  cover2 =  CFSwapInt16BigToHost(cover);
    
    NSNumber* aNumber = [NSNumber numberWithInt:0x99];
    //[aNumber descriptionWithLocale:[NSString stringWithFormat:@"0x%i"]];
    
    NSString* str = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0x99]];
    
    NSDecimalNumber* dNum = [NSDecimalNumber decimalNumberWithDecimal:[aNumber decimalValue]];
    
    NSLog(@"%@",[dNum stringValue]);
    
    APServerNode* node = [[APServerNode alloc] init];
    [node addUser:@"testname" Password:@"testname"];
    
    
    
     XCTAssertTrue( 1 == 1, @"APServer");
}

@end
