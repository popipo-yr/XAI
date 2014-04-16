//
//  XAIDeviceService.h
//  XAI
//
//  Created by office on 14-4-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"
#import "XAIDevice.h"



@protocol XAIDeviceServiceDelegate <NSObject>

//- (void) findedDevice:(BOOL) isFinded Luid:(XAITYPELUID) luid withName:(NSString*) name;
- (void) addDevice:(BOOL) isSuccess;
- (void) delDevice:(BOOL) isSuccess;
- (void) changeDeviceName:(BOOL) isSuccess;
- (void) findedAllDevice:(BOOL) isSuccess datas:(NSArray*) devAry;

@end


@interface XAIDeviceService : NSObject <MQTTPacketManagerDelegate>


@property id<XAIDeviceServiceDelegate> delegate;


- (void) addDev:(XAITYPELUID)dluid  withName:(NSString*)devName
           apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;

- (void) delDev:(XAITYPELUID)dluid apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;

- (void) changeDev:(XAITYPELUID)dluid withName:(NSString*)newName
               apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;


- (void) findAllDevWithApsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;


@end
