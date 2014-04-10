//
//  APServer.m
//  XAI
//
//  Created by office on 14-4-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "APServerNode.h"
#import "XAIPacketCtrl.h"
@implementation APServerNode

- (void) addUser:(NSString*)username Password:(NSString*)password{

    _xai_packet_param_ctrl*  ctrl_param = generatePacketParamCtrl();
    
    
    //设置所有的信息
    
    //ctrl_param->normal_param->from_guid = "abc";
    
    _xai_packet* packet = generatePacketCtrl(ctrl_param);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size toTopic:@"abc" withQos:0 retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(ctrl_param);
    
}

@end
