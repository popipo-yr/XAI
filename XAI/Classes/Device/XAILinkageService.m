//
//  LinkageService.m
//  XAI
//
//  Created by office on 14-6-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageService.h"
#import "XAIPacketCtrl.h"
#import "XAIPacketStatus.h"
#import "XAIPacketACK.h"
#import "XAIPacketLinkage.h"


#define Key_LinkageAdd  10
#define Key_LinkageChange  11
#define Key_LinkageTabel  1

@implementation XAILinkageService


- (void)  addLinkageParams:(NSArray*)params ctrlInfo:(XAILinkageUseInfoCtrl *)ctrlInfo
                    status:(XAILinkageStatus)status name:(NSString*)name{    
    
    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* status_data = generatePacketParamData();
    _xai_packet_param_data* name_data = generatePacketParamData();
    _xai_packet_param_data* ctrlInfo_data = generatePacketParamData();
    _xai_packet_param_data* paramInfo_data = NULL;
    int param_count = 0;
    
    xai_param_data_set(status_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN, sizeof(XAILinkageStatus), &status, name_data);
    param_count += 1;
    
    
    NSData* data = [name dataUsingEncoding:NSUTF8StringEncoding];
    xai_param_data_set(name_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [data length], (void*)[name UTF8String],ctrlInfo_data);
    param_count += 1;
    
    /*倒叙*/
    _xai_packet_param_data* next_data = NULL;
    /*条件参数*/
    for (int i = 0; i < [params count]; i++) {
        
        XAILinkageUseInfo* aUseInfo = [params objectAtIndex:[params count] - i - 1];
        if (![aUseInfo isKindOfClass:[XAILinkageUseInfo class]]) {
            
            /*错误处理*/
            break;
        }
        
        _xai_packet_param_data* one_data = generatePacketParamData();
        
        _xai_packet_param_linkage* cond_info = generatePacketParamLinkage();
        xai_param_Linkage_set(cond_info, aUseInfo.dev_apsn, aUseInfo.dev_luid, aUseInfo.some_id, (uint8_t)aUseInfo.cond,aUseInfo.datas);
        _xai_packet* cond_info_p = generatePacketFromParamLinkage(cond_info);
        
        xai_param_data_set(one_data, XAI_DATA_TYPE_LINKAGE, cond_info_p->size, cond_info_p->all_load, next_data);
        
        purgePacket(cond_info_p);
        purgePacketParamLinkage(cond_info);
        
        
        next_data = one_data;
        paramInfo_data = one_data;
        
        param_count += 1;
        
    }
    
    
    /*结果参数*/
    _xai_packet_param_linkage* ctrl_info = generatePacketParamLinkage();
    xai_param_Linkage_set(ctrl_info, ctrlInfo.dev_apsn, ctrlInfo.dev_luid, ctrlInfo.some_id, (uint8_t)ctrlInfo.cond,ctrlInfo.datas);
    _xai_packet* ctrl_info_p = generatePacketFromParamLinkage(ctrl_info);
    
    xai_param_data_set(ctrlInfo_data, XAI_DATA_TYPE_LINKAGE, ctrl_info_p->size, ctrl_info_p->all_load, paramInfo_data);
    
    purgePacket(ctrl_info_p);
    purgePacketParamLinkage(ctrl_info);
    param_count += 1;
    
    
    xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, _apsn , _luid, XAI_PKT_TYPE_CONTROL, 0, 0,
                       Key_LinkageAdd,[[NSDate new] timeIntervalSince1970], param_count, status_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    NSString* ctrlTopic =  [MQTTCover serverCtrlTopicWithAPNS:_apsn luid:_luid];
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:ctrlTopic
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);


}

- (void) delLinkage:(XAILinkageNum)linkNum{
}

- (void) setLinkage:(XAILinkageNum)linkNum status:(XAILinkageStatus)linkageStatus{
    
    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* number_data = generatePacketParamData();
    _xai_packet_param_data* status_data = generatePacketParamData();

    
    xai_param_data_set(number_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN, sizeof(XAILinkageNum), &linkNum, status_data);
    xai_param_data_set(status_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN, sizeof(XAILinkageStatus), &linkageStatus, NULL);
    
    xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, _apsn , _luid, XAI_PKT_TYPE_CONTROL, 0, 0,
                       Key_LinkageChange,[[NSDate new] timeIntervalSince1970], 2, number_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    NSString* ctrlTopic =  [MQTTCover serverCtrlTopicWithAPNS:_apsn luid:_luid];
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:ctrlTopic
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);

    
}
- (void) findAllLinkages{
    
    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                         luid:_luid
                                                        other:MQTTCover_LinkageTable_Other];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];

}


//- (int) findAllDevWithParamStatus:(_xai_packet_param_status*) param{
//    
//    [_allDevices removeAllObjects];
//    
//    NSMutableArray* devAry = [[NSMutableArray alloc] init];
//    
//    
//    int devParamCout = 4; /*每个设备有4个参数*/
//    
//    int realCount = param->data_count / devParamCout;
//    
//    if ((0 != param->data_count % devParamCout) || realCount < 0) {
//        
//        realCount = 0;
//        NSLog(@"err...");
//    }
//    
//    for (int i = 0; i < realCount; i++) {
//        
//        XAIDevice* aDevice = [[XAIDevice alloc] init];
//        
//        BOOL  allType = false;
//        
//        do {
//            
//            _xai_packet_param_data* type_data = getParamDataFromParamStatus(param, i*devParamCout + 3);
//            
//            if (type_data == NULL || (type_data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || type_data->data_len <= 0) break;
//            
//            
//            uint8_t _type = *((uint8_t*)type_data->data);
//            
//            XAIDeviceType type = _type;
//            aDevice.devType = type;
//            
//            
//            
//            
//            _xai_packet_param_data* data = getParamDataFromParamStatus(param, i*devParamCout + 2);
//            
//            if (data == NULL || (data->data_type != XAI_DATA_TYPE_ASCII_TEXT) || data->data_len <= 0) break;
//            
//            NSString* name = [[NSString alloc] initWithBytes:data->data length:data->data_len encoding:NSUTF8StringEncoding];
//            
//            aDevice.name = name;
//            
//            
//            
//            _xai_packet_param_data* luid_data = getParamDataFromParamStatus(param, i*devParamCout + 1);
//            
//            if (luid_data == NULL || (luid_data->data_type != XAI_DATA_TYPE_BIN_LUID) || luid_data->data_len <= 0) break;
//            
//            
//            XAITYPELUID luid;
//            byte_data_copy(&luid, luid_data->data, sizeof(XAITYPELUID), luid_data->data_len);
//            
//            
//            aDevice.luid = luid;
//            
//            
//            _xai_packet_param_data* apsn_data = getParamDataFromParamStatus(param, i*devParamCout + 0);
//            
//            if (apsn_data == NULL ||  (apsn_data->data_type != XAI_DATA_TYPE_BIN_LUID) || apsn_data->data_len <= 0) break;
//            
//            
//            XAITYPEAPSN apsn;
//            byte_data_copy(&apsn, apsn_data->data, sizeof(XAITYPEAPSN), apsn_data->data_len);
//            
//            
//            aDevice.apsn = apsn;
//            
//            
//            
//            allType = YES;
//            
//            
//            [_allDevices addObject:aDevice];
//            
//            
//        } while (0);
//        
//        if (allType) {
//            
//            [devAry addObject:aDevice];
//        }
//        
//    }
//    
//    if ((nil != _deviceServiceDelegate) &&
//        [_deviceServiceDelegate respondsToSelector:@selector(devService:findedAllDevice:status:errcode:)]) {
//        
//        [_deviceServiceDelegate devService:self findedAllDevice:devAry status:YES errcode:XAI_ERROR_NONE];
//    }
//    
//    
//    if (_bFinding) {/*查找在线的设备*/
//        
//        [self startFindOnline];
//        
//    }
//    
//    
//    return 0;
//}
//


#pragma mark -- MQTTPacketManagerDelegate
- (void)reciveACKPacket:(void*)datas size:(int)size topic:topic{
    
    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    if (ack == NULL) return;
    
    
    
    switch (ack->scid) {
        case Key_LinkageAdd:{
            
            if ((nil != _linkageServiceDelegate) &&
                [_linkageServiceDelegate respondsToSelector:@selector(linkageService:addStatusCode:)]) {
                
                [_linkageServiceDelegate linkageService:self addStatusCode:ack->err_no];
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            
        }break;
            
//        case DelDevID:{
//            
//            if ((nil != _deviceServiceDelegate) &&
//                [_deviceServiceDelegate respondsToSelector:@selector(devService:delDevice:errcode:)]) {
//                
//                [_deviceServiceDelegate devService:self delDevice:bSuccess errcode:ack->err_no];
//            }
//            
//            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
//            
//        }break;
//            
        case Key_LinkageChange:{
            
            if ((nil != _linkageServiceDelegate) &&
                [_linkageServiceDelegate respondsToSelector:@selector(linkageService:changeStatusStatusCode:)]) {
                
                [_linkageServiceDelegate linkageService:self changeStatusStatusCode:ack->err_no];
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
    
    if ([[MQTTCover serverStatusTopicWithAPNS:_apsn
                                         luid:_luid
                                        other:MQTTCover_LinkageTable_Other]
         isEqualToString:topic]) {
        
        switch (status->oprId) {
            case Key_LinkageTabel:
            {
                
                //[self findAllDevWithParamStatus:status];
                
                
            }break;
                
            default:break;
        }
        
    }
    
    purgePacketParamStatusAndData(status);
}

- (void) recivePacket:(void*)datas size:(int)size topic:topic{
    
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
}





@end
