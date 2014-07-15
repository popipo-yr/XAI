//
//  XAIIR.h
//  XAI
//
//  Created by office on 14-7-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObject.h"
#import "XAIDevInfrared.h"


@protocol XAIIRDelegate;
@interface XAIIR : XAIObject<XAIDevInfraredDelegate,XAIDeviceStatusDelegate>{

    XAIDevInfrared* _infrared;

}
@property (nonatomic, assign) id <XAIIRDelegate> delegate;

- (void)getCurStatus;
- (void)getPower;

@end

typedef enum XAIIRStatus{
    
    XAIIRStatus_working = 1,
    XAIIRStatus_warning = 0,
    XAIIRStatus_Unkown = 9
    
}XAIIRStatus;

@protocol XAIIRDelegate <NSObject>
- (void) ir:(XAIIR*)ir curStatus:(XAIIRStatus) status getIsSuccess:(BOOL)isSuccess;
- (void) ir:(XAIIR*)ir curPower:(float)power getIsSuccess:(BOOL)isSuccess;
@end

@interface XAIIROpr : XAIObjectOpr

@end
