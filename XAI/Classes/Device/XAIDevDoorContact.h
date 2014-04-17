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


@protocol XAIDevDoorContactDelegate <NSObject>

- (void) doorContactStatusGetSuccess:(BOOL)isSuccess curStatus:(XAIDevDoorContactStatus)status;
- (void) doorContactPowerGetSuccess:(BOOL)isSuccess curPower:(float)power;

@end
