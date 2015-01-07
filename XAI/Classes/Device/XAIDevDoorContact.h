//
//  XAIDevDoorContact.h
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIDevice.h"


typedef enum XAIDevDoorContactStatus{
    
    XAIDevDoorContactStatusOpen = 1,
    XAIDevDoorContactStatusClose = 0,
    
    XAIDevDoorContactStatusUnkown = 9
    
}XAIDevDoorContactStatus;


@protocol XAIDevDoorContactDelegate;
@interface XAIDevDoorContact : XAIDevice

@property (nonatomic,weak) id<XAIDevDoorContactDelegate> dcDelegate;

- (void) getDoorContactStatus;
- (void) getPower; //BatteryPower

-(NSArray *)getLinkageUseStatusInfos;
-(XAIDevDoorContactStatus) linkageInfoStatus:(XAILinkageUseInfo*)useInfo;

@end





@protocol XAIDevDoorContactDelegate <NSObject>
/*********************
 当调用getDoorContactStatus,如果失败直接通知代理curstatus,
 成功则通知代理status,这时server可能缓存了多个状态,则代理必须储存多个状态,通过id进行排序找出curstatus
 */
- (void) doorContact:(XAIDevDoorContact*)dc curStatus:(XAIDevDoorContactStatus)status err:(XAI_ERROR)err;
- (void) doorContact:(XAIDevDoorContact*)dc curPower:(float)power err:(XAI_ERROR)err;
- (void) doorContact:(XAIDevDoorContact*)dc status:(XAIDevDoorContactStatus)status
                 err:(XAI_ERROR)err otherInfo:(XAIOtherInfo*)otherInfo;

@end


typedef NS_ENUM(NSUInteger,_XAIDevDCOpr){
    
    XAIDevDCOpr_GetCurStatus = __Dev_lastItem,
    XAIDevDCOpr_GetCurPower,
    __DevDCOpr_lastItem,
};
