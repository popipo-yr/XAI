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
@interface XAIDevSwitch : XAIDevice{

    BOOL _isGetOneStatus;
    BOOL _isGetTwoStatus;
}


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




@protocol  XAIDevSwitchDelegate <NSObject>

- (void) switch_:(XAIDevSwitch*)swi getCircuitOneStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err;
- (void) switch_:(XAIDevSwitch*)swi setCircuitOneErr:(XAI_ERROR)err;

- (void) switch_:(XAIDevSwitch*)swi getCircuitTwoStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err;
- (void) switch_:(XAIDevSwitch*)swi setCircuitTwoErr:(XAI_ERROR)err;


@end

typedef NS_ENUM(NSUInteger,_XAIDevSWitchOpr){
    
    XAIDevSwitchOpr_GetOneStatus = __Dev_lastItem,
    XAIDevSwitchOpr_GetTwoStatus,
    XAIDevSwitchOpr_SetOne,
    XAIDevSwitchOpr_SetTwo,
    __DevSwitch_lastItem,
};

