//
//  XAIDeviceService.m
//  XAI
//
//  Created by office on 14-4-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDeviceService.h"

#import "XAIPacketCtrl.h"
#import "XAIPacketACK.h"

#define 	AddDevID	5
#define	DelDevID	6
#define	AlterDevNameID	7

@implementation XAIDeviceService


- (void) addDev:(XAITYPELUID)luid  withName:(NSString*)devName{

    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* name_data = generatePacketParamData();
    
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID, sizeof(XAITYPELUID), &luid,name_data);
    xai_param_data_set(name_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [devName length], (void*)[devName UTF8String],NULL);
   
    
    
    xai_param_ctrl_set(param_ctrl, 1, 1, 1, 3, XAI_PKT_TYPE_CONTROL, 1, 1, AddDevID,
                       [[NSDate new] timeIntervalSince1970],
                       2, luid_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    NSString* topicStr = @"0x00000001/SERVER/0x0000000000000003/IN";
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:topicStr//[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    



}
- (void) delDev:(XAITYPELUID)luid{
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    //param
    _xai_packet_param_data* luid_data = generatePacketParamData();
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID, sizeof(XAITYPELUID), &luid,NULL);
    
    xai_param_ctrl_set(param_ctrl, 0, 1, 0, 1, 0, 0, 0, DelDevID, [[NSDate new] timeIntervalSince1970], 1, luid_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}
- (void) changeDev:(XAITYPELUID)luid withName:(NSString*)newName{

    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* name_data = generatePacketParamData();
    
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                       sizeof(XAI_DATA_TYPE_BIN_LUID), &luid, name_data);
    
    xai_param_data_set(name_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [newName length], (void*)[newName UTF8String],NULL);
    
    
    xai_param_ctrl_set(param_ctrl, 0, 1, 0, 3, 0, 0, 0, AlterDevNameID, [[NSDate new] timeIntervalSince1970],
                       2, luid_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}

#pragma mark -- MQTTPacketManagerDelegate

- (void) recivePacket:(void*)datas size:(int)size topic:topic{
    
    //test.....
    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    switch (ack->scid) {
        case AddDevID:{
            
            if (ack->err_no == 0) {
                
            }else{
                
                NSLog(@"FAILD ADD USER ");
            }
            
            [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topic];
        }
            
            break;
            
        default:
            break;
    }
    
    
    NSLog(@"anc");
    
}


@end
