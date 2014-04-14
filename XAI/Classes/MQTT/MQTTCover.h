//
//  MQTTCover.h
//  XAI
//
//  Created by office on 14-4-10.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//



//设备表： 0x%08x/NODES/0x%016llx/OUT/DEV
//状态表： 0x%08x/SERVER/0x%016llx/OUT/STATUS/%02d
//0x%08x/NODES/0x%016llx/OUT/STATUS/%02d
//0x%08x/MOBILES/0x%016llx/OUT/STATUS/%02d
//
//控制命令：
//0x%08x/SERVER/0x%016llx/IN
//0x%08x/NODES/0x%016llx/IN
//0x%08x/MOBILES/0x%016llx/IN


#import <Foundation/Foundation.h>

#define MQTTCover_LUID_Server_03 0x03
#define MQTTCover_UserTable_Other 0x01
#define MQTTCover_DevTable_Other  0x02


@interface MQTTCover : NSObject

+ (NSString*) nodeDevTableTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;

+ (NSString*) nodeStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other;
+ (NSString*) serverStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t) luid other:(uint8_t)other;
+ (NSString*) mobileStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other;
+ (NSString*) nodeCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) serverCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) mobileCtrTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;


@end


