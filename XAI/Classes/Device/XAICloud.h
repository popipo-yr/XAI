//
//  XAICloud.h
//  XAI
//
//  Created by office on 14-10-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevice.h"

@protocol XAICloudDelegate;

@interface XAICloud : XAIDevice

@property (nonatomic,weak) id<XAICloudDelegate> cloudDelegate;
- (void) bridgeStatus;

@end

typedef NS_ENUM(NSUInteger, XAICloudStatus){

    XAICloudStatus_ON = 0,
    XAICloudStatus_OFF = 1,
    XAICloudStatus_UNKown = 100
};


@protocol XAICloudDelegate <NSObject>

- (void)cloud:(XAICloud*)cloud status:(XAICloudStatus)status err:(XAI_ERROR)err;

@end
