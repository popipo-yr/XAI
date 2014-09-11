//
//  XAIUser.m
//  XAI
//
//  Created by office on 14-4-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUser.h"
#import "XAIMQTTDEF.h"
#import "XAIData.h"

#include "XAIPacketStatus.h"


@implementation XAIUser

- (BOOL) isAdmin{

   return  _luid == XAIUSERADMIN;
}

#define _k_type 99

+ (NSArray*) readIM:(XAITYPELUID)meluid apsn:(XAITYPEAPSN)meapsn withLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn{
    
    
    
    NSMutableArray* msgs = [[NSMutableArray alloc] init];
    
    do {
        
        
        
        NSString* localFile = [XAIData getSavePathFile:
                               [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",meapsn,meluid,
                                apsn,luid,_k_type]];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSArray* oprAry = [[NSArray alloc] initWithContentsOfFile:localFile];
        
        if (oprAry == nil || [oprAry count] == 0) break;
        
        
        for (int i =0; i < [oprAry count]; i++) {
            
            NSDictionary* dic = [oprAry objectAtIndex:i];
            
            /*也可以通过类名获取*/
            
            XAIMeg* amsg = [[XAIMeg alloc] init];
            
            
            [amsg readFromDIC:dic];
            
            [msgs addObject:amsg];
        }
        
    } while (0);
    
    
    return msgs;

}

+ (BOOL) saveIM:(NSArray *)ary meLuid:(XAITYPELUID)meluid apsn:(XAITYPEAPSN)meapsn withLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn{

    BOOL isSuccess = false;
    
    do {
        
        NSString* localFile = [XAIData getSavePathFile:
                               [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",meapsn,meluid,
                                apsn,luid,_k_type]];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSMutableArray* msgs = [[NSMutableArray alloc] init];

        for (int i =0; i < [ary count]; i++) {
            
            XAIMeg* aMsg = [ary objectAtIndex:i];
            
            if (aMsg == nil && ![aMsg isKindOfClass:[XAIMeg class]]) continue;
            
            
            NSDictionary* dic = [aMsg writeToDIC];
            
            [msgs addObject:dic];
        }
        
        int maxMeg =  50;
        for (int i = [msgs count]; i > maxMeg; i--) {
            [msgs removeObjectAtIndex:0];
        }
        
        
        [msgs writeToFile:localFile atomically:YES];
        
        isSuccess = true;
        
        //记录未读的个数
        NSString* allNotReadKey = @"allNotReadKey";
        NSString* oneNotReadKey = [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",meapsn,meluid,
                                   apsn,luid,_k_type];
        
        int allNotRead = [[[NSUserDefaults standardUserDefaults] objectForKey:allNotReadKey] intValue];
        int oneNotRead = [[[NSUserDefaults standardUserDefaults] objectForKey:oneNotReadKey] intValue];
        
        allNotRead += 1;
        oneNotRead += 1;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:allNotRead] forKey:allNotReadKey];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:oneNotRead] forKey:oneNotReadKey];
        
    } while (0);
    
    
    return isSuccess;

}

- (void) getStatus{

    
    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                         luid:_luid
                                                        other:Key_DeviceStatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    

    [self performSelector:@selector(timeout) withObject:nil afterDelay:5.0];
}


+ (void) readIMEnd:(XAITYPELUID)meluid apsn:(XAITYPEAPSN)meapsn
          withLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn{

    //记录未读的个数
    NSString* allNotReadKey = @"allNotReadKey";
    NSString* oneNotReadKey = [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",meapsn,meluid,
                               apsn,luid,_k_type];
    
    int allNotRead = [[[NSUserDefaults standardUserDefaults] objectForKey:allNotReadKey] intValue];
    int oneNotRead = [[[NSUserDefaults standardUserDefaults] objectForKey:oneNotReadKey] intValue];
    
    allNotRead -= oneNotRead;
    oneNotRead = 0;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:allNotRead] forKey:allNotReadKey];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:oneNotRead] forKey:oneNotReadKey];

}

+ (int) countOfAllNotReadIMCount{

    //记录未读的个数
    NSString* allNotReadKey = @"allNotReadKey";
    
    int allNotRead = [[[NSUserDefaults standardUserDefaults] objectForKey:allNotReadKey] intValue];
    
    return allNotRead;
    
}
+ (int) countOfOneNotReadIMCount:(XAITYPELUID)meluid apsn:(XAITYPEAPSN)meapsn
                        withLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn{


    NSString* oneNotReadKey = [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",meapsn,meluid,
                               apsn,luid,_k_type];
    
    int oneNotRead = [[[NSUserDefaults standardUserDefaults] objectForKey:oneNotReadKey] intValue];
    
    return oneNotRead;
}



- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    if (size != 1) {
        return;
    }
    
    if (![topic isEqualToString:[MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DeviceStatusID]]) {
        

        return;
    }
    
    uint8_t status;
    memcpy(&status, datas, 1);
    
    if (status == 0) {
        _isOnline = false;
    }else{
        _isOnline = true;
    }
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topic];
}

- (void) timeout{

    _isOnline = false;
    
    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                         luid:_luid
                                                        other:Key_DeviceStatusID];
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
}

@end


#define _K_FromApsn @"_K_FromApsn"
#define _K_FromLuid @"_K_FromLuid"
#define _K_ToApsn @"_K_ToApsn"
#define _K_ToLuid @"_K_ToApsn"
#define _K_Date @"_K_Date"
#define _K_Context @"_K_Context"

@implementation XAIMeg

-(NSDictionary *)writeToDIC{

    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (_context != nil) {
        
        [dic setObject:_context forKey:_K_Context];
    }
    
    if (_date != nil) {
        [dic setObject:_date forKey:_K_Date];
    }
    
    [dic setObject:[NSNumber numberWithLong:_fromAPSN] forKey:_K_FromApsn];
    [dic setObject:[NSNumber numberWithLongLong:_fromLuid] forKey:_K_FromLuid];
    [dic setObject:[NSNumber numberWithLong:_toAPSN] forKey:_K_ToApsn];
    [dic setObject:[NSNumber numberWithLongLong:_toLuid] forKey:_K_ToLuid];


    return dic;
}

-(void)readFromDIC:(NSDictionary *)dic{
    
    if (dic == nil) return;
    
    _context = [dic objectForKey:_K_Context];
    _date = [dic objectForKey:_K_Date];
    _fromAPSN = [[dic objectForKey:_K_FromApsn] longValue];
    _fromLuid = [[dic objectForKey:_K_FromLuid] longLongValue];
    _toAPSN = [[dic objectForKey:_K_ToApsn] longValue];
    _toLuid = [[dic objectForKey:_K_ToLuid] longLongValue];
    

}

@end
