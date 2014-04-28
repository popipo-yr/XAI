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




@protocol XAIDeviceServiceDelegate;

@interface XAIDeviceService : XAIDevice <MQTTPacketManagerDelegate>{
    
    NSMutableSet* _allDevices;
    NSMutableSet* _onlineDevices;
    NSTimer*  _timer;
    BOOL _bFinding;

}


@property (nonatomic, weak) id<XAIDeviceServiceDelegate> deviceServiceDelegate;


- (void) addDev:(XAITYPELUID)dluid  withName:(NSString*)devName;

- (void) delDev:(XAITYPELUID)dluid ;

- (void) changeDev:(XAITYPELUID)dluid withName:(NSString*)newName;

- (void) findAllDev;

/*获取路由下所有在线设备的luid,订阅所有设备的status节点,返回信息的则在线*/
- (void) findAllOnlineDevWithuseSecond:(int) sec;

@end


@protocol XAIDeviceServiceDelegate <NSObject>

@optional

- (void) devService:(XAIDeviceService*)devService addDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode;
- (void) devService:(XAIDeviceService*)devService delDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode;
- (void) devService:(XAIDeviceService*)devService changeDevName:(BOOL)isSuccess errcode:(XAI_ERROR)errcode;

- (void) devService:(XAIDeviceService*)devService findedAllDevice:(NSArray*) devAry
             status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode;

- (void) devService:(XAIDeviceService*)devService finddedAllOnlineDevices:(NSSet*) luidAry
             status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode;

@end
