//
//  AAAppDelegate.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTT.h"
#import "XAIObject.h"

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)


@interface XAIAppDelegate : UIResponder <UIApplicationDelegate>{

    MosquittoClient* _mosquittoClient;
    MQTTPacketManager* _mqttPacketManager;
}

@property (strong, nonatomic) UIWindow *window;

@end
