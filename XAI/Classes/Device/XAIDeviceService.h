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

#import "XAIDevice.h"



@protocol XAIDeviceServiceDelegate <XAIDeviceStatusDelegate>

@optional
//- (void) findedDevice:(BOOL) isFinded Luid:(XAITYPELUID) luid withName:(NSString*) name;
- (void) addDevice:(BOOL) isSuccess;
- (void) delDevice:(BOOL) isSuccess;
- (void) changeDeviceName:(BOOL) isSuccess;
- (void) findedAllDevice:(BOOL) isSuccess datas:(NSArray*) devAry;

- (void) finddedAllOnlineDevices:(NSSet*) luidAry;

@end


@interface XAIDeviceService : XAIDevice <MQTTPacketManagerDelegate>{
    
    NSMutableSet* _allDevices;
    NSMutableSet* _onlineDevices;
    NSTimer*  _timer;
    BOOL _bFinding;

    id<XAIDeviceServiceDelegate> _delegate;
}


@property id<XAIDeviceServiceDelegate> delegate;


- (void) addDev:(XAITYPELUID)dluid  withName:(NSString*)devName;

- (void) delDev:(XAITYPELUID)dluid ;

- (void) changeDev:(XAITYPELUID)dluid withName:(NSString*)newName;

- (void) findAllDev;

/*获取路由下所有在线设备的luid,订阅所有设备的status节点,返回信息的则在线*/
- (void) findAllOnlineDevWithuseSecond:(int) sec;

@end
