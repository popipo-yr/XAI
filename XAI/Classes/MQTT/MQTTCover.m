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
#define LinkageNum_STR_TOTAL_LEN  2

@implementation MQTTCover


+ (NSString*) apsnToString:(uint32_t)APNS{
    
    NSString* apns_end_str = [NSString stringWithFormat:@"%x",APNS];
    
    unichar ucdata[16] = {'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'};
    
    int  apns_start_len =   APNS_STR_TOTAL_LEN - [apns_end_str length];
   
    
    if (apns_end_str < 0 ) {
        
        return @"";
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
        
        return @"";
    }
    
    NSString* luid_start_str = [[NSString alloc] initWithCharacters:ucdata length:luid_start_len];
    
    
    NSString*  LUID_Str = [[NSString alloc] initWithFormat:@"0x%@%@",luid_start_str,luid_end_str];
    
    return LUID_Str;

}

//+ (NSString*) linkageNumToString:(uint8_t)num{
//    
//    NSString* num_end_str = [NSString stringWithFormat:@"%x",num];
//    
//    unichar ucdata[16] = {'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'};
//    
//    int  apns_start_len =   APNS_STR_TOTAL_LEN - [apns_end_str length];
//    
//    
//    if (apns_end_str < 0 ) {
//        
//        return NULL;
//    }
//    
//    
//    NSString* apns_start_str = [[NSString alloc] initWithCharacters:ucdata length:apns_start_len];
//    
//    
//    NSString*  APNS_Str = [[NSString alloc] initWithFormat:@"0x%@%@",apns_start_str,apns_end_str];
//    
//    
//    return APNS_Str;
//    
//}


+ (NSString*) stringFormat:( NSString*)format APNS:(uint32_t)APNS luid:(uint64_t)luid{

    
    NSString* apns_end_str = [NSString stringWithFormat:@"%x",APNS];
    NSString* luid_end_str = [NSString stringWithFormat:@"%llx",luid];
    
     unichar ucdata[16] = {'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'};
    
    int  apns_start_len =   APNS_STR_TOTAL_LEN - [apns_end_str length];
    int  luid_start_len =   LUID_STR_TOTAL_LEN - [luid_end_str length];
    
    if (apns_end_str < 0 || luid_end_str < 0) {
        
        return @"";
    }
    
    NSString* luid_start_str = [[NSString alloc] initWithCharacters:ucdata length:luid_start_len];
    
    
     NSString* apns_start_str = [[NSString alloc] initWithCharacters:ucdata length:apns_start_len];
    
    
    NSString*  APNS_Str = [[NSString alloc] initWithFormat:@"0x%@%@",apns_start_str,apns_end_str];
    
    NSString*  LUID_Str = [[NSString alloc] initWithFormat:@"0x%@%@",luid_start_str,luid_end_str];
    
    //return  [NSString  stringWithFormat:format,APNS_Str,LUID_Str];
    __autoreleasing NSString* ret = [[NSString  alloc] initWithFormat:format,APNS_Str,LUID_Str];

    return  ret;
    
}


+ (NSString*) stringOther:(uint8_t)other{
    
    
    NSString* other_end_str = [[NSString alloc] initWithFormat:@"%x",other];
    
    
    unichar ucdata[16] = {'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'};
    
    int  other_start_len =   OTHER_STR_TOTAL_LEN - [other_end_str length];
    
    if (other_start_len < 0) {
        
        return @"";
        
    }
    
    NSString* other_start_str = [[NSString alloc] initWithCharacters:ucdata length:other_start_len];
    
   __autoreleasing NSString*  Other_Str = [[NSString alloc] initWithFormat:@"0x%@%@",other_start_str,other_end_str];
    
    return Other_Str;
    
}

+ (NSString*) stringLinkageNum:(uint8_t)num{
    
    
    NSString* num_end_str = [[NSString alloc] initWithFormat:@"%x",num];
    
    
    unichar ucdata[16] = {'0','0'};
    
    int  num_start_len =   LinkageNum_STR_TOTAL_LEN - [num_end_str length];
    
    if (num_start_len < 0) {
        
        return @"";
        
    }
    
    NSString* num_start_str = [[NSString alloc] initWithCharacters:ucdata length:num_start_len];
    
    NSString*  num_Str = [[NSString alloc] initWithFormat:@"0x%@%@",num_start_str,num_end_str];
    
    return num_Str;
    
}


+ (NSString*) nodeDevTableTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
    
    return [MQTTCover stringFormat:@"%@/NODES/%@/OUT/DEV" APNS:APNS luid:luid];

}

+ (NSString*) nodeStatusAllTopicWithAPNS:(uint32_t)APNS{

    return [NSString stringWithFormat:@"%@/NODES/+/OUT/STATUS",[MQTTCover apsnToString:APNS]];
}

+ (NSString*) nodeStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid{
    
    NSString* format = @"%@/NODES/%@/OUT/STATUS";
    NSString* str = [[NSString alloc] initWithString:[MQTTCover stringFormat:format APNS:APNS luid:luid]];
    return  str;//[MQTTCover stringFormat:@"%@/NODES/%@/OUT/STATUS" APNS:APNS luid:luid];
}
+ (NSString*) nodeStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other{

    //0x%08x/NODES/0x%016llx/OUT/STATUS/%02d
    
    NSString*  other_Str = [[NSString alloc] initWithString:[MQTTCover stringOther:other]];
    NSString*  part_str = [[NSString alloc] initWithString:[MQTTCover stringFormat:@"%@/NODES/%@/OUT/STATUS" APNS:APNS luid:luid]];
    NSString*  formart = @"%@/%@";
    __autoreleasing NSString* ret = [[NSString alloc] initWithFormat:formart,part_str ,other_Str];

    
    return ret;
    
//    return [NSString stringWithFormat:@"%@/%@"
//            ,[MQTTCover stringFormat:@"%@/NODES/%@/OUT/STATUS" APNS:APNS luid:luid]
//            ,other_Str];
    
    
}

+ (NSString*) serverStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t) luid{

    return [MQTTCover stringFormat:@"%@/SERVER/%@/OUT/+" APNS:APNS luid:luid];
}

+ (NSString*) serverStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other{
    //状态表： 0x%08x/SERVER/0x%016llx/OUT/STATUS/%02d
    
    NSString*  other_Str = [[NSString alloc] initWithString:[MQTTCover stringOther:other]];
    
    return [NSString stringWithFormat:@"%@/%@"
            ,[MQTTCover stringFormat:@"%@/SERVER/%@/OUT/STATUS" APNS:APNS luid:luid]
            ,other_Str];
}

+ (NSString*) linkageStatusTopicWithAPNS:(uint32_t)APNS luid:(uint64_t)luid other:(uint8_t)other num:(uint8_t)num{
    //状态表： 0x%08x/SERVER/0x%016llx/OUT/STATUS/%02d
    
    NSString*  other_Str = [MQTTCover stringOther:other];
    NSString*  num_Str =  [MQTTCover stringLinkageNum:num];
    
    return [NSString stringWithFormat:@"%@/%@/%@"
            ,[MQTTCover stringFormat:@"%@/SERVER/%@/OUT/STATUS" APNS:APNS luid:luid]
            ,other_Str
            ,num_Str];
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

+ (NSString*) mobileAllCtrTopicWithAPNS:(uint32_t)APNS{
    //0x%08x/MOBILES/0x%016llx/IN
    
    return [NSString stringWithFormat:@"%@/MOBILES/+/IN",[MQTTCover apsnToString:APNS]];
    
}


+ (BOOL) isNodeTopic:(NSString*)topic{
    
    NSString* sub =  @"/NODES/";
    
    return [sub  isEqualToString:[topic substringWithRange:NSMakeRange(2+APNS_STR_TOTAL_LEN, [sub length])]];

}
+ (BOOL) isNodeStatusTopic:(NSString *)topic{

    if ([MQTTCover isNodeTopic:topic] == false) {
     
        return false;
    }
    
    NSString* status = @"/OUT/STATUS/";
    return [topic rangeOfString:status].location != NSNotFound;
}
+ (BOOL) isServerTopic:(NSString*)topic{
    
    NSString* sub =  @"/SERVER/";
    
    return [sub  isEqualToString:[topic substringWithRange:NSMakeRange(2+APNS_STR_TOTAL_LEN, [sub length])]];


}

+ (BOOL) isMobileTopic:(NSString*)topic{

    NSString* sub =  @"/MOBILES/";
    
    return [sub  isEqualToString:[topic substringWithRange:NSMakeRange(2+APNS_STR_TOTAL_LEN, [sub length])]];
}


+ (uint32_t) nodeTopicAPSN:(NSString*)topic{
    
    uint32_t ret = 0;
    
    NSString* sub = [topic substringWithRange:NSMakeRange(2, APNS_STR_TOTAL_LEN)];
    
    if (nil != sub){
        
        NSScanner* scanner = [NSScanner scannerWithString:sub];
        [scanner scanHexInt:&ret];
    }
    
    return  ret;
    
}
+ (uint64_t) nodeTopicLUID:(NSString *)topic{

    uint64_t ret = 0;
    
    int hexSignLen = [@"0x" length];
    int otherLen = [@"/NODES/" length];
    
    
    NSString* sub = [topic substringWithRange:NSMakeRange(hexSignLen+APNS_STR_TOTAL_LEN+otherLen+hexSignLen,
                                                          LUID_STR_TOTAL_LEN)];
    
    if (nil != sub){
        
        NSScanner* scanner = [NSScanner scannerWithString:sub];
        [scanner scanHexLongLong:&ret];
    }
    
    return  ret;

}



/*扫描的字符串转化为Luid*/
+ (BOOL)  qrStr:(NSString*)qrStr ToLuidStr:(NSString**)luidStr{

 
    BOOL isSuc = false;
    
    do {
        
        if (qrStr.length < 2) break;
    
        
        NSString* typpStr = [qrStr substringToIndex:1];
        NSString* numStr = [qrStr substringFromIndex:1];
        
        UInt64 type = [MQTTCover string36ToUInt64:typpStr];
        UInt64 num  = [MQTTCover string36ToUInt64:numStr];
        
        NSString* num16Str = [NSString stringWithFormat:@"%.12llx",num];
        NSString* type16Str = [NSString stringWithFormat:@"%.4llx",type];
        
        if (num16Str.length > 12) break;
        if (type16Str.length > 4) break;
        
        NSString* qrRM = [NSString stringWithFormat:@"%@%@",type16Str,num16Str];
        
        
        __autoreleasing NSString*  newQrStr = [[NSString alloc] initWithFormat:@"0x%@",qrRM];
        if ([newQrStr length] != (LUID_STR_TOTAL_LEN + OTHER_STR_TOTAL_LEN)) break;
        
        
        *luidStr = qrRM;
        
        isSuc = true;
        
    } while (0);
    
    
    return isSuc;
}


+ (uint64_t) string36ToUInt64:(NSString*)string36{
    
    NSString* upString = [string36 uppercaseString];
    if (upString == nil) return 0;

    uint64_t num = 0;
    
    for (int i = 0 ; i < upString.length; i++) {
        unichar s = [upString characterAtIndex:i];
        if (s >= 48  &&  s <= 57) {
            s = s - 48;
        }else if(s >= 65 && s <= 90){
            s = s - 65 + 10;
        }else{
            //只能是数字和字母
            return 0;
        }
        
        double add = s * pow(36, upString.length - i - 1);
        if (add + num > 0xFFFFFFFFFFFFFFFF) return 0;
        
        num +=  add ;
    }
    
    return num;
}
+ (uint32_t) uint64ToApsn:(uint64_t)num64{
    
    
        
    uint64_t numPurge = num64 & 0xFFFFFFFF00000000;
    if (numPurge != 0) return 0;//有溢出

    return (uint32_t)num64;
}


@end
