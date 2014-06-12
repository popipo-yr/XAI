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
#import "Reachability.h"
#import "XAIReLogin.h"

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)


@interface XAIAppDelegate : UIResponder <UIApplicationDelegate,XAIReLoginDelegate,UIAlertViewDelegate>{

    MosquittoClient* _mosquittoClient;
    MQTTPacketManager* _mqttPacketManager;
    Reachability* _netReachability;
    XAIReLogin* _reLogin;
    
    UIAlertView* _reLoginStartAlert;
    UIAlertView* _reLoginFailAlert;
}

@property (strong, nonatomic) UIWindow *window;

@end
