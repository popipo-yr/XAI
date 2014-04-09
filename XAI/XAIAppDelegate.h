//
//  AAAppDelegate.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTT.h"

@interface XAIAppDelegate : UIResponder <UIApplicationDelegate>{

    MosquittoClient* _mosquittoClient;
    MQTTPacketManager* _mqttPacketManager;
}

@property (strong, nonatomic) UIWindow *window;

@end
