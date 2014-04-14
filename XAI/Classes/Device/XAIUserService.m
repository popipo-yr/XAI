//
//  XAIUserService.m
//  XAI
//
//  Created by office on 14-4-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUserService.h"
#import "XAIPacketCtrl.h"
#import "XAIPacketACK.h"


#define AddUserID 1
#define	DelUser        2
#define	AlterUserName  3
#define	AlterUserPW  4
#define	AddDev  5
#define	DelDev  6
#define	AlterDevName 7


@implementation XAIUserService





- (void) addUser:(NSString*)username Password:(NSString*)password{

    
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* username_data = generatePacketParamData();
    _xai_packet_param_data* password_data = generatePacketParamData();
    
    
     xai_param_data_set(username_data, XAI_DATA_TYPE_ASCII_TEXT,
                             [username length], (void*)[username UTF8String],password_data);
    
     xai_param_data_set(password_data, XAI_DATA_TYPE_ASCII_TEXT,
                             [password length], (void*)[password UTF8String],NULL);
    
    
     xai_param_ctrl_set(param_ctrl, 1, 1, 1, 3, XAI_PKT_TYPE_CONTROL, 1, 1, AddUserID,
                        [[NSDate new] timeIntervalSince1970],
                        2, username_data);
    
    
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


- (void) delUser:(XAITYPELUID) luid{

    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    //param
    _xai_packet_param_data* luid_data = generatePacketParamData();
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID, sizeof(XAITYPELUID), &luid,NULL);
    
    xai_param_ctrl_set(param_ctrl, 0, 1, 0, 1, 0, 0, 0, DelUser, [[NSDate new] timeIntervalSince1970], 1, luid_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    

}


- (void) changeUser:(XAITYPELUID)luid withName:(NSString*)newUsername{
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* username_data = generatePacketParamData();
    
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                            sizeof(XAI_DATA_TYPE_BIN_LUID), &luid, username_data);
    
    xai_param_data_set(username_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [newUsername length], (void*)[newUsername UTF8String],NULL);
    
    
    xai_param_ctrl_set(param_ctrl, 0, 1, 0, 3, 0, 0, 0, AddUserID, [[NSDate new] timeIntervalSince1970],
                       2, luid_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}
- (void) changeUser:(XAITYPELUID)luid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword{

    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* oldPassword_data = generatePacketParamData();
    _xai_packet_param_data* newPassword_data = generatePacketParamData();
    
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                            sizeof(XAI_DATA_TYPE_BIN_LUID), &luid, oldPassword_data);

    
    xai_param_data_set(oldPassword_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [oldPassword length], (void*)[oldPassword UTF8String],newPassword_data);
    
    xai_param_data_set(newPassword_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [newPassword length], (void*)[newPassword UTF8String],NULL);

    
    
    xai_param_ctrl_set(param_ctrl, 0, 1, 0, 1, 0, 0, 0, AddUserID, [[NSDate new] timeIntervalSince1970],
                       2, luid_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}



- (void) recivePacket:(void*)datas size:(int)size topic:topic{

    //test.....
    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    switch (ack->scid) {
        case AddUserID:{
        
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
