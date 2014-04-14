//
//  XAILogin.h
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"
#import "XAIUserService.h"

@protocol XAILoginDelegate <NSObject>

- (void)  loginFinishWithStatus:(BOOL) status;

@end

@interface XAILogin : NSObject <MQTTConnectDelegate,MQTTPacketManagerDelegate,XAIUserServiceDelegate>{


    NSMutableString*  _name;
    XAIUserService* _userService;
    


}



- (void) loginWithName:(NSString*)name Password:(NSString*)password Host:(NSString*)host;

@end
