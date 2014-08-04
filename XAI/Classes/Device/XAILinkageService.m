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

#define Key_LinkageTabel  0x4
#define Key_LinkageDetail 0x3

#define Key_LinkageDelMagNum 1
#define Key_LinkageChgMagNum 2

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
    
    [self setLinkage_helper:linkNum status:XAILinkageStatus_Del num:Key_LinkageDelMagNum];
}

- (void) setLinkage:(XAILinkageNum)linkNum status:(XAILinkageStatus)linkageStatus{
    
    [self setLinkage_helper:linkNum status:linkageStatus num:Key_LinkageChgMagNum];
    
}


- (void) setLinkage_helper:(XAILinkageNum)linkNum status:(XAILinkageStatus)linkageStatus num:(int)magnum{
    
    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* number_data = generatePacketParamData();
    _xai_packet_param_data* status_data = generatePacketParamData();

    
    xai_param_data_set(number_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN, sizeof(XAILinkageNum), &linkNum, status_data);
    xai_param_data_set(status_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN, sizeof(XAILinkageStatus), &linkageStatus, NULL);
    
    xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, _apsn , _luid, XAI_PKT_TYPE_CONTROL, 0, magnum,
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

    _devOpr = XAILinkageOpr_FindAll;
    _DEF_XTO_TIME_Start;
}


- (void) getLinkageDetail:(XAILinkage*)aLinkage{

    
    _getLinkage = aLinkage;
    
    NSString* topicStr = [MQTTCover linkageStatusTopicWithAPNS:_apsn
                                                          luid:_luid
                                                         other:MQTTCover_LinkageTableDetail_Other
                                                           num:aLinkage.num];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    _devOpr = XAILinkageOpr_GetDetail;
    _DEF_XTO_TIME_Start;
    


}

- (int) findAllLinkageWithParamStatus:(_xai_packet_param_status*) param{
    
    [_allLinkages removeAllObjects];
    
    
    int linkageParamCout = 3; /*每个设备有4个参数*/
    
    int realCount = param->data_count / linkageParamCout;
    
    if ((0 != param->data_count % linkageParamCout) || realCount < 0) {
        
        realCount = 0;
        NSLog(@"err...");
    }
    
    for (int i = 0; i < realCount; i++) {
        
        
        XAILinkage* aLinkage = [[XAILinkage alloc] init];
        
        do {
            
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, i*linkageParamCout + 2);
            
            if (data == NULL || (data->data_type != XAI_DATA_TYPE_ASCII_TEXT) || data->data_len <= 0) break;
            
            NSString* name = [[NSString alloc] initWithBytes:data->data length:data->data_len encoding:NSUTF8StringEncoding];
            
            aLinkage.name = name;
            
            
            
            _xai_packet_param_data* status_data = getParamDataFromParamStatus(param, i*linkageParamCout + 1);
            
            if (status_data == NULL || (status_data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || status_data->data_len <= 0) break;
            
            
            XAILinkageStatus status;
            byte_data_copy(&status, status_data->data, sizeof(XAILinkageStatus), status_data->data_len);
            
            aLinkage.status = status;
            
            
            
            _xai_packet_param_data* id_data = getParamDataFromParamStatus(param, i*linkageParamCout + 0);
            
            if (id_data == NULL ||  (id_data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || id_data->data_len <= 0) break;
            
            
            XAILinkageNum num;
            byte_data_copy(&num, id_data->data, sizeof(XAILinkageNum), id_data->data_len);
            
            
            aLinkage.num = num;
            
            
            [_allLinkages addObject:aLinkage];
            
            
        } while (0);
    
        
    }
    
    if ((nil != _linkageServiceDelegate) &&
        [_linkageServiceDelegate respondsToSelector:@selector(linkageService:findedAllLinkage:errcode:)]) {
        
        [_linkageServiceDelegate linkageService:self findedAllLinkage:_allLinkages errcode:XAI_ERROR_NONE];
    }
    
    
    _DEF_XTO_TIME_End;
    
    return 0;
}

- (int) getLinkageDetailWithParamStatus:(_xai_packet_param_status*) param{
    
    int fixparam = 3;
    int cond_count = param->data_count - fixparam;
    
    BOOL hasErr = true;
    
    do {
        
        _xai_packet_param_data* status_data = getParamDataFromParamStatus(param, 0);
        if (status_data == NULL ||  (status_data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || status_data->data_len <= 0) break;
    
        XAILinkageStatus status;
        byte_data_copy(&status, status_data->data, sizeof(XAILinkageStatus), status_data->data_len);
        
        
        _xai_packet_param_data* name_data = getParamDataFromParamStatus(param, 1);
        
        if (name_data == NULL || (name_data->data_type != XAI_DATA_TYPE_ASCII_TEXT) || name_data->data_len <= 0) break;
        
        NSString* name = [[NSString alloc] initWithBytes:name_data->data length:name_data->data_len encoding:NSUTF8StringEncoding];

        
        _xai_packet_param_data* ctrlInfo_data = getParamDataFromParamStatus(param, 2);
         if (ctrlInfo_data == NULL || (ctrlInfo_data->data_type != XAI_DATA_TYPE_LINKAGE) || ctrlInfo_data->data_len <= 0) break;
        
        _xai_packet_param_linkage* ctrl_info = generateParamLinkageFromData(ctrlInfo_data->data, ctrlInfo_data->data_len);


        XAILinkageUseInfo* effeInfo = [[XAILinkageUseInfo alloc] init];
        XAITYPEAPSN apsn = 0;
        XAITYPELUID luid = 0;
        GUIDToApsnAndLuid(&apsn, &luid, ctrl_info->guid, sizeof(ctrl_info->guid));
        
        [effeInfo setApsn:apsn Luid:luid ID:ctrl_info->some_id Datas:ctrl_info->data];
        
        
        NSMutableArray* cond_infos = [[NSMutableArray alloc] init];
        
        BOOL  infos_b = true;
        
        for (int i = 0;  i < cond_count; i++) {
            
            infos_b = false;
            
            _xai_packet_param_data* Info_data = getParamDataFromParamStatus(param, 3 + i);
            if (Info_data == NULL || (Info_data->data_type != XAI_DATA_TYPE_LINKAGE) || Info_data->data_len <= 0) break;

            
            _xai_packet_param_linkage* cond_info = generateParamLinkageFromData(Info_data->data, Info_data->data_len);
            
            
            XAILinkageUseInfo* useInfo = [[XAILinkageUseInfo alloc] init];
            XAITYPEAPSN apsn = 0;
            XAITYPELUID luid = 0;
            GUIDToApsnAndLuid(&apsn, &luid, cond_info->guid, sizeof(cond_info->guid));
            
            [useInfo setApsn:apsn Luid:luid ID:cond_info->some_id Datas:cond_info->data];
            
            [cond_infos  addObject:useInfo];

            infos_b = true;
            
        }
        
        if (infos_b == false) break;

        _getLinkage.name = name;
        _getLinkage.status = status;
        _getLinkage.effeInfo = effeInfo;
        _getLinkage.condInfos = cond_infos;
        
        hasErr = false;
        
    } while (0);
    
    
    
    XAI_ERROR err = XAI_ERROR_NONE;
    
    if (hasErr) {
        
        err = XAI_ERROR_UNKOWEN;
        
    }
    
    
    if ((nil != _linkageServiceDelegate) &&
        [_linkageServiceDelegate respondsToSelector:@selector(linkageService:getLinkageDetail:statusCode:)]) {
        
        [_linkageServiceDelegate linkageService:self getLinkageDetail:_getLinkage statusCode:err];
    }
    
    _getLinkage = nil;
    
    _DEF_XTO_TIME_End;
    return 0;
}



#pragma mark -- MQTTPacketManagerDelegate
- (void)reciveACKPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
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
            
        case Key_LinkageChange:{
            
            if (ack->normal_param->magic_number == Key_LinkageDelMagNum) {
                
                
                if ((nil != _linkageServiceDelegate) &&
                    [_linkageServiceDelegate respondsToSelector:@selector(linkageService:delStatusCode:)]) {
                    
                    [_linkageServiceDelegate linkageService:self delStatusCode:ack->err_no];
                }
                
                [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
                
                
            }else if(ack->normal_param->magic_number == Key_LinkageChgMagNum){
                
                if ((nil != _linkageServiceDelegate) &&
                    [_linkageServiceDelegate respondsToSelector:@selector(linkageService:changeStatusStatusCode:)]) {
                    
                    [_linkageServiceDelegate linkageService:self changeStatusStatusCode:ack->err_no];
                }
                
                [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
                
            }
        }break;
            
            
        default:break;
    }
    
    purgePacketParamACKAndData(ack);
    
}


- (void) reciveStatusPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_status* status = generateParamStatusFromData(datas, size);
    if (status == NULL) return;
    
    if ([[MQTTCover serverStatusTopicWithAPNS:_apsn
                                         luid:_luid
                                        other:MQTTCover_LinkageTable_Other]
         isEqualToString:topic]) {
        
        switch (status->oprId) {
            case Key_LinkageTabel:
            {
                
                [self findAllLinkageWithParamStatus:status];
                
                
            }break;
                
            default:break;
        }
        
    }
    
    
    if ([[MQTTCover linkageStatusTopicWithAPNS:_apsn
                                          luid:_luid
                                         other:MQTTCover_LinkageTableDetail_Other
                                           num:_getLinkage.num]
         isEqualToString:topic]) {
        
        switch (status->oprId) {
                
            case Key_LinkageDetail:
            {
                
                [self getLinkageDetailWithParamStatus:status];
                
                
            }break;
                
            default:break;
        }
        
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
}


-(void)timeout{
    
    [super timeout];
    
    if(_devOpr == XAILinkageOpr_FindAll &&
       (nil != _linkageServiceDelegate) &&
       [_linkageServiceDelegate respondsToSelector:@selector(linkageService:findedAllLinkage:errcode:)]){
        
        [_linkageServiceDelegate linkageService:self findedAllLinkage:nil errcode:XAI_ERROR_TIMEOUT];
        
    }
    
    if(_devOpr == XAILinkageOpr_GetDetail &&
       (nil != _linkageServiceDelegate) &&
       [_linkageServiceDelegate respondsToSelector:@selector(linkageService:getLinkageDetail:statusCode:)]){
        
        [_linkageServiceDelegate linkageService:self getLinkageDetail:_getLinkage statusCode:XAI_ERROR_TIMEOUT];
        
    }
    
    _getLinkage = nil;

}


-(id)init{

    if (self = [super init]) {
        
        _allLinkages = [[NSMutableArray alloc] init];
    }
    
    return self;
}


@end
