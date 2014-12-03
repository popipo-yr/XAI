//
//  XAICloudService.m
//  XAI
//
//  Created by office on 14-9-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAICloudService.h"

#import "XAIPacketStatus.h"

#define _K_CloudLuId 0x4
#define _K_CloudStatusId 0xFF

@implementation XAICloudService

- (void) curStatus{

    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                         luid:_K_CloudLuId
                                                        other:_K_CloudStatusId];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    [[MQTT shareMQTT].client subscribe:topicStr];


    _DEF_XTO_TIME_Start

}




- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    if (![topic isEqualToString:[MQTTCover nodeStatusTopicWithAPNS:_apsn
                                                              luid:_K_CloudLuId
                                                             other:_K_CloudStatusId]]) {
        
        return;
    }
    
    
    _DEF_XTO_TIME_End;
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    BOOL  isSuccess = false;
    XAICloudStatus status = XAICloudStatus_Unkown;
    
    do {
        
        if (NULL == param) break;
        
        _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
        
        if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || data->data_len <= 0)break;
        
        
        XAITYPEUNSIGN  devStatus_mem = 0;
        
        byte_data_copy(&devStatus_mem, data->data, sizeof(XAITYPEUNSIGN), data->data_len);
        
        
        if (devStatus_mem <= 2) { //devStatus_mem >= 0  unsigned number always true
            
            
            status = (XAICloudStatus)devStatus_mem;
        }
        
        
        isSuccess = true;
        
        
    } while (0);
    
    
    if (nil != _cloudServiceDelegate &&
        [_cloudServiceDelegate respondsToSelector:@selector(cloudService:status:)]) {
        
        [_cloudServiceDelegate cloudService:self status:status];
    }
    
    purgePacketParamStatusAndData(param);
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
    [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_K_CloudLuId other:_K_CloudStatusId]];
    
    
}

-(void)timeout{
    
    
    if (nil != _cloudServiceDelegate &&
        [_cloudServiceDelegate respondsToSelector:@selector(cloudService:status:)]) {
        
        [_cloudServiceDelegate cloudService:self status:XAICloudStatus_Unkown];
    }

    
    _DEF_XTO_TIME_End;
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
     [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_K_CloudLuId other:_K_CloudStatusId]];
    
    [[MQTT shareMQTT].packetManager change];
    
}




@end
