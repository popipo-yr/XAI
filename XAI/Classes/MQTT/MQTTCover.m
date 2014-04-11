//
//  MQTTCover.m
//  XAI
//
//  Created by office on 14-4-10.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTTCover.h"

@implementation MQTTCover

+ (NSString*) stringFormat:(NSString*)format APNS:(uint32_t)APNS luid:(uint64_t)luid{

    //设备表： 0x%08x/NODES/0x%016llx/OUT/DEV
    NSString*  APNS_Str = [[NSString alloc] initWithBytes:&APNS length:4 encoding:NSUTF8StringEncoding];
    
    NSString*  LUID_Str = [[NSString alloc] initWithBytes:&luid length:8 encoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:format,APNS_Str,LUID_Str];
    
}

+ (NSString*) devTableTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
    
    //return [MQTTCover stringFormat:@"0x%@/NODES/0x%@/OUT/DEV" APNS:APNS luid:luid];
    
    return [NSString stringWithFormat:@"0x00000000/NODES/0x0000000000000001/OUT/DEV"];
    
    //设备表： 0x%08x/NODES/0x%016llx/OUT/DEV

}
+ (NSString*) devStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other{

    //0x%08x/NODES/0x%016llx/OUT/STATUS/%02d
    
    NSString*  other_Str = [[NSString alloc] initWithBytes:&luid length:1 encoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"%@/%@"
            ,[MQTTCover stringFormat:@"%@/NODES/%@/OUT/STATUS" APNS:APNS luid:luid]
            ,other_Str];
    
    
}
+ (NSString*) serverStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other{
    //状态表： 0x%08x/SERVER/0x%016llx/OUT/STATUS/%02d
    
    NSString*  other_Str = [[NSString alloc] initWithBytes:&luid length:1 encoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"%@/%@"
            ,[MQTTCover stringFormat:@"%@/SERVER/%@/OUT/STATUS" APNS:APNS luid:luid]
            ,other_Str];
}
+ (NSString*) mobileStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other{

    //0x%08x/MOBILES/0x%016llx/OUT/STATUS/%02d
    
    NSString*  other_Str = [[NSString alloc] initWithBytes:&luid length:1 encoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"%@/%@"
            ,[MQTTCover stringFormat:@"%@/MOBILES/%@/OUT/STATUS" APNS:APNS luid:luid]
            ,other_Str];

}
+ (NSString*) devCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
    //0x%08x/NODES/0x%016llx/IN
   return [MQTTCover stringFormat:@"%@/NODES/%@/IN" APNS:APNS luid:luid];
}
+ (NSString*) serverCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
    
    //0x%08x/SERVER/0x%016llx/IN
    return [MQTTCover stringFormat:@"%@/SERVER/%@/IN" APNS:APNS luid:luid];
}
+ (NSString*) mobileCtrTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
 //0x%08x/MOBILES/0x%016llx/IN
    
    return [NSString stringWithFormat:@"0x00000000/MOBILES/0x0000000000000001/IN"];
   return [MQTTCover stringFormat:@"0%@/MOBILES/%@/IN" APNS:APNS luid:luid];

}








@end
