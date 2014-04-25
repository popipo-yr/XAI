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

@optional
//- (void) findedDevice:(BOOL) isFinded Luid:(XAITYPELUID) luid withName:(NSString*) name;
- (void) addDevice:(BOOL) isSuccess;
- (void) delDevice:(BOOL) isSuccess;
- (void) changeDeviceName:(BOOL) isSuccess;
- (void) findedAllDevice:(BOOL) isSuccess datas:(NSArray*) devAry;

- (void) finddedAllOnlineDevices:(NSSet*) luidAry;

@end


@interface XAIDeviceService : NSObject <MQTTPacketManagerDelegate>{
    
    NSMutableSet* _allDevices;
    NSMutableSet* _onlineDevices;
    NSTimer*  _timer;
    XAITYPEAPSN  _apsn;
    BOOL _bFinding;

}


@property id<XAIDeviceServiceDelegate> delegate;


- (void) addDev:(XAITYPELUID)dluid  withName:(NSString*)devName
           apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;

- (void) delDev:(XAITYPELUID)dluid apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;

- (void) changeDev:(XAITYPELUID)dluid withName:(NSString*)newName
               apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;


- (void) findAllDevWithApsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;

/*获取路由下所有在线设备的luid,订阅所有设备的status节点,返回信息的则在线*/
- (void) findAllOnlineDevWithApsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid useSecond:(int) sec;

@end
