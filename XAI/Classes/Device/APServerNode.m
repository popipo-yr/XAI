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


    
    
    uint32_t from_guid_apsn = 0;
    uint64_t from_guid_luid = 1;
    void* from = malloc(12);
    memset(from, 0, 12);

    memcpy(from, &from_guid_apsn , 4);
    memcpy(from +4, &from_guid_luid, 8);
    
    
    uint32_t to_guid_apsn = 0;
    uint64_t to_guid_luid = 1;
    void* to = malloc(12);
    memset(to, 0, 12);
    
    memcpy(to, &to_guid_apsn , 4);
    memcpy(to +4, &to_guid_luid, 8);
    
    
    
//    NSString *from_guid = @"/0/mobile/0";
//    NSString *to_guid = @"/0/server/3";
    
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_ctrl_data* username_data = generatePacketParamCtrlData();
    _xai_packet_param_ctrl_data* password_data = generatePacketParamCtrlData();
    
    username_data->data_len = [username length];
    username_data->data_type = 13;
    byte_data_set(&username_data->data, [username UTF8String], [username length]);
    
    password_data->data_len = [password length];
    password_data->data_type = 13;
    byte_data_set(&password_data->data, [password UTF8String], [password length]);
    
    username_data->next = password_data;

    param_ctrl->data = username_data;
    
    
    
    byte_data_copy(param_ctrl->normal_param->from_guid, from,
                   sizeof(param_ctrl->normal_param->from_guid), 12);
    byte_data_copy(param_ctrl->normal_param->to_guid, to,
                   sizeof(param_ctrl->normal_param->to_guid), 12);
    
    param_ctrl->normal_param->flag  = 0;
    param_ctrl->normal_param->msgid = 0;
    param_ctrl->normal_param->magic_number = 0;
    param_ctrl->normal_param->length  =  _XPPS_C_FIXED_ALL + 2*_XPPS_CD_FIXED_ALL
    + username_data->data_len + password_data->data_len;
    
    
    param_ctrl->oprId = 1;
    param_ctrl->time = [[NSDate new] timeIntervalSince1970];
    
    param_ctrl->data_count = 2;
    
    
    _xai_packet* packet = generatePacketCtrl(param_ctrl);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover devCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    
}

@end
