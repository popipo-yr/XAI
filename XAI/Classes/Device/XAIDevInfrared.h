//
//  XAIDevInfrared.h
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIDevice.h"

@protocol XAIDevInfraredDelegate;
@interface XAIDevInfrared : XAIDevice

@property (nonatomic,weak) id <XAIDevInfraredDelegate> infDelegate;

- (void) getInfraredStatus;
- (void) getPower;

@end

typedef enum XAIDevInfraredStatus{
    
    XAIDevInfraredStatusDetectorThing = 1, /*探测到物体*/
    XAIDevInfraredStatusDetectorNothing = 0,
    
    XAIDevInfraredStatusUnkown = 9
    
}XAIDevInfraredStatus;



@protocol XAIDevInfraredDelegate <NSObject>

- (void) infraredStatusGetSuccess:(BOOL)isSuccess curStatus:(XAIDevInfraredStatus)status;
- (void) infraredPowerGetSuccess:(BOOL)isSuccess curPower:(float)power;

@end