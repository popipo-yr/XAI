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
#define MQTTCover_LinkageTable_Other  0x04
#define MQTTCover_LinkageTableDetail_Other  0x03


@interface MQTTCover : NSObject


+ (NSString*) apsnToString:(uint32_t)apsn;
+ (NSString*) luidToString:(uint64_t)luid;

+ (NSString*) nodeDevTableTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;

+ (NSString*) nodeStatusAllTopicWithAPNS:(uint32_t)APNS;
+ (NSString*) nodeStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) nodeStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other;
+ (NSString*) serverStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t) luid;
+ (NSString*) serverStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t) luid other:(uint8_t)other;
+ (NSString*) mobileStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) mobileStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other;
+ (NSString*) nodeCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) serverCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) mobileCtrTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid;
+ (NSString*) linkageStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other num:(uint8_t)num;


+ (BOOL) isNodeTopic:(NSString*)topic;
+ (BOOL) isServerTopic:(NSString*)topic;

/*topic字符串种获取luid 和 apsn*/
+ (uint32_t) nodeTopicAPSN:(NSString*)topic;
+ (uint64_t) nodeTopicLUID:(NSString*)topic;

/*扫描的字符串转化为APSN*/
+ (BOOL)  qrStr:(NSString*)qrStr ToLuidStr:(NSString**)luidStr;


@end


