//
//  XAIDevInfrared.m
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevInfrared.h"

#import "XAIPacketStatus.h"

#define Key_DetectorStatusID 1
#define Key_BatteryPowerId 0xFE

@implementation XAIDevInfrared

- (XAITYPEBOOL) coverInfraredStatusToPacketBOOL:(XAIDevInfraredStatus) circuitStatus{
    
    XAITYPEBOOL retBOOL = XAITYPEBOOL_UNKOWN;
    
    if (circuitStatus == XAIDevInfraredStatusDetectorNothing) {
        
        retBOOL = XAITYPEBOOL_FALSE;
        
    }else if(circuitStatus == XAIDevInfraredStatusDetectorThing){
        
        retBOOL = XAITYPEBOOL_TRUE;
        
    }
    
    return retBOOL;
}

- (XAIDevInfraredStatus) coverPacketBOOLToInfraredStatus:(XAITYPEBOOL)typeBool{
    
    XAIDevInfraredStatus retStatus = XAIDevInfraredStatusUnkown;
    
    if (typeBool != XAITYPEBOOL_FALSE) {
        
        retStatus = XAIDevInfraredStatusDetectorThing;
        
    }else{
        
        retStatus = XAIDevInfraredStatusDetectorNothing;
        
    }
    
    return retStatus;
}


- (void) getInfraredStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DetectorStatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr withQos:2];
    
    //[[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    _devOpr = XAIDevInfraredOpr_GetCurStatus;
    _DEF_XTO_TIME_Start;
    
}

- (void) getPower{
    
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    _devOpr = XAIDevInfraredOpr_GetCurPower;
    _DEF_XTO_TIME_Start;
}

#pragma mark -- MQTTPacketManagerDelegate

- (void)recivePacket:(void *)datas size:(int)size topic:(NSString *)topic mosqMsg:(MosquittoMessage *)mosq_msg{
    
    [super recivePacket:datas size:size topic:topic mosqMsg:mosq_msg];
    
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    if (NULL == param) return;
    
    XAI_ERROR err = XAI_ERROR_UNKOWEN;
    
    //查看状态的topic
    if ([topic isEqualToString:
         [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DetectorStatusID]]) {
        
        
        XAIDevInfraredStatus curStatus = XAIDevInfraredStatusUnkown;
        
        do {
            
            if (NULL == param) break;
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
            
            if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_BOOL) || data->data_len <= 0)break;
            
            XAITYPEBOOL bStatus;
            
            byte_data_copy(&bStatus, data->data, sizeof(XAITYPEBOOL), data->data_len);
            
            
            curStatus = [self coverPacketBOOLToInfraredStatus:bStatus];
            
            if (curStatus == XAIDevInfraredStatusUnkown) break;
            
            err = XAI_ERROR_NONE;
            
        } while (0);
        
        
        if (nil != _infDelegate &&
            [_infDelegate respondsToSelector:@selector(infrared:status:err:otherInfo:)]) {
            
            XAIOtherInfo* otherInfo = [[XAIOtherInfo alloc] init];
            otherInfo.time = param->time;
            otherInfo.msgid = mosq_msg.mid;
            otherInfo.error = err;
            otherInfo.fromluid =  luidFromGUID(param->normal_param->from_guid);
            
            [_infDelegate infrared:self status:curStatus err:err otherInfo:otherInfo];
        }
        
        _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevInfraredOpr_GetCurStatus);
        
//        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
//         [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DetectorStatusID]];
        
        
        
    }else if ([topic isEqualToString:
               [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId]]){
        
        
        XAIDevPowerStatus curPower = XAIDevPowerStatus_Unkown;
        
        do {
            
            if (NULL == param) break;
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
            
            if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || data->data_len <= 0)break;
            
            int power = 0; /*获取的电量为电量百分比乘以十*/
            
            byte_data_copy(&power, data->data, sizeof(int), data->data_len);
            
            if (power == 0) {
                curPower = XAIDevPowerStatus_Low;
            }else if (power == 1){
                curPower = XAIDevPowerStatus_Normal;
            }else if (power == 2){
                curPower = XAIDevPowerStatus_Less;
            }
            
            
            err = XAI_ERROR_NONE;
            
        } while (0);
        
        
        if (nil != _infDelegate &&
            [_infDelegate respondsToSelector:@selector(infrared:curPower:err:)]) {
            
            [_infDelegate infrared:self curPower:curPower err:err];
        }
        
        _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevInfraredOpr_GetCurPower);
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
         [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId]];
        
    }
    
    purgePacketParamStatusAndData(param);
    
}


- (void) startFocusStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DetectorStatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr withQos:2];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    
    topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    
}
- (void) endFocusStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DetectorStatusID];
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
    
    topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId];
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
}




-(void)timeout{
    
    
    
    if (_devOpr == XAIDevInfraredOpr_GetCurStatus &&
        (nil != _infDelegate) &&
        [_infDelegate respondsToSelector:@selector(infrared:curStatus:err:)]) {
        
        [_infDelegate infrared:self curStatus:XAIDevInfraredStatusUnkown err:XAI_ERROR_TIMEOUT];
        
        
    }else  if (_devOpr == XAIDevInfraredOpr_GetCurPower &&
               (nil != _infDelegate) &&
               [_infDelegate respondsToSelector:@selector(infrared:curPower:err:)]) {
        
        [_infDelegate infrared:self curPower:0 err:XAI_ERROR_TIMEOUT];
        
        
    }
    
    [super timeout];
}

- (BOOL) linkageInfoIsEqual:(XAILinkageUseInfo*)useInfo index:(int)index{
    
    
    if (useInfo.dev_apsn == self.apsn
        && useInfo.dev_luid == self.luid) {
        
        XAIDevInfraredStatus status = [self linkageInfoStatus:useInfo];
        
        if ((index == 0 && status == XAIDevInfraredStatusDetectorThing)
            || (index == 1 && status == XAIDevInfraredStatusDetectorNothing)) {
            return true;
        }
    }
    
    return false;
}

- (NSArray*) getLinkageStatusInfos{
    
    //true 探测到东西
    
    XAILinkageUseInfoStatus* open = [[XAILinkageUseInfoStatus alloc] init];
    
    _xai_packet_param_data* open_data = generatePacketParamData();
    XAITYPEBOOL typeopen =  XAITYPEBOOL_TRUE;
    xai_param_data_set(open_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typeopen, NULL);
    
    [open setApsn:_apsn Luid:_luid ID:Key_DetectorStatusID Datas:open_data];
    
    
    XAILinkageUseInfoCtrl* close = [[XAILinkageUseInfoCtrl alloc] init];
    
    _xai_packet_param_data* close_data = generatePacketParamData();
    XAITYPEBOOL typeclose =  XAITYPEBOOL_FALSE;
    xai_param_data_set(close_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typeclose, NULL);
    
    [close setApsn:_apsn Luid:_luid ID:Key_DetectorStatusID Datas:close_data];
    
    purgePacketParamData(open_data);
    purgePacketParamData(close_data);
    
    return [NSArray arrayWithObjects:open, close, nil];


}


-(XAIDevInfraredStatus) linkageInfoStatus:(XAILinkageUseInfo*)useInfo{
    
    XAIDevInfraredStatus status = XAIDevInfraredStatusUnkown;
    
    do {
        
        if (useInfo.datas == NULL) break;
        if (useInfo.datas->data_type != XAI_DATA_TYPE_BIN_BOOL) break;
        
        XAITYPEBOOL isOpen = 0;
        
        byte_data_copy(&isOpen, useInfo.datas->data, sizeof(XAITYPEBOOL), useInfo.datas->data_len);
        
        status = [self coverPacketBOOLToInfraredStatus:isOpen];
        
    } while (0);
    
    
    return status;
    
}


@end
