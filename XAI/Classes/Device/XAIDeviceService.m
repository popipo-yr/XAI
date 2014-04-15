//
//  XAIDeviceService.m
//  XAI
//
//  Created by office on 14-4-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDeviceService.h"

#import "XAIPacketStatus.h"
#import "XAIPacketCtrl.h"
#import "XAIPacketACK.h"

#define 	AddDevID	5
#define	DelDevID	6
#define	AlterDevNameID	7

#define DevTableID 0x2

@implementation XAIDeviceService


- (void) addDev:(XAITYPELUID)dluid  withName:(NSString*)devName
           apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid
{
    
    MQTT* curMQTT = [MQTT shareMQTT];

    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* name_data = generatePacketParamData();
    
    
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN , sizeof(XAITYPEAPSN), &apsn,luid_data);
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID, sizeof(XAITYPELUID), &dluid,name_data);
    
    xai_param_data_set(name_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [devName length], (void*)[devName UTF8String],NULL);
   
    
    
    xai_param_ctrl_set(param_ctrl, curMQTT.apsn, curMQTT.luid, apsn, luid, XAI_PKT_TYPE_CONTROL,
                       0, 0, AddDevID,[[NSDate new] timeIntervalSince1970],3, apsn_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self] ;
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    



}
- (void) delDev:(XAITYPELUID)dluid apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{
    
    
    MQTT* curMQTT = [MQTT shareMQTT];

    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    //param
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    _xai_packet_param_data* luid_data = generatePacketParamData();
    
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN , sizeof(XAITYPEAPSN), &apsn,luid_data);
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID, sizeof(XAITYPELUID), &dluid,NULL);
    
    
    xai_param_ctrl_set(param_ctrl, curMQTT.apsn, curMQTT.luid, apsn, luid, XAI_PKT_TYPE_CONTROL,
                       0, 0, DelDevID, [[NSDate new] timeIntervalSince1970], 2, apsn_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [curMQTT.packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}
- (void) changeDev:(XAITYPELUID)dluid withName:(NSString*)newName apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{

    MQTT* curMQTT = [MQTT shareMQTT];
    
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
     _xai_packet_param_data* apsn_data = generatePacketParamData();
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* name_data = generatePacketParamData();
   
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN , sizeof(XAITYPEAPSN), &apsn,luid_data);
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                       sizeof(XAITYPELUID), &dluid, name_data);
    
    xai_param_data_set(name_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [newName length], (void*)[newName UTF8String],NULL);
    
    
    xai_param_ctrl_set(param_ctrl, curMQTT.apsn, curMQTT.luid, apsn, luid, XAI_PKT_TYPE_CONTROL,
                       0, 0, AlterDevNameID, [[NSDate new] timeIntervalSince1970], 3, apsn_data);
    
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    [curMQTT.packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}

- (void) findAllDevWithApsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{

    
    
    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:apsn
                                                         luid:luid
                                                        other:MQTTCover_DevTable_Other];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];

}

#pragma mark -- Helper

- (int) findAllDevWithParamStatus:(_xai_packet_param_status*) param{
    
    
    NSMutableArray* devAry = [[NSMutableArray alloc] init];
    
    int realCount = param->data_count / 3;
    
    if ((0 != param->data_count % 3) || realCount < 1) {
        
        return -1;
    }
    
    for (int i = 0; i < realCount; i++) {
        
        XAIDevice* aDevice = [[XAIDevice alloc] init];
        
        BOOL  allType = false;
        
        do {
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, i*3 + 2);
            
            if ((data->data_type != XAI_DATA_TYPE_ASCII_TEXT) || data->data_len <= 0) break;
            
            NSString* name = [[NSString alloc] initWithBytes:data->data length:data->data_len encoding:NSUTF8StringEncoding];
            
            aDevice.name = name;
            
            
            
            _xai_packet_param_data* luid_data = getParamDataFromParamStatus(param, i*3 + 1);
            
            if ((luid_data->data_type != XAI_DATA_TYPE_BIN_LUID) || luid_data->data_len <= 0) break;
            
            
            XAITYPELUID luid;
            byte_data_copy(&luid, luid_data->data, sizeof(XAITYPELUID), luid_data->data_len);
            
            
            aDevice.luid = luid;
            
            
            _xai_packet_param_data* apsn_data = getParamDataFromParamStatus(param, i*3 + 0);
            
            if ((apsn_data->data_type != XAI_DATA_TYPE_BIN_LUID) || apsn_data->data_len <= 0) break;
            
            
            XAITYPEAPSN apsn;
            byte_data_copy(&apsn, apsn_data->data, sizeof(XAITYPEAPSN), apsn_data->data_len);
            
            
            aDevice.apsn = apsn;
            
            
            
            allType = YES;
            
            
        } while (0);
        
        if (allType) {
            
            [devAry addObject:aDevice];
        }
        
    }
    
    if ((nil != _delegate) && [_delegate respondsToSelector:@selector(findedAllDevice:datas:)]) {
        
        [_delegate findedAllDevice:YES datas:devAry];
    }
    

    
    return 0;
}


#pragma mark -- MQTTPacketManagerDelegate
- (void)reciveACKPacket:(void*)datas size:(int)size topic:topic{
    
    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    if (ack == NULL) return;
    
    switch (ack->scid) {
        case AddDevID:{
            
            if (ack->err_no == 0) {
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(addDevice:)]) {
                    
                    [_delegate addDevice:YES];
                }
                
            }else{
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(addDevice:)]) {
                    
                    [_delegate addDevice:FALSE];
                }
                
                
                NSLog(@"FAILD ADD USER - %d", ack->err_no);
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            
        }break;
            
        case DelDevID:{
            
            if (ack->err_no == 0) {
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(delDevice:)]) {
                    
                    [_delegate delDevice:YES];
                }
                
            }else{
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(delDevice:)]) {
                    
                    [_delegate delDevice:FALSE];
                }
                
                
                NSLog(@"FAILD DEL USER - %d", ack->err_no);
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
        }break;
            
        case AlterDevNameID:{
            
            if (ack->err_no == 0) {
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(changeDeviceName:)]) {
                    
                    [_delegate changeDeviceName:YES];
                }
                
            }else{
                
                if ((nil != _delegate) && [_delegate respondsToSelector:@selector(changeDeviceName:)]) {
                    
                    [_delegate changeDeviceName:FALSE];
                }
                
                
                NSLog(@"FAILD CHANGE_USER_NAME USER - %d", ack->err_no);
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
        case DevTableID:
        {
            
            [self findAllDevWithParamStatus:status];
            
            
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

@implementation XAIDevice

@end
