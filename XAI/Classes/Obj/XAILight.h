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

@protocol  XAILigthtDelegate;
@interface XAILight : XAIObject <XAIDevSwitchDelegate,XAIDeviceStatusDelegate>{


    XAIDevSwitch* _devSwitch;
    
    /*状态控制,正在进行开灯关灯的操作,则不能进行其他操作*/
    BOOL _isOpening;
    BOOL _isClosing;

}

@property (nonatomic, assign) id <XAILigthtDelegate> delegate;


- (void) openLight;
- (void) closeLight;
- (void) getCurStatus;


@end

typedef enum XAILightStatus{

    XAILightStatus_Open = 1,
    XAILightStatus_Close = 0,
    XAILightStatus_Unkown = 9
    
}XAILightStatus;

@protocol XAILigthtDelegate <NSObject>

- (void) lightOpenSuccess:(BOOL)isSuccess;
- (void) lightCloseSuccess:(BOOL)isSuccess;
- (void) lightCurStatus:(XAILightStatus) status;
@end
