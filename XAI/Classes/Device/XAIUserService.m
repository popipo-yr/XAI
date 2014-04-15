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





- (void) addUser:(NSString*)username Password:(NSString*)password apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{

    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* apsn_data = generatePacketParamData();    
    _xai_packet_param_data* username_data = generatePacketParamData();
    _xai_packet_param_data* password_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN , sizeof(XAITYPEAPSN), &apsn, username_data);
    
    
     xai_param_data_set(username_data, XAI_DATA_TYPE_ASCII_TEXT,
                             [username length], (void*)[username UTF8String],password_data);
    
     xai_param_data_set(password_data, XAI_DATA_TYPE_ASCII_TEXT,
                             [password length], (void*)[password UTF8String],NULL);
    
    
     xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, apsn , luid, XAI_PKT_TYPE_CONTROL, 0, 0,
                        AddUserID,[[NSDate new] timeIntervalSince1970], 3, apsn_data);
    
    
     _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    NSString* ctrlTopic =  [MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid];
    //@"0x00000001/SERVER/0x0000000000000003/IN";
    //@"0x00000001/MOBILES/0x0000000000000001/IN";
    
    //[[MQTT shareMQTT].packetManager addPacketManager:self withKey:ackTopic];
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:ctrlTopic
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    
    

}


- (void) delUser:(XAITYPELUID) uluid apsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid{

    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    //param
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN , sizeof(XAITYPEAPSN), &apsn, luid_data);
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID, sizeof(XAITYPELUID), &uluid,NULL);
    
    xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, apsn, luid, XAI_PKT_TYPE_CONTROL, 0, 0,
                       DelUserID, [[NSDate new] timeIntervalSince1970], 2, apsn_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    

}


- (void) changeUser:(XAITYPELUID)uluid withName:(NSString*)newUsername
               apsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid{
    
    MQTT* cur_MQTT = [MQTT shareMQTT];

    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* username_data = generatePacketParamData();
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN,
                       sizeof(XAITYPEAPSN), &apsn, luid_data);

    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                            sizeof(XAITYPELUID), &uluid, username_data);
    
    xai_param_data_set(username_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [newUsername length], (void*)[newUsername UTF8String],NULL);
    
    
    xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, apsn, luid, XAI_PKT_TYPE_CONTROL, 0, 0,
                       AlterUserNameID, [[NSDate new] timeIntervalSince1970],3, apsn_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}
- (void) changeUser:(XAITYPELUID)uluid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword
               apsn:(XAITYPEAPSN) apsn  luid:(XAITYPELUID)luid{

    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* oldPassword_data = generatePacketParamData();
    _xai_packet_param_data* newPassword_data = generatePacketParamData();
   
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN,
                       sizeof(XAITYPEAPSN), &apsn, luid_data);

    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                            sizeof(XAITYPELUID), &uluid, oldPassword_data);

    xai_param_data_set(oldPassword_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [oldPassword length], (void*)[oldPassword UTF8String],newPassword_data);
    
    xai_param_data_set(newPassword_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [newPassword length], (void*)[newPassword UTF8String],NULL);

    
    
    xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, apsn, luid, XAI_PKT_TYPE_CONTROL, 0, 0x22,
                       AlterUserPWID, [[NSDate new] timeIntervalSince1970], 4, apsn_data);
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}


- (void) finderUserLuidHelper:(NSString*)username apsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid{

    _usernameFind = username;
    
    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:apsn luid:luid other:MQTTCover_UserTable_Other];
    //@"0x00000001/SERVER/0x0000000000000003/OUT/STATUS/0x01";
    
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
            if ((luid_data->data_type == XAI_DATA_TYPE_BIN_LUID) || luid_data->data_len > 0) {
                
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

//- (void) ackVerify:(int) err_no proSelect:(SEL) proSel{
//
//    if (err_no == 0) {
//        
//        if ((nil != _delegate) && [_delegate respondsToSelector:proSel]) {
//            
//            [_delegate performSelector:proSel withObject:[NSNumber numberWithBool:TRUE]];
//            
//        }
//        
//    }else{
//        
//        if ((nil != _delegate) && [_delegate respondsToSelector:@selector(addUser:)]) {
//            
//            [_delegate performSelector:proSel withObject:[NSNumber numberWithBool:FALSE]];
//        }
//        
//        
//        NSLog(@"FAILD ADD USER - %d", err_no);
//    }
//    
//    [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
//    
//    
//
//}

- (void) reciveACKPacket:(void*)datas size:(int)size topic:topic{

    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    if (ack == NULL) return;
    
    switch (ack->scid) {
        case AddUserID:{
            
            if (ack->err_no == 0) {
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(addUser:)]) {
                    
                    [_delegate addUser:YES];
                }
                
            }else{
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(addUser:)]) {
                    
                    [_delegate addUser:FALSE];
                }

                
                NSLog(@"FAILD ADD USER - %d", ack->err_no);
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            
        }break;
            
        case DelUserID:{
        
            if (ack->err_no == 0) {
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(delUser:)]) {
                    
                    [_delegate delUser:YES];
                }
                
            }else{
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(delUser:)]) {
                    
                    [_delegate delUser:FALSE];
                }
                
                
                NSLog(@"FAILD DEL USER - %d", ack->err_no);
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        
        }break;
            
        case AlterUserNameID:{
            
            if (ack->err_no == 0) {
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(changeUserName:)]) {
                    
                    [_delegate changeUserName:YES];
                }
                
            }else{
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(changeUserName:)]) {
                    
                    [_delegate changeUserName:FALSE];
                }
                
                
                NSLog(@"FAILD CHANGE_USER_NAME USER - %d", ack->err_no);
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        
        
        }break;
            
        case AlterUserPWID:{
            
            
            if (ack->err_no == 0) {
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(changeUserPassword:)]) {
                    
                    [_delegate changeUserPassword:YES];
                }
                
            }else{
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(changeUserPassword:)]) {
                    
                    [_delegate changeUserPassword:FALSE];
                }
                
                
                NSLog(@"FAILD CHANGE_USER_PWD USER - %d", ack->err_no);
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        
        
        }break;
            
            
            
        default:break;
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
        
        
        }break;
            
        default:break;
    }
    
    purgePacketParamStatusAndData(status);
}


- (void) recivePacket:(void*)datas size:(int)size topic:topic{

    _xai_packet_param_normal* param = generateParamNormalFromData(datas, size);
    

    switch (param->flag) {
        case XAI_PKT_FLAG_ACK_CONTROL:{
            
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
