//
//  XAIDeviceService.h
//  XAI
//
//  Created by office on 14-4-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"

@interface XAIDeviceService : NSObject <MQTTPacketManagerDelegate>


- (void) addDev:(XAITYPELUID)luid  withName:(NSString*)devName;
- (void) delDev:(XAITYPELUID)luid;
- (void) changeDev:(XAITYPELUID)luid withName:(NSString*)newName;

@end
