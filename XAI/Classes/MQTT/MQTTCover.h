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

@interface MQTTCover : NSObject

+ (NSString*) devTableTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) devStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other;
+ (NSString*) serverStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t) luid other:(uint8_t)other;
+ (NSString*) mobileStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other;
+ (NSString*) devCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) serverCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) mobileCtrTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;

@end


