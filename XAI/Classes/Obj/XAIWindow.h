//
//  XAIWindow.h
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObject.h"
#import "XAIDevDoorContact.h"

@protocol XAIWindownDelegate;
@interface XAIWindow : XAIObject<XAIDevDoorContactDelegate,XAIDeviceStatusDelegate>{
    
    XAIDevDoorContact* _doorContact;
    
}
@property (nonatomic, assign) id <XAIWindownDelegate> delegate;

- (void) getCurStatus;
- (void)getPower;

@end


typedef enum XAIWindowStatus{
    
    XAIWindowStatus_Open = 1,
    XAIWindowStatus_Close = 0,
    XAIWindowStatus_Unkown = XAIObjStatusUnkown
    
}XAIWindowStatus;


@protocol XAIWindownDelegate <NSObject>
- (void) window:(XAIWindow*)window curStatus:(XAIWindowStatus) status getIsSuccess:(BOOL)isSuccess;
- (void) window:(XAIWindow*)window curPower:(float)power getIsSuccess:(BOOL)isSuccess;
@end


@interface XAIWindowOpr : XAIObjectOpr

@end
