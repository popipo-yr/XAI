//
//  XAIDoor.h
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObject.h"
#import "XAIDevDoorContact.h"

@protocol XAIDoorDelegate;
@interface XAIDoor : XAIObject<XAIDevDoorContactDelegate,XAIDeviceStatusDelegate>{

    XAIDevDoorContact* _doorContact;

}
@property (nonatomic, weak) id <XAIDoorDelegate> delegate;

- (void) getCurStatus;
- (void) getPower;

@end


typedef enum XAIDoorStatus{
    
    XAIDoorStatus_Open = 1,
    XAIDoorStatus_Close = 0,
    XAIDoorStatus_Unkown = XAIObjStatusUnkown
    
}XAIDoorStatus;


@protocol XAIDoorDelegate <NSObject>

- (void) door:(XAIDoor*)door curStatus:(XAIDoorStatus) status getIsSuccess:(BOOL)isSuccess;
- (void) door:(XAIDoor *)door curPower:(float)power getIsSuccess:(BOOL)isSuccess;
@end


@interface XAIDoorOpr : XAIObjectOpr

@end
