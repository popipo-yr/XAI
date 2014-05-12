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
#define Key_BatteryPowerId 126

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
    
    if (typeBool == XAITYPEBOOL_TRUE) {
        
        retStatus = XAIDevInfraredStatusDetectorNothing;
        
    }else if(typeBool == XAITYPEBOOL_FALSE){
        
        retStatus = XAIDevInfraredStatusDetectorThing;
        
    }
    
    return retStatus;
}


- (void) getInfraredStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DetectorStatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
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

- (void)recivePacket:(void *)datas size:(int)size topic:(NSString *)topic{
    
    [super recivePacket:datas size:size topic:topic];
    
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    if (NULL == param) return;
    
    BOOL  isSuccess = false;
    XAIDevInfraredErr err = XAIDevInfraredErr_Unknow;
    
    //查看状态的topic
    if ([topic isEqualToString:
         [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DetectorStatusID]]) {
        
        
        XAIDevInfraredStatus curStatus = XAIDevInfraredStatusUnkown;
        
        do {
            
            if (NULL == param) break;
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
            
            if ((data->data_type != XAI_DATA_TYPE_BIN_BOOL) || data->data_len <= 0)break;
            
            XAITYPEBOOL bStatus;
            
            byte_data_copy(&bStatus, data->data, sizeof(XAITYPEBOOL), data->data_len);
            
            
            curStatus = [self coverPacketBOOLToInfraredStatus:bStatus];
            
            if (curStatus == XAIDevInfraredStatusUnkown) break;
            
            isSuccess = true;
            err = XAIDevInfraredErr_NONE;
            
        } while (0);
        
        
        if (nil != _infDelegate &&
            [_infDelegate respondsToSelector:@selector(infrared:curStatus:err:)]) {
            
            [_infDelegate infrared:self curStatus:curStatus err:err];
        }
        
        _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevInfraredOpr_GetCurStatus);
        
//        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
//         [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DetectorStatusID]];
        
        
        
    }else if ([topic isEqualToString:
               [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId]]){
        
        
        float curPower = 1;
        
        do {
            
            if (NULL == param) break;
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
            
            if ((data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || data->data_len <= 0)break;
            
            int power = 0; /*获取的电量为电量百分比乘以十*/
            
            byte_data_copy(&power, data->data, sizeof(int), data->data_len);
            
            curPower = power*1.0 / 10.0;
            
            isSuccess = true;
            err = XAIDevInfraredErr_NONE;
            
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
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    
}
- (void) endFocusStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DetectorStatusID];
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
    
}




-(void)timeout{
    
    [super timeout];
    
    if (_devOpr == XAIDevInfraredOpr_GetCurStatus &&
        (nil != _infDelegate) &&
        [_infDelegate respondsToSelector:@selector(infrared:curStatus:err:)]) {
        
        [_infDelegate infrared:self curStatus:XAIDevInfraredStatusUnkown err:XAIDevInfraredErr_TimeOut];
        
        
    }else  if (_devOpr == XAIDevInfraredOpr_GetCurPower &&
               (nil != _infDelegate) &&
               [_infDelegate respondsToSelector:@selector(infrared:curPower:err:)]) {
        
        [_infDelegate infrared:self curPower:0 err:XAIDevInfraredErr_TimeOut];
        
        
    }
    
}

@end
