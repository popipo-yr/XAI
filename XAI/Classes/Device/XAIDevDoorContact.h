//
//  XAIDevDoorContact.h
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIDevice.h"

@protocol XAIDevDoorContactDelegate;
@interface XAIDevDoorContact : XAIDevice

@property (nonatomic,weak) id<XAIDevDoorContactDelegate> dcDelegate;

- (void) getDoorContactStatus;
- (void) getPower; //BatteryPower

-(NSArray *)getLinkageUseStatusInfos;

@end


typedef enum XAIDevDoorContactStatus{
    
    XAIDevDoorContactStatusOpen = 1,
    XAIDevDoorContactStatusClose = 0,
    
    XAIDevDoorContactStatusUnkown = 9
    
}XAIDevDoorContactStatus;



@protocol XAIDevDoorContactDelegate <NSObject>

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
