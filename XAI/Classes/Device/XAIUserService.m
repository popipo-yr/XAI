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

#define PushTokenID 8


#define UserTableID 0x1



@implementation XAIUserService



- (void) addUser:(NSString*)username Password:(NSString*)password apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{

    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* apsn_data = generatePacketParamData();    
    _xai_packet_param_data* username_data = generatePacketParamData();
    _xai_packet_param_data* password_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_APSN , sizeof(XAITYPEAPSN), &apsn, username_data);
    
    
     NSData* data = [username dataUsingEncoding:NSUTF8StringEncoding];
     xai_param_data_set(username_data, XAI_DATA_TYPE_ASCII_TEXT,
                             [data length], (void*)[username UTF8String],password_data);
    
     NSData* paswddata = [password dataUsingEncoding:NSUTF8StringEncoding];
     xai_param_data_set(password_data, XAI_DATA_TYPE_ASCII_TEXT,
                             [paswddata length], (void*)[password UTF8String],NULL);
    
    
     xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, apsn , luid, XAI_PKT_TYPE_CONTROL, 0, 0,
                        AddUserID,[[NSDate new] timeIntervalSince1970], 3, apsn_data);
    
    
     _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    NSString* ctrlTopic =  [MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid];
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:ctrlTopic
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    
    
    _devOpr = XAIUserServiceOpr_add;
    _DEF_XTO_TIME_Start

}


- (void) delUser:(XAITYPELUID) uluid apsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid{

    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    //param
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_APSN , sizeof(XAITYPEAPSN), &apsn, luid_data);
    
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
    

    _devOpr = XAIUserServiceOpr_del;
    _DEF_XTO_TIME_Start
}


- (void) changeUser:(XAITYPELUID)uluid withName:(NSString*)newUsername
               apsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid{
    
    MQTT* cur_MQTT = [MQTT shareMQTT];

    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* username_data = generatePacketParamData();
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_APSN,
                       sizeof(XAITYPEAPSN), &apsn, luid_data);

    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                            sizeof(XAITYPELUID), &uluid, username_data);
    
     NSData* data = [newUsername dataUsingEncoding:NSUTF8StringEncoding];
    xai_param_data_set(username_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [data length], (void*)[newUsername UTF8String],NULL);
    
    
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
    
    _devOpr = XAIUserServiceOpr_changeName;
    _DEF_XTO_TIME_Start


}
- (void) changeUser:(XAITYPELUID)uluid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword
               apsn:(XAITYPEAPSN) apsn  luid:(XAITYPELUID)luid{

    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* oldPassword_data = generatePacketParamData();
    _xai_packet_param_data* newPassword_data = generatePacketParamData();
   
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_APSN,
                       sizeof(XAITYPEAPSN), &apsn, luid_data);

    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                            sizeof(XAITYPELUID), &uluid, oldPassword_data);

     NSData* oldpdata = [oldPassword dataUsingEncoding:NSUTF8StringEncoding];
    xai_param_data_set(oldPassword_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [oldpdata length], (void*)[oldPassword UTF8String],newPassword_data);
    
     NSData* newpdata = [newPassword dataUsingEncoding:NSUTF8StringEncoding];
    xai_param_data_set(newPassword_data, XAI_DATA_TYPE_ASCII_TEXT,
                            [newpdata length], (void*)[newPassword UTF8String],NULL);

    
    
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
    
    
    _devOpr = XAIUserServiceOpr_changePSWD;
    _DEF_XTO_TIME_Start


}


- (void) pushToken:(void*)token size:(size_t)size user:(XAITYPELUID)uluid apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{
    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* token_data = generatePacketParamData();
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID , sizeof(XAITYPELUID), &uluid, token_data);
    xai_param_data_set(token_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN, size, token, NULL);
    
    
    xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, apsn , luid, XAI_PKT_TYPE_CONTROL, 0, 0,
                       PushTokenID,[[NSDate new] timeIntervalSince1970], 2, luid_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    NSString* ctrlTopic =  [MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid];
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:ctrlTopic
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    
    
    _devOpr = XAIUserServiceOpr_push;
    _DEF_XTO_TIME_Start
    
    
}


- (void) finderUserLuidHelper:(NSString*)username apsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid{

    _usernameFind = [[NSString alloc] initWithString:username];
    findingAUser = TRUE;
    
    [self finderAllUserApsn:apsn luid:luid];
    
    _devOpr = XAIUserServiceOpr_find;
    _DEF_XTO_TIME_Start

}

- (void) finderAllUserApsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid{

    
    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:apsn luid:luid other:MQTTCover_UserTable_Other];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    if (!findingAUser) {
        
        _devOpr = XAIUserServiceOpr_findAll;
        _DEF_XTO_TIME_Start
    }
    
}



- (XAITYPELUID) finderUserLuidHelper:(NSString*)username paramStatus:(_xai_packet_param_status*) param{
    
    int usrParamCout = 4; /*每个有4个参数*/
    
    int realCount = param->data_count / usrParamCout;
    
    if ((0 != param->data_count % usrParamCout) || realCount < 1) {
        
        if (findingAUser) {
            
            if ((nil != _userServiceDelegate) &&
                [_userServiceDelegate respondsToSelector:@selector(userService:findedUser:withName:status:errcode:)]) {
                
                [_userServiceDelegate userService:self findedUser:0 withName:nil  status:false  errcode:XAI_ERROR_UNKOWEN];
            }
            
            findingAUser = FALSE;
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_find);
            
        }
        
        if ((nil != _userServiceDelegate) &&
            [_userServiceDelegate respondsToSelector:@selector(userService:findedAllUser:status:errcode:)]) {
            
            [_userServiceDelegate userService:self findedAllUser:nil status:false errcode:XAI_ERROR_UNKOWEN];
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_findAll);
        }

        return -1;
    }
    
    NSMutableSet* users = [[NSMutableSet alloc] init];
    
    BOOL find = FALSE;
    
    for (int i = 0; i < realCount; i++) {
        
        BOOL findName = FALSE;
        
        _xai_packet_param_data* data = getParamDataFromParamStatus(param, i*usrParamCout + 2);
        if (data == NULL || (data->data_type != XAI_DATA_TYPE_ASCII_TEXT) || data->data_len <= 0)
            break;
        
        NSString* name = [[NSString alloc] initWithBytes:data->data length:data->data_len encoding:NSUTF8StringEncoding];
        
        //name = [[NSString alloc] initWithUTF8String:data->data];
        
        if (findingAUser && !find && [name isEqualToString:username]) {
            
            findName = TRUE;
        }
        
        
        
        
        _xai_packet_param_data* luid_data = getParamDataFromParamStatus(param, i*usrParamCout + 1);
        if (luid_data == NULL || (luid_data->data_type != XAI_DATA_TYPE_BIN_LUID) || luid_data->data_len <= 0) break;
        
        XAITYPELUID luid;
        byte_data_copy(&luid, luid_data->data, sizeof(XAITYPELUID), luid_data->data_len);
        
        if (findingAUser && !find && findName) {
            
            if ((nil != _userServiceDelegate) &&
                [_userServiceDelegate respondsToSelector:@selector(userService:findedUser:withName:status:errcode:)]) {
                
                [_userServiceDelegate userService:self findedUser:luid withName:username  status:YES errcode:XAI_ERROR_NONE];
            }
            
            find = YES;
            findingAUser = FALSE;
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_find);
        }
        
        
        _xai_packet_param_data* apsn_data = getParamDataFromParamStatus(param, i*usrParamCout + 0);
        if (apsn_data == NULL || (apsn_data->data_type != XAI_DATA_TYPE_BIN_APSN) || apsn_data->data_len <= 0) break;
        
        XAITYPEAPSN apsn;
        byte_data_copy(&apsn, apsn_data->data, sizeof(XAITYPEAPSN), apsn_data->data_len);
        
        
        XAIUser* aUser = [[XAIUser alloc] init];
        aUser.apsn = apsn;
        aUser.luid = luid;
        aUser.name = name;
        
        
        [users addObject:aUser];
    }
    
    if (findingAUser && !find) {
        
        if ((nil != _userServiceDelegate) &&
            [_userServiceDelegate respondsToSelector:@selector(userService:findedUser:withName:status:errcode:)]) {
            
            [_userServiceDelegate userService:self findedUser:0 withName:nil  status:false  errcode:XAI_ERROR_UNKOWEN];
        }
        
        findingAUser = FALSE;

        _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_find);
    }
    
    if ((nil != _userServiceDelegate) &&
        [_userServiceDelegate respondsToSelector:@selector(userService:findedAllUser:status:errcode:)]) {
        
        [_userServiceDelegate userService:self findedAllUser:users status:YES errcode:XAI_ERROR_NONE];
        
        _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_findAll);
    }
    
    
    return -1;
    
}


- (void) reciveACKPacket:(void*)datas size:(int)size topic:(NSString*)topic{

    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    if (ack == NULL) return;
    
    BOOL bSuccess = (ack->err_no == XAI_ERROR_NONE);
    
    switch (ack->scid) {
        case AddUserID:{
            
            if ((nil != _userServiceDelegate) &&
                [_userServiceDelegate respondsToSelector:@selector(userService:addUser:errcode:)]) {
                
                [_userServiceDelegate userService:self addUser:bSuccess errcode:ack->err_no];
            }

            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_add);
            
        }break;
            
        case DelUserID:{
            
            
            if ((nil != _userServiceDelegate) &&
                [_userServiceDelegate respondsToSelector:@selector(userService:delUser:errcode:)]) {
                
                [_userServiceDelegate userService:self delUser:bSuccess errcode:ack->err_no];
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_del);
     
        
        }break;
            
        case AlterUserNameID:{
            
            if ((nil != _userServiceDelegate) &&
                [_userServiceDelegate respondsToSelector:@selector(userService:changeUserName:errcode:)]) {
                
                [_userServiceDelegate userService:self changeUserName:bSuccess errcode:ack->err_no];
            }
            
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_changeName);
        
        
        }break;
            
        case AlterUserPWID:{
            
            if ((nil != _userServiceDelegate) &&
                [_userServiceDelegate respondsToSelector:@selector(userService:changeUserPassword:errcode:)]) {
                
                [_userServiceDelegate userService:self changeUserPassword:bSuccess errcode:ack->err_no];
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_changePSWD);
        
        
        }break;
            
        
        case PushTokenID:{
            
            if ((nil != _userServiceDelegate) &&
                [_userServiceDelegate respondsToSelector:@selector(userService:pushToken:errcode:)]) {
                
                [_userServiceDelegate userService:self pushToken:bSuccess errcode:ack->err_no];
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIUserServiceOpr_push);
            
            
        }break;
            
        default:break;
    }

    purgePacketParamACKAndData(ack);

}


- (void) reciveStatusPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_status* status = generateParamStatusFromData(datas, size);
    if (status == NULL) return;
    
    switch (status->oprId) {
        case UserTableID:
        {
            [self finderUserLuidHelper:_usernameFind paramStatus:status];
            
        
            NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn luid:_luid other:MQTTCover_UserTable_Other];
            
            [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
        
        }break;
            
        default:break;
    }
    
    purgePacketParamStatusAndData(status);
}


- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    [super recivePacket:datas size:size topic:topic];
    
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
    NSLog(@"out");
}


- (void) addUser:(NSString*)uname Password:(NSString*)password{

    [self addUser:uname Password:password apsn:_apsn luid:_luid];
}


- (void) delUser:(XAITYPELUID) uluid{

    [self delUser:uluid apsn:_apsn luid:_luid];
}

- (void) changeUser:(XAITYPELUID)uluid withName:(NSString*)newUsername{

    [self changeUser:uluid withName:newUsername apsn:_apsn luid:_luid];
}

- (void) changeUser:(XAITYPELUID)luid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword{


    [self changeUser:luid oldPassword:oldPassword to:newPassword apsn:_apsn luid:_luid];
}

- (void) pushToken:(void*)token size:(size_t)size user:(XAITYPELUID)uluid{
    
    [self pushToken:token  size:size user:uluid apsn:_apsn luid:_luid];
}

- (void) finderUserLuidHelper:(NSString*)username{

    [self finderUserLuidHelper:username apsn:_apsn luid:_luid];
    
}

- (void) finderAllUser{

    [self finderAllUserApsn:_apsn luid:_luid];

}



-(void)timeout{
    
    [super timeout];
    
    if (_devOpr == XAIUserServiceOpr_add &&
        nil != _userServiceDelegate &&
        [_userServiceDelegate respondsToSelector:@selector(userService:addUser:errcode:)]) {
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_userServiceDelegate userService:self addUser:false errcode:XAI_ERROR_TIMEOUT];
    }else if(_devOpr == XAIUserServiceOpr_del&&
             (nil != _userServiceDelegate) &&
             [_userServiceDelegate respondsToSelector:@selector(userService:delUser:errcode:)]) {
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_userServiceDelegate userService:self delUser:false errcode:XAI_ERROR_TIMEOUT];
    }else if(_devOpr == XAIUserServiceOpr_changeName&&
             (nil != _userServiceDelegate) &&
             [_userServiceDelegate respondsToSelector:@selector(userService:changeUserName:errcode:)]) {
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_userServiceDelegate userService:self changeUserName:false errcode:XAI_ERROR_TIMEOUT];
    }
    else if(_devOpr == XAIUserServiceOpr_changePSWD&&
            (nil != _userServiceDelegate) &&
            [_userServiceDelegate respondsToSelector:@selector(userService:changeUserPassword:errcode:)]) {
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_userServiceDelegate userService:self changeUserPassword:false errcode:XAI_ERROR_TIMEOUT];
        
    }else if(_devOpr == XAIUserServiceOpr_push&&
             (nil != _userServiceDelegate) &&
             [_userServiceDelegate respondsToSelector:@selector(userService:pushToken:errcode:)]) {
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_userServiceDelegate userService:self pushToken:false errcode:XAI_ERROR_TIMEOUT];
        
    }else if (_devOpr == XAIUserServiceOpr_find&&
              (nil != _userServiceDelegate) &&
              [_userServiceDelegate respondsToSelector:@selector(userService:findedUser:withName:status:errcode:)]) {
        
        NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn luid:_luid other:MQTTCover_UserTable_Other];
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];

        [_userServiceDelegate userService:self findedUser:0 withName:nil  status:false  errcode:XAI_ERROR_TIMEOUT];
    }else if (_devOpr == XAIUserServiceOpr_findAll &&
              (nil != _userServiceDelegate) &&
              [_userServiceDelegate respondsToSelector:@selector(userService:findedAllUser:status:errcode:)]) {
        
        NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn luid:_luid other:MQTTCover_UserTable_Other];
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];

        [_userServiceDelegate userService:self findedAllUser:nil status:false errcode:XAI_ERROR_TIMEOUT];
    }


}

static int __s = 0;
- (id) initWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid{

    if (self = [super initWithApsn:apsn Luid:luid]) {
        __s += 1;
        //NSLog(@"++++++++++:%d",__s);
    }
    return self;
}
-(id)init{

    if (self = [super init]) {
        __s += 1;
        //NSLog(@"++++++++++:%d",__s);
    }
    
    return self;
}

-(void)dealloc{
    __s -= 1;
    //NSLog(@"-----------:%d",__s);
    
}



@end
