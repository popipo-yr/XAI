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

    //return true;
   return  _luid == XAIUSERADMIN;
}

#define _k_type 99



- (NSArray*) readIMWithLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn;{
    

    
    NSMutableArray* msgs = [[NSMutableArray alloc] init];
    
    do {
        
        
        
        NSString* localFile = [XAIData getSavePathFile:
                               [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",_apsn,_luid,
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

- (BOOL) saveIM:(NSArray*)ary withLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn{

    BOOL isSuccess = false;
    
    do {
        
        NSString* localFile = [XAIData getSavePathFile:
                               [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",
                                _apsn,_luid,
                                apsn,luid,_k_type]];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSMutableArray* msgs = [[NSMutableArray alloc] init];

        for (int i =0; i < [ary count]; i++) {
            
            XAIMeg* aMsg = [ary objectAtIndex:i];
            
            if (aMsg == nil && ![aMsg isKindOfClass:[XAIMeg class]]) continue;
            
            
            NSDictionary* dic = [aMsg writeToDIC];
            
            [msgs addObject:dic];
        }
        
        int maxMeg =  100;
        for (int i = [msgs count]; i > maxMeg; i--) {
            [msgs removeObjectAtIndex:0];
        }
        
        
        [msgs writeToFile:localFile atomically:YES];
        
        isSuccess = true;
        
        //记录未读的个数
        NSString* oneNotReadKey = [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",
                                   _apsn,_luid,
                                   apsn,luid,_k_type];
        
        int oneNotRead = [[[NSUserDefaults standardUserDefaults] objectForKey:oneNotReadKey] intValue];
        
        oneNotRead += 1;
        
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


- (void) readIMEndLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn{

    //记录未读的个数
    NSString* oneNotReadKey = [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",
                               _apsn,_luid,
                               apsn,luid,_k_type];
    
    int oneNotRead = [[[NSUserDefaults standardUserDefaults] objectForKey:oneNotReadKey] intValue];
    
    oneNotRead = 0;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:oneNotRead] forKey:oneNotReadKey];

}


- (int) countOfOneNotReadIMCountWithLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn;
{


    NSString* oneNotReadKey = [NSString stringWithFormat:@"%u-%llu-%u-%llu-%d.plist",
                               _apsn,_luid,
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
#define _K_Ctrls @"_K_Ctrls"
#define _K_Type @"_K_type"

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
    [dic setObject:[NSNumber numberWithInt:_type] forKey:_K_Type];
    
    NSMutableArray* writeAry = [[NSMutableArray alloc] init];

    for (XAIMegCtrlInfo* aCtrl in _ctrlInfo) {
        if ([aCtrl isKindOfClass:[XAIMegCtrlInfo class]]) {
            
            [writeAry addObject:[aCtrl writeToDIC]];
        }
    }
    
    [dic setObject:writeAry forKey:_K_Ctrls];


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
    _type = [[dic objectForKey:_K_Type] intValue];
    
    NSMutableArray* ctrls  = [[NSMutableArray alloc] init];
    
    NSArray* ctrlInfos = [dic objectForKey:_K_Ctrls];
    for (NSDictionary* dic in ctrlInfos) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            XAIMegCtrlInfo* ctrl = [[XAIMegCtrlInfo alloc] init];
            [ctrl readFromDIC:dic];
            [ctrls addObject:ctrl];
        }
    }
    
    _ctrlInfo = [NSArray arrayWithArray:ctrls];
    
}

@end


@implementation XAIMegCtrlInfo

#define _K_Topic @"_K_Topic"
#define _K_ActionData @"_K_Data"
#define _K_Name @"_K_Name"
#define _K_Date @"_K_Date"


-(NSDictionary *)writeToDIC{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (_topic != nil) {
        
        [dic setObject:_topic forKey:_K_Topic];
    }
    
    if (_actionData != nil) {
        [dic setObject:_actionData forKey:_K_ActionData];
    }
    
    if (_name != nil) {
        [dic setObject:_name forKey:_K_Name];
    }
    
    if (_date != nil) {
        [dic setObject:_date forKey:_K_Date];
    }
    
    
    return dic;
}

-(void)readFromDIC:(NSDictionary *)dic{
    
    if (dic == nil) return;
    
    _topic  = [dic objectForKey:_K_Topic];
    _actionData = [dic objectForKey:_K_ActionData];
    _name = [dic objectForKey:_K_Name];
    _date = [dic objectForKey:_K_Date];

}



@end
