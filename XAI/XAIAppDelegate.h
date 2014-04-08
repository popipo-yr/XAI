//
//  AAAppDelegate.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosquittoClient.h"
#import "MQTTPacketManager.h"

@interface XAIAppDelegate : UIResponder <UIApplicationDelegate>{

    //MosquittoClient* _mosquittoClient;
}

@property (strong, nonatomic) UIWindow *window;
@property (readonly) MosquittoClient* mosquittoClient;
@property (readonly) MQTTPacketManager* mqttPacketManager;

@end
