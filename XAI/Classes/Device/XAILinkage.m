//
//  XAILinkage.m
//  XAI
//
//  Created by office on 14-6-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkage.h"
#import "XAIPacketNormal.h"
#import "MQTT.h"


@implementation XAILinkage

-(instancetype)init{

    if (self = [super init]) {
        _condInfos = [[NSMutableArray alloc]init];
        _resultInfos = [[NSMutableArray alloc]init];
    }
    
    return self;
}


//- (void) getDetailInfo{
//    
//    
//    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
//                                                         luid:_luid
//                                                        other:MQTTCover_LinkageTable_Other];
//    
//    [[MQTT shareMQTT].client subscribe:topicStr];
//    
//    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
//
//
//    
//}

@end
