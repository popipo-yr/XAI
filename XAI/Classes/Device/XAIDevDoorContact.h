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

@end


typedef enum XAIDevDoorContactStatus{
    
    XAIDevDoorContactStatusOpen = 1,
    XAIDevDoorContactStatusClose = 0,
    
    XAIDevDoorContactStatusUnkown = 9
    
}XAIDevDoorContactStatus;

typedef enum{
    
    XAIDevDCErr_NONE,
    XAIDevDCErr_TimeOut,
    XAIDevDCErr_Unknow,
    
}XAIDevDCErr;


@protocol XAIDevDoorContactDelegate <NSObject>

- (void) doorContact:(XAIDevDoorContact*)dc curStatus:(XAIDevDoorContactStatus)status err:(XAIDevDCErr)err;
- (void) doorContact:(XAIDevDoorContact*)dc curPower:(float)power err:(XAIDevDCErr)err;

@end


typedef NS_ENUM(NSUInteger,_XAIDevDCOpr){
    
    XAIDevDCOpr_GetCurStatus = __Dev_lastItem,
    XAIDevDCOpr_GetCurPower,
    __DevDCOpr_lastItem,
};
