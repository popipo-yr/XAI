//
//  MQTTCover.m
//  XAI
//
//  Created by office on 14-4-10.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTTCover.h"

#define APNS_STR_TOTAL_LEN  8
#define LUID_STR_TOTAL_LEN  16
#define OTHER_STR_TOTAL_LEN  2

@implementation MQTTCover


+ (NSString*) apsnToString:(uint32_t)APNS{
    
    NSString* apns_end_str = [NSString stringWithFormat:@"%x",APNS];
    
    unichar ucdata[16] = {'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'};
    
    int  apns_start_len =   APNS_STR_TOTAL_LEN - [apns_end_str length];
   
    
    if (apns_end_str < 0 ) {
        
        return NULL;
    }
    
    
    NSString* apns_start_str = [[NSString alloc] initWithCharacters:ucdata length:apns_start_len];
    
    
    NSString*  APNS_Str = [[NSString alloc] initWithFormat:@"0x%@%@",apns_start_str,apns_end_str];
    
    
    return APNS_Str;

}

+ (NSString*) luidToString:(uint64_t)luid{

    
    NSString* luid_end_str = [NSString stringWithFormat:@"%llx",luid];
    
    unichar ucdata[16] = {'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'};
    
       int  luid_start_len =   LUID_STR_TOTAL_LEN - [luid_end_str length];
    
    if ( luid_end_str < 0) {
        
        return NULL;
    }
    
    NSString* luid_start_str = [[NSString alloc] initWithCharacters:ucdata length:luid_start_len];
    
    
    NSString*  LUID_Str = [[NSString alloc] initWithFormat:@"0x%@%@",luid_start_str,luid_end_str];
    
    return LUID_Str;

}

+ (NSString*) stringFormat:(NSString*)format APNS:(uint32_t)APNS luid:(uint64_t)luid{

    
    NSString* apns_end_str = [NSString stringWithFormat:@"%x",APNS];
    NSString* luid_end_str = [NSString stringWithFormat:@"%llx",luid];
    
     unichar ucdata[16] = {'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'};
    
    int  apns_start_len =   APNS_STR_TOTAL_LEN - [apns_end_str length];
    int  luid_start_len =   LUID_STR_TOTAL_LEN - [luid_end_str length];
    
    if (apns_end_str < 0 || luid_end_str < 0) {
        
        return NULL;
    }
    
    NSString* luid_start_str = [[NSString alloc] initWithCharacters:ucdata length:luid_start_len];
    
    
     NSString* apns_start_str = [[NSString alloc] initWithCharacters:ucdata length:apns_start_len];
    
    
    NSString*  APNS_Str = [[NSString alloc] initWithFormat:@"0x%@%@",apns_start_str,apns_end_str];
    
    NSString*  LUID_Str = [[NSString alloc] initWithFormat:@"0x%@%@",luid_start_str,luid_end_str];
    
    return [NSString stringWithFormat:format,APNS_Str,LUID_Str];
    
}


+ (NSString*) stringOther:(uint8_t)other{
    
    
    NSString* other_end_str = [[NSString alloc] initWithFormat:@"%x",other];
    
    
    unichar ucdata[16] = {'0','0'};
    
    int  other_start_len =   OTHER_STR_TOTAL_LEN - [other_end_str length];
    
    if (other_start_len < 0) {
        
        return NULL;
        
    }
    
    NSString* other_start_str = [[NSString alloc] initWithCharacters:ucdata length:other_start_len];
    
    NSString*  Other_Str = [[NSString alloc] initWithFormat:@"0x%@%@",other_start_str,other_end_str];
    
    return Other_Str;
    
}


+ (NSString*) nodeDevTableTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
    
    return [MQTTCover stringFormat:@"%@/NODES/%@/OUT/DEV" APNS:APNS luid:luid];

}
+ (NSString*) nodeStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{

    return [MQTTCover stringFormat:@"%@/NODES/%@/OUT/STATUS" APNS:APNS luid:luid];
}
+ (NSString*) nodeStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other{

    //0x%08x/NODES/0x%016llx/OUT/STATUS/%02d
    
    NSString*  other_Str = [MQTTCover stringOther:other];
    
    return [NSString stringWithFormat:@"%@/%@"
            ,[MQTTCover stringFormat:@"%@/NODES/%@/OUT/STATUS" APNS:APNS luid:luid]
            ,other_Str];
    
    
}

+ (NSString*) serverStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t) luid{

    return [MQTTCover stringFormat:@"%@/SERVER/%@/OUT/+" APNS:APNS luid:luid];
}

+ (NSString*) serverStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other{
    //状态表： 0x%08x/SERVER/0x%016llx/OUT/STATUS/%02d
    
    NSString*  other_Str = [MQTTCover stringOther:other];
    
    return [NSString stringWithFormat:@"%@/%@"
            ,[MQTTCover stringFormat:@"%@/SERVER/%@/OUT/STATUS" APNS:APNS luid:luid]
            ,other_Str];
}

+ (NSString*) mobileStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid {
    
       return [MQTTCover stringFormat:@"%@/MOBILES/%@/OUT/STATUS" APNS:APNS luid:luid];
    
}


+ (NSString*) mobileStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other{

    //0x%08x/MOBILES/0x%016llx/OUT/STATUS/%02d
    
    NSString*  other_Str = [MQTTCover stringOther:other];
    
    return [NSString stringWithFormat:@"%@/%@"
            ,[MQTTCover stringFormat:@"%@/MOBILES/%@/OUT/STATUS" APNS:APNS luid:luid]
            ,other_Str];

}
+ (NSString*) nodeCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
    //0x%08x/NODES/0x%016llx/IN
   return [MQTTCover stringFormat:@"%@/NODES/%@/IN" APNS:APNS luid:luid];
}
+ (NSString*) serverCtrlTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
    
    //0x%08x/SERVER/0x%016llx/IN
    return [MQTTCover stringFormat:@"%@/SERVER/%@/IN" APNS:APNS luid:luid];
}
+ (NSString*) mobileCtrTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
 //0x%08x/MOBILES/0x%016llx/IN
    
    //return [NSString stringWithFormat:@"0x00000000/MOBILES/0x0000000000000001/IN"];
   return [MQTTCover stringFormat:@"%@/MOBILES/%@/IN" APNS:APNS luid:luid];

}








@end
