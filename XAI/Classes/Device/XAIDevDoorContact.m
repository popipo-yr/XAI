//
//  XAIDevDoorContact.m
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevDoorContact.h"
#import "XAIPacketStatus.h"

#define Key_StatusID 1
#define Key_BatteryPowerId 126

@implementation XAIDevDoorContact

- (XAITYPEBOOL) coverDoorContactStatusToPacketBOOL:(XAIDevDoorContactStatus) circuitStatus{
    
    XAITYPEBOOL retBOOL = XAITYPEBOOL_UNKOWN;
    
    if (circuitStatus == XAIDevDoorContactStatusClose) {
        
        retBOOL = XAITYPEBOOL_FALSE;
        
    }else if(circuitStatus == XAIDevDoorContactStatusOpen){
        
        retBOOL = XAITYPEBOOL_TRUE;
        
    }
    
    return retBOOL;
}

- (XAIDevDoorContactStatus) coverPacketBOOLToDoorContactStatus:(XAITYPEBOOL)typeBool{
    
    XAIDevDoorContactStatus retStatus = XAIDevDoorContactStatusUnkown;
    
    if (typeBool == XAITYPEBOOL_TRUE) {
        
        retStatus = XAIDevDoorContactStatusOpen;
        
    }else if(typeBool == XAITYPEBOOL_FALSE){
        
        retStatus = XAIDevDoorContactStatusClose;
        
    }
    
    return retStatus;
}


- (void) getDoorContactStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr withQos:2];
    
    //[[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    _devOpr = XAIDevDCOpr_GetCurStatus;
    _DEF_XTO_TIME_Start;
    
}

- (void) getPower{


    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    _devOpr = XAIDevDCOpr_GetCurPower;
    _DEF_XTO_TIME_Start;
}

#pragma mark -- MQTTPacketManagerDelegate

- (void)recivePacket:(void *)datas size:(int)size topic:(NSString *)topic{
    
    [super recivePacket:datas size:size topic:topic];
    
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    if (NULL == param) return;
    
    XAI_ERROR  err = XAI_ERROR_UNKOWEN;
    
    //查看状态的topic
    if ([topic isEqualToString:[MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID]]) {
        

        XAIDevDoorContactStatus curStatus = XAIDevDoorContactStatusUnkown;
        
        do {
            
            if (NULL == param) break;
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
            
            if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_BOOL) || data->data_len <= 0)break;
            
            XAITYPEBOOL isOpen;
            
            byte_data_copy(&isOpen, data->data, sizeof(XAITYPEBOOL), data->data_len);
            
            
            curStatus = [self coverPacketBOOLToDoorContactStatus:isOpen];
            
            if (curStatus == XAIDevDoorContactStatusUnkown) break;
            
            err = XAI_ERROR_NONE;
            
        } while (0);
        
        
        if (nil != _dcDelegate &&
            [_dcDelegate respondsToSelector:@selector(doorContact:status:err:otherInfo:)]) {
            
            XAIOtherInfo* otherInfo = [[XAIOtherInfo alloc] init];
            otherInfo.time = param->time;
            otherInfo.msgid = param->normal_param->magic_number;
            otherInfo.error = err;
            otherInfo.fromluid =  luidFromGUID(param->normal_param->from_guid);
            
            [_dcDelegate doorContact:self status:curStatus err:err otherInfo:otherInfo];
        }
        
        _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevDCOpr_GetCurStatus);
        
        
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
                curPower = XAIDevPowerStatus_Normal;
            }else if (power == 1){
                curPower = XAIDevPowerStatus_Low;
            }else if (power == 2){
                curPower = XAIDevPowerStatus_Less;
            }
            
            err = XAI_ERROR_NONE;
            
        } while (0);
        
        
        if (nil != _dcDelegate &&
            [_dcDelegate respondsToSelector:@selector(doorContact:curPower:err:)]) {
            
            [_dcDelegate doorContact:self curPower:curPower err:err];
        }
        
        _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevDCOpr_GetCurPower);
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
         [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId]];
    
    }
    
    purgePacketParamStatusAndData(param);
    
    
    
}

- (void) startFocusStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    
}
- (void) endFocusStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID];
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
    
}


-(void)timeout{
    
    if (_devOpr == XAIDevDCOpr_GetCurStatus &&
        (nil != _dcDelegate) &&
        [_dcDelegate respondsToSelector:@selector(doorContact:curStatus:err:)]) {
        
        [_dcDelegate doorContact:self curStatus:XAIDevDoorContactStatusUnkown err:XAI_ERROR_TIMEOUT];
        
        
    }else  if (_devOpr == XAIDevDCOpr_GetCurPower &&
               (nil != _dcDelegate) &&
               [_dcDelegate respondsToSelector:@selector(doorContact:curPower:err:)]) {
        
        [_dcDelegate doorContact:self curPower:0 err:XAI_ERROR_TIMEOUT];

        
    }

    [super timeout];
}

#pragma mark Linkage
-(NSArray *)getLinkageUseStatusInfos{
    
    
    XAILinkageUseInfoStatus* open = [[XAILinkageUseInfoStatus alloc] init];
    
    _xai_packet_param_data* open_data = generatePacketParamData();
    XAITYPEBOOL typeopen =  XAITYPEBOOL_TRUE;
    xai_param_data_set(open_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typeopen, NULL);
    
    [open setApsn:_apsn Luid:_luid ID:Key_StatusID Datas:open_data];
    
    
    XAILinkageUseInfoCtrl* close = [[XAILinkageUseInfoCtrl alloc] init];
    
    _xai_packet_param_data* close_data = generatePacketParamData();
    XAITYPEBOOL typeclose =  XAITYPEBOOL_FALSE;
    xai_param_data_set(close_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typeclose, NULL);
    
    [close setApsn:_apsn Luid:_luid ID:Key_StatusID Datas:close_data];
    
    
    purgePacketParamData(open_data);
    purgePacketParamData(close_data);
    
    
    return [NSArray arrayWithObjects:open, close, nil];
}


-(XAIDevDoorContactStatus) linkageInfoStatus:(XAILinkageUseInfo*)useInfo{
    
    XAIDevDoorContactStatus status = XAIDevDoorContactStatusUnkown;
    
    do {
        
        if (useInfo.datas == NULL) break;
        if (useInfo.datas->data_type != XAI_DATA_TYPE_BIN_BOOL) break;
        
        XAITYPEBOOL isOpen = 0;
        
        byte_data_copy(&isOpen, useInfo.datas->data, sizeof(XAITYPEBOOL), useInfo.datas->data_len);
        
        status = [self coverPacketBOOLToDoorContactStatus:isOpen];
        
    } while (0);
    
    
    return status;
    
}




@end
