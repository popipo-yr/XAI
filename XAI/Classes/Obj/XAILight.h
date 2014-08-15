//
//  XAILight.h
//  XAI
//
//  Created by office on 14-4-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIObject.h"
#import "XAIDevSwitch.h"

#define OpenID  Key_CircuitOneCtrlID
#define CloseID Key_CircuitTwoCtrlID



@protocol  XAILigthtDelegate;
@interface XAILight : XAIObject <XAIDevSwitchDelegate,XAIDeviceStatusDelegate>{


    XAIDevSwitch* _devSwitch;
    
    /*状态控制,正在进行开灯关灯的操作,则不能进行其他操作*/
    BOOL _isOpening;
    BOOL _isClosing;
    
}

@property (nonatomic, assign) int  curStatus;

@property (nonatomic, weak) id <XAILigthtDelegate> delegate;


- (void) openLight;
- (void) closeLight;
- (void) getCurStatus;


@end

typedef enum XAILightStatus{

    XAILightStatus_Open = 1,
    XAILightStatus_Close = 0,
    XAILightStatus_Start = XAIObjStatusOperStart,
    XAILightStatus_err = XAIObjStatusErr,
    XAILightStatus_Unkown = XAIObjStatusUnkown
    
}XAILightStatus;

@protocol XAILigthtDelegate <NSObject>

- (void) light:(XAILight*)light openSuccess:(BOOL)isSuccess;
- (void) light:(XAILight*)light closeSuccess:(BOOL)isSuccess;
- (void) light:(XAILight*)light curStatus:(XAILightStatus) status;
@end


@interface XAILightOpr : XAIObjectOpr

@end
