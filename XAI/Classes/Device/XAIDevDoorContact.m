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
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
}

- (void) getPower{


    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
}

#pragma mark -- MQTTPacketManagerDelegate

- (void)recivePacket:(void *)datas size:(int)size topic:(NSString *)topic{
    
    [super recivePacket:datas size:size topic:topic];
    
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    if (NULL == param) return;
    
    //查看状态的topic
    if ([topic isEqualToString:[MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID]]) {
        
        BOOL  isSuccess = false;
        
        XAIDevDoorContactStatus curStatus = XAIDevDoorContactStatusUnkown;
        
        do {
            
            if (NULL == param) break;
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
            
            if ((data->data_type != XAI_DATA_TYPE_BIN_BOOL) || data->data_len <= 0)break;
            
            XAITYPEBOOL isOpen;
            
            byte_data_copy(&isOpen, data->data, sizeof(XAITYPEBOOL), data->data_len);
            
            
            curStatus = [self coverPacketBOOLToDoorContactStatus:isOpen];
            
            if (curStatus == XAIDevDoorContactStatusUnkown) break;
            
            isSuccess = true;
            
            
        } while (0);
        
        
        if (nil != _dcDelegate &&
            [_dcDelegate respondsToSelector:@selector(doorContactStatusGetSuccess:curStatus:)]) {
            
            [_dcDelegate doorContactStatusGetSuccess:isSuccess curStatus:curStatus];
        }
        
        [[MQTT shareMQTT].packetManager removeObserver:self forKeyPath:
         [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID]];
        
        
        
    }else if ([topic isEqualToString:
               [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId]]){
        
        
        BOOL  isSuccess = false;
        
        float curPower = 1;
        
        do {
            
            if (NULL == param) break;
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
            
            if ((data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || data->data_len <= 0)break;
            
            int power; /*获取的电量为电量百分比乘以十*/
            
            byte_data_copy(&power, data->data, sizeof(int), data->data_len);
            
            curPower = power*1.0 / 10.0;
            
            isSuccess = true;
            
        } while (0);
        
        
        if (nil != _dcDelegate &&
            [_dcDelegate respondsToSelector:@selector(doorContactPowerGetSuccess:curPower:)]) {
            
            [_dcDelegate doorContactPowerGetSuccess:isSuccess curPower:curPower];
        }
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
         [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_BatteryPowerId]];
    
    }
    
    purgePacketParamStatusAndData(param);
    
    
    
}


@end
