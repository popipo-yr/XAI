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
#import "XAIPacketStatus.h"


#define AddUserID 1
#define	DelUserID        2
#define	AlterUserNameID  3
#define	AlterUserPWID  4


#define UserTableID 0x1



@implementation XAIUserService





- (void) addUser:(NSString*)username Password:(NSString*)password apsn:(XAITYPEAPSN) apsn{

    
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* apsn_data = generatePacketParamData();    
    _xai_packet_param_data* username_data = generatePacketParamData();
    _xai_packet_param_data* password_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN , sizeof(XAITYPEAPSN), &apsn, username_data);
    
    
     xai_param_data_set(username_data, XAI_DATA_TYPE_ASCII_TEXT,
                             [username length], (void*)[username UTF8String],password_data);
    
     xai_param_data_set(password_data, XAI_DATA_TYPE_ASCII_TEXT,
                             [password length], (void*)[password UTF8String],NULL);
    
    
     xai_param_ctrl_set(param_ctrl, 1, 1, 1, 3, XAI_PKT_TYPE_CONTROL, 10, 10, AddUserID,
                        [[NSDate new] timeIntervalSince1970],
                        3, apsn_data);
    
    
     _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    NSString* topicStr = @"0x00000001/SERVER/0x0000000000000003/IN";
    NSString* topicStr2 = @"0x00000001/MOBILES/0x0000000000000001/IN";
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr2];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:topicStr//[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    
    

}


- (void) delUser:(XAITYPELUID) luid apsn:(XAITYPEAPSN) apsn{

    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    //param
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN , sizeof(XAITYPEAPSN), &apsn_data, luid_data);
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID, sizeof(XAITYPELUID), &luid,NULL);
    
    xai_param_ctrl_set(param_ctrl, 0, 1, 0, 1, 0, 0, 0, DelUserID, [[NSDate new] timeIntervalSince1970], 2, apsn_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    

}


- (void) changeUser:(XAITYPELUID)luid withName:(NSString*)newUsername apsn:(XAITYPEAPSN) apsn{
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* username_data = generatePacketParamData();
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN , sizeof(XAITYPEAPSN), &apsn_data, luid_data);

    
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                            sizeof(XAI_DATA_TYPE_BIN_LUID), &luid, username_data);
    
    xai_param_data_set(username_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [newUsername length], (void*)[newUsername UTF8String],NULL);
    
    
    xai_param_ctrl_set(param_ctrl, 0, 1, 0, 3, 0, 0, 0, AlterUserNameID, [[NSDate new] timeIntervalSince1970],
                       3, apsn_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}
- (void) changeUser:(XAITYPELUID)luid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword apsn:(XAITYPEAPSN) apsn{

    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* oldPassword_data = generatePacketParamData();
    _xai_packet_param_data* newPassword_data = generatePacketParamData();
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN , sizeof(XAITYPEAPSN), &apsn_data, luid_data);

    
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                            sizeof(XAI_DATA_TYPE_BIN_LUID), &luid, oldPassword_data);

    
    xai_param_data_set(oldPassword_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [oldPassword length], (void*)[oldPassword UTF8String],newPassword_data);
    
    xai_param_data_set(newPassword_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [newPassword length], (void*)[newPassword UTF8String],NULL);

    
    
    xai_param_ctrl_set(param_ctrl, 0, 1, 0, 1, 0, 0, 0, AlterUserPWID, [[NSDate new] timeIntervalSince1970],
                       4, apsn_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:1 luid:1]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}


- (void) finderUserLuidHelper:(NSString*)username apsn:(XAITYPEAPSN) apsn{

    _usernameFind = username;
    
    NSString* topicStr = @"0x00000001/SERVER/0x0000000000000003/OUT/STATUS/0x01";
    [[MQTT shareMQTT].client subscribe:topicStr];

    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];

}



- (XAITYPELUID) finderUserLuidHelper:(NSString*)username paramStatus:(_xai_packet_param_status*) param{
    
    int realCount = param->data_count / 3;
    
    if ((0 != param->data_count % 3) || realCount < 1) {
        
        return -1;
    }
    
    for (int i = 0; i < realCount; i++) {
        
        BOOL find = FALSE;
        
        _xai_packet_param_data* data = getParamDataFromParamStatus(param, i*3 + 3 -1);
        if ((data->data_type == XAI_DATA_TYPE_ASCII_TEXT) || data->data_len > 0) {
            
            NSString* name = [[NSString alloc] initWithBytes:data->data length:data->data_len encoding:NSUTF8StringEncoding];
            
            if ([name isEqualToString:username]) {
                
                find = TRUE;
            }
        }
        
        if (find) {
            
            _xai_packet_param_data* luid_data = getParamDataFromParamStatus(param, i*3 + 2 -1);
            if ((data->data_type == XAI_DATA_TYPE_BIN_LUID) || data->data_len > 0) {
                
                XAITYPELUID luid;
                byte_data_copy(&luid, luid_data->data, sizeof(XAITYPELUID), luid_data->data_len);
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(findedUser:Luid:withName:)]) {
                    
                    [_delegate findedUser:YES Luid:luid withName:username];
                }
                
                return luid;
            }
            
        }
    }
    
    
    if ((nil != _delegate) && [_delegate respondsToSelector:@selector(findedUser:Luid:withName:)]) {
        
        [_delegate findedUser:false Luid:-1 withName:username];
    }
    
    return -1;
    
}

- (void) reciveACKPacket:(void*)datas size:(int)size topic:topic{

    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    if (ack == NULL) return;
    
    switch (ack->scid) {
        case AddUserID:{
            
            if (ack->err_no == 0) {
                
            }else{
                
                NSLog(@"FAILD ADD USER ");
            }
            
            //[[MQTT shareMQTT].packetManager removePacketManager:self withKey:topic];
        }
            
            break;
            
        default:
            break;
    }

    purgePacketParamACKAndData(ack);

}


- (void) reciveStatusPacket:(void*)datas size:(int)size topic:topic{
    
    _xai_packet_param_status* status = generateParamStatusFromData(datas, size);
    if (status == NULL) return;
    
    switch (status->oprId) {
        case UserTableID:
        {
            [self finderUserLuidHelper:_usernameFind paramStatus:status];
        
        
        }
            break;
            
        default:
            break;
    }
    
    purgePacketParamStatusAndData(status);
}


- (void) recivePacket:(void*)datas size:(int)size topic:topic{

    _xai_packet_param_normal* param = generateParamNormalFromData(datas, size);
    

    switch (param->flag) {
        case XAI_PKT_FLAG_ACK:{
            
            [self reciveACKPacket:datas size:size topic:topic];
        }
            
            break;
            
        case XAI_PKT_TYPE_STATUS:
        {
            [self reciveStatusPacket:datas size:size topic:topic];
            
        }break;
            
        default:
            break;
    }
    

    purgePacketParamNormal(param);
}



@end
