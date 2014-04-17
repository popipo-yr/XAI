//
//  XAIDevice.h
//  XAI
//
//  Created by office on 14-4-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"

#define Key_DeviceStatusID  127

@protocol XAIDeviceStatusDelegate;
@interface  XAIDevice: NSObject <MQTTPacketManagerDelegate>{

    XAITYPELUID _luid;
    XAITYPEAPSN _apsn;
    NSString* _name;
}

@property (nonatomic, assign) XAITYPELUID luid;
@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, weak) id <XAIDeviceStatusDelegate> delegate;

- (void) getDeviceStatus;

@end



typedef enum XAIDeviceStatus{
    
    XAIDeviceStatus_OFFLINE   = 0,
    XAIDeviceStatus_ONLINE    = 1,
    XAIDeviceStatus_SleepIng  = 2,
    XAIDeviceStatus_UNKOWN    = 0x99
    
}XAIDeviceStatus;



@protocol XAIDeviceStatusDelegate <NSObject>

- (void) getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish;

@end