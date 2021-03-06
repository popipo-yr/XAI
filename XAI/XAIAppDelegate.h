//
//  AAAppDelegate.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTT.h"
#import "XAIAlert.h"
#import "XAIObject.h"
#import "Reachability.h"
#import "XAIReLogin.h"
#import "XAINoAcceptPacketHandle.h"

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)


@interface XAIAppDelegate : UIResponder
<UIApplicationDelegate,XAIReLoginDelegate,UIAlertViewDelegate,MQTTKeepAliveDelegate>{

    MosquittoClient* _mosquittoClient;
    MQTTPacketManager* _mqttPacketManager;
    XAINoAcceptPacketHandle* _noAcceptHandle;
    Reachability* _netReachability;
    XAIReLogin* _reLogin;
    
    UIAlertView* _reLoginStartAlert; /*用于重新登录和更新数据,用_isRelogin进行区分*/
    UIAlertView* _reLoginFailAlert;
    UIAlertView* _otherLoginTipAlert;
    
    BOOL  _isRelogin;
    BOOL  _isReConnect;
    BOOL  _needKeepTip;

}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic)  BOOL  needKeepTip;

- (void) changeMQTTClinetID:(NSString*)clientID;

@end
