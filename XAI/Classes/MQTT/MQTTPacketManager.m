//
//  MQTTPacketManager.m
//  XAI
//
//  Created by mac on 14-4-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTTPacketManager.h"
#import "MQTT.h"
#import "MQTTCover.h"

#define _K_Normal_Obj @"obj"
#define _K_Normal_Key @"key"

@implementation MQTTPacketManager

- (id) init{

    if (self = [super init]) {
        
        _delegates = [[NSMutableDictionary alloc] init];
        _allDelegate = [[NSMutableArray alloc] init];
        _forceRemove = [[NSMutableArray alloc] init];
        _normalRemove = [[NSMutableArray alloc] init];
        _normalAdd = [[NSMutableArray alloc] init];
        
        _isPostMsg = false;
        
        self.connectDelegate = NULL;
    }
    
    return self;
}

- (void) addPacketManagerACK: (NSObject*) aPro{

    [self addPacketManager:aPro withKey:[MQTTCover mobileCtrTopicWithAPNS:[MQTT shareMQTT].apsn
                                                                     luid:[MQTT shareMQTT].luid]];

}

- (void) removePacketManagerACK: (NSObject*) aPro{

    
    
    [self removePacketManager:aPro withKey:[MQTTCover mobileCtrTopicWithAPNS:[MQTT shareMQTT].apsn
                                                                     luid:[MQTT shareMQTT].luid]];

}

- (void) addPacketManager: (NSObject*) aPro withKey:(NSString*)key{
    
    if (![aPro conformsToProtocol:@protocol(MQTTPacketManagerDelegate)]) {
        return;
    }
    /*if refres  count is zero, add it then set the refres to one，
     if refres count is bigger than zero, plus the refres count*/
    
    /*pro info is dictionary not classs ,*/
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:aPro,_K_Normal_Obj
                         ,key,_K_Normal_Key,nil];
    
    [_normalAdd addObject:dic];

}


- (void) normalAddHelper{
    
    
    for (NSDictionary* aDic in _normalAdd) {
        
        [self normalAddOne:[aDic objectForKey:_K_Normal_Obj] key:[aDic objectForKey:_K_Normal_Key]];
    }
    
    [_normalAdd removeAllObjects];
}

- (void) normalAddOne:(NSObject*)aPro key:(NSString*)key{
    
    if (aPro == nil || key == nil) {
        return;
    }
    
    
    NSMutableArray* proAry = [_delegates objectForKey:key];
    
    if (nil == proAry) {
        
        proAry = [[NSMutableArray alloc] init];
        [_delegates setObject:proAry forKey:key];
    }
    
    
    MQTTPacketManagerDelgInfo* oneProInfo = nil;
    BOOL bFind = false;
    
    for (int i = 0; i < [proAry count]; i++) {
        
        oneProInfo = [proAry objectAtIndex:i];
        
        if ([oneProInfo isKindOfClass:[MQTTPacketManagerDelgInfo class]]
            && oneProInfo.refObj == aPro) {
            
            bFind = true;
            break;
        }
    }
    
    
    if (!bFind) {
        
        oneProInfo = [[MQTTPacketManagerDelgInfo alloc] init];
        [proAry addObject:oneProInfo];
        
    }
    
    
    if (!bFind) {
        
        
        oneProInfo.refObj = aPro;
        oneProInfo.refrenceCount = 0;
        
    }else{
        
        
        if (oneProInfo.refrenceCount < 0) {/*错误的数据*/
            
            oneProInfo.refrenceCount = 0;
            
        }
    }
    
    
    oneProInfo.refrenceCount += 1;

    
}



- (void) removePacketManager: (NSObject*) aPro  withKey:(NSString*)key{
    
    XSLog(@"rmoveeeeeeeeeee");
    if (![aPro conformsToProtocol:@protocol(MQTTPacketManagerDelegate)]) {
        return;
    }
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:aPro,_K_Normal_Obj
                         ,key,_K_Normal_Key,nil];
    
    [_normalRemove addObject:dic];
    
    /*only  remove reference count,but when it's zero remove obj*/
}



- (void) normalRemoveHelper{
    
    NSArray* remove = [NSArray arrayWithArray:_normalRemove];
    [_normalRemove removeAllObjects];
    
    for (NSDictionary* aDic in remove) {
        
        [self normalRemoveOne:[aDic objectForKey:_K_Normal_Obj] key:[aDic objectForKey:_K_Normal_Key]];
    }
    
}

- (void) normalRemoveOne:(NSObject*)aPro key:(NSString*)key{
    
    if (aPro == nil || key == nil) {
        return;
    }
    
    NSMutableArray* proAry = [_delegates objectForKey:key];
    if (nil == proAry) return;
    
    BOOL isLast =  false;
    if ([proAry count] == 1) {
        isLast = true;
    }
    
    MQTTPacketManagerDelgInfo* oneProInfo = nil;
    BOOL bFind = false;
    for (int i = 0; i < [proAry count]; i++) {
        
        oneProInfo = [proAry objectAtIndex:i];
        
        if ([oneProInfo isKindOfClass:[MQTTPacketManagerDelgInfo class]]
            && oneProInfo.refObj == aPro) {
            
            bFind = true;
            break;
        }
    }
    
    
    if (!bFind) return;
    
    oneProInfo.refrenceCount -= 1;
    
    if (oneProInfo.refrenceCount <  1) {
        
        oneProInfo.refObj = nil;
        [proAry removeObject:oneProInfo];
        
        if (isLast) { //no focus  remove topic
            //[[MQTT shareMQTT].client unsubscribe:key];
        }
        
    }
}

/*force remove delegate*/
- (void) forceRemovePacketManager:(NSObject*)aPro{
    
    if ([aPro conformsToProtocol:@protocol(MQTTPacketManagerDelegate)]) {
        [_forceRemove addObject:aPro];
    }
    
}


- (void) forceRemoveHelper{

    for (NSObject* aPro in _forceRemove) {
        
        [self forceRemoveOne:aPro];
    }
    
    [_forceRemove removeAllObjects];
}

- (void) forceRemoveOne:(NSObject*)aPro{
    
    XSLog(@"focue-remove");
    
    NSArray* allKey =[_delegates allKeys];
    
    for (int i = 0;  i < [allKey count]; i++) {
        
        NSMutableArray* proAry = [_delegates objectForKey:[allKey objectAtIndex:0]];
        
        MQTTPacketManagerDelgInfo* oneProInfo = nil;
        BOOL bFind = false;
        for (int i = 0; i < [proAry count]; i++) {
            
            oneProInfo = [proAry objectAtIndex:i];
            
            if ([oneProInfo isKindOfClass:[MQTTPacketManagerDelgInfo class]]
                && oneProInfo.refObj == aPro) {
                
                bFind = true;
                break;
            }
        }
        
        if (bFind) {
            
            [proAry removeObject:oneProInfo];
        }
    }
    
    
}


- (void) addPacketManagerNoAccept:(id<MQTTPacketManagerDelegate>)aPro{

    [_allDelegate addObject:aPro];
}


- (void) removePacketManagerNoAccept:(id<MQTTPacketManagerDelegate>)aPro{

    [_allDelegate removeObject:aPro];
}

- (void) change{
    
    if (_isPostMsg) {
        XSLog(@"fuccccccc");
        return;
    }
    
    XSLog(@"change ....");

    [self normalRemoveHelper];
    [self forceRemoveHelper];
    [self normalAddHelper];
}

#pragma mark -----------------------
#pragma mark MosquittoClientDelegate
- (void) didReceiveMessage:(MosquittoMessage*) mosq_msg {
    
    [self change];
    
//    size_t size = mosq_msg.payloadlen;
//    void* datas = malloc(sizeof(size));
//    memcpy(datas,[mosq_msg getPayloadbyte] , size);
//    NSString* topic = [[NSString alloc] initWithString:mosq_msg.topic];
    
//    [self performSelectorOnMainThread:@selector(didReceiveMessageMainT:) withObject:mosq_msg waitUntilDone:YES];

    _isPostMsg = true;
    
    NSMutableArray*  delegeteAry  = [[NSMutableArray alloc] initWithArray:[_delegates objectForKey:mosq_msg.topic]];
    
    if ([MQTTCover isMobileTopic:mosq_msg.topic]) {
        NSString* topicAll = [MQTTCover mobileAllCtrTopicWithAPNS:[MQTT shareMQTT].tmpApsn];
        [delegeteAry addObjectsFromArray:[_delegates objectForKey:topicAll]];
    }
    
    for (int i = 0; i < [delegeteAry count]; i++) {
        
        //XSLog(@"innnnnnnnnnn");
        
        MQTTPacketManagerDelgInfo* delgInfo = [delegeteAry objectAtIndex:i];
        if (delgInfo != NULL
            && delgInfo.refObj != NULL
            && [delgInfo isKindOfClass:[MQTTPacketManagerDelgInfo class]]
            && [delgInfo.refObj respondsToSelector:@selector(recivePacket:size:topic:)]) {
            
            [(id <MQTTPacketManagerDelegate>)delgInfo.refObj recivePacket:[mosq_msg getPayloadbyte] size:mosq_msg.payloadlen topic:mosq_msg.topic];
            
            //[delgInfo.refObj recivePacket:datas size:size topic:topic];
        }
    }
    
//    free(datas);
    
    
    /*没有人接受*/
    if ([delegeteAry count] == 0) {
        
        /*通知接受全部的消息*/
        for (int i = 0; i < [_allDelegate count]; i++) {
            
            id<MQTTPacketManagerDelegate> apro = [_allDelegate objectAtIndex:i];
            if (apro != NULL
                && [apro conformsToProtocol:@protocol(MQTTPacketManagerDelegate)]
                && [apro respondsToSelector:@selector(recivePacket:size:topic:)]) {
                
                [apro recivePacket:[mosq_msg getPayloadbyte] size:mosq_msg.payloadlen topic:mosq_msg.topic];
            }
            
        }

    }
    
    _isPostMsg = false;
    
    //[self change];
}

- (void) didConnect:(NSUInteger)code {
    
    
    /*订阅主题*/
    MQTT* curMQTT = [MQTT shareMQTT];
    
    if (curMQTT.isLogin) {
        
//        [curMQTT.client subscribe:[MQTTCover serverStatusTopicWithAPNS:curMQTT.apsn
//                                                                  luid:MQTTCover_LUID_Server_03]];
//        
//        [curMQTT.client subscribe:[MQTTCover mobileCtrTopicWithAPNS:curMQTT.apsn luid:curMQTT.luid]];
    }

    if (_connectDelegate != nil && [_connectDelegate respondsToSelector:@selector(didConnect:)]) {
         [_connectDelegate didConnect:code];
    }
    
   
    
}

- (void) didDisconnect {
    
    if (_connectDelegate != nil && [_connectDelegate respondsToSelector:@selector(didDisconnect)]) {
        [_connectDelegate didDisconnect];
    }
}

- (void) didDisconnect:(NSUInteger)rc {
    
    if (_connectDelegate != nil && [_connectDelegate respondsToSelector:@selector(didDisconnect:)]) {
        [_connectDelegate didDisconnect:rc];
    }
}




- (void) didPublish: (NSUInteger)messageId {}
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos {}
- (void) didUnsubscribe: (NSUInteger)messageId {}


@end

@implementation MQTTPacketManagerDelgInfo

@end
