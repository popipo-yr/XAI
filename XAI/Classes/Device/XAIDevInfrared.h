//
//  XAIDevInfrared.h
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIDevice.h"

typedef enum XAIDevInfraredStatus{
    
    XAIDevInfraredStatusDetectorThing = 1, /*探测到物体*/
    XAIDevInfraredStatusDetectorNothing = 0,
    
    XAIDevInfraredStatusUnkown = 9
    
}XAIDevInfraredStatus;

@protocol XAIDevInfraredDelegate;
@interface XAIDevInfrared : XAIDevice

@property (nonatomic,weak) id <XAIDevInfraredDelegate> infDelegate;

- (void) getInfraredStatus;
- (void) getPower;
- (NSArray*) getLinkageStatusInfos;
-(XAIDevInfraredStatus) linkageInfoStatus:(XAILinkageUseInfo*)useInfo;
@end




@protocol XAIDevInfraredDelegate <NSObject>

- (void) infrared:(XAIDevInfrared*)inf status:(XAIDevInfraredStatus)status
              err:(XAI_ERROR)err otherInfo:(XAIOtherInfo*)otherInfo;
- (void) infrared:(XAIDevInfrared*)inf curStatus:(XAIDevInfraredStatus)status err:(XAI_ERROR)err;
- (void) infrared:(XAIDevInfrared*)inf curPower:(float)power err:(XAI_ERROR)err;

@end


typedef NS_ENUM(NSUInteger,_XAIDevInfraredOpr){
    
    XAIDevInfraredOpr_GetCurStatus = __Dev_lastItem,
    XAIDevInfraredOpr_GetCurPower,
    __DevInfraredOpr_lastItem,
};