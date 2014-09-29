//
//  XAICloudService.h
//  XAI
//
//  Created by office on 14-9-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevice.h"

typedef NS_ENUM(NSInteger, XAICloudStatus){
    XAICloudStatus_Offline = 0,
    XAICloudStatus_Online = 1,
    XAICloudStatus_Unkown = 9,
};
@protocol XAICloudServiceDelegate;

@interface XAICloudService : XAIDevice

@property (nonatomic,assign) id<XAICloudServiceDelegate> cloudServiceDelegate;

- (void) curStatus;

@end


@protocol XAICloudServiceDelegate <NSObject>

-(void)cloudService:(XAICloudService*)cloudService status:(XAICloudStatus)status;

@end