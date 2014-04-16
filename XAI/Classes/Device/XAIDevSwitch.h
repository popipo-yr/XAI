//
//  XAIDevSwitch.h
//  XAI
//
//  Created by office on 14-4-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIDevice.h"


typedef enum XAIDevCircuitStatus{
    
    XAIDevCircuitStatusOpen = 1,
    XAIDevCircuitStatusClose = 0,
    
    XAIDevCircuitUnkown = 9
    
}XAIDevCircuitStatus;



@protocol  XAIDevSwitchDelegate;
@interface XAIDevSwitch : XAIDevice


@property (nonatomic,assign) id<XAIDevSwitchDelegate> swiDelegate;
/**
 @to-do:   获取线路一的状态
 */
- (void) getCircuitOneStatus;

/**
 @to-do:   获取线路二的状态
 */
- (void) getCircuitTwoStatus;

/**
 @to-do:  设置线路一的状态
 */
- (void) setCircuitOneStatus:(XAIDevCircuitStatus)status;

/**
 @to-do:   设置线路二的状态
 */
- (void) setCircuitTwoStatus:(XAIDevCircuitStatus)status;

@end

//--------------------


@protocol  XAIDevSwitchDelegate <NSObject>

- (void) circuitOneGetSuccess:(BOOL)isSuccess curStatus:(XAIDevCircuitStatus)status;
- (void) circuitOneSetSuccess:(BOOL)isSuccess;

- (void) circuitTwoGetSuccess:(BOOL)isSuccess curStatus:(XAIDevCircuitStatus)status;
- (void) circuitTwoSetSuccess:(BOOL)isSuccess;


@end



