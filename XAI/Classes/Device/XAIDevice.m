//
//  XAIDevice.m
//  XAI
//
//  Created by office on 14-4-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevice.h"
#import "XAIPacketStatus.h"



@implementation XAIDevice


- (void) getDeviceStatus{

    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DeviceStatusID];
   
    //topicStr = @"0x00000001/NODES/0x00124b0003d430b6/OUT/STATUS/";
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    

}


- (void) recivePacket:(void*)datas size:(int)size topic:topic{
    
    
    if (![topic isEqualToString:
          [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DeviceStatusID]]) {
        
        return;
    }
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    BOOL  isSuccess = false;
    XAIDeviceStatus devStatus = XAIDeviceStatus_UNKOWN;
    
    do {
        
        if (NULL == param) break;
        
        _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
        
        if ((data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || data->data_len <= 0)break;

        
        XAITYPEUNSIGN  devStatus_mem = 0;
        
        byte_data_copy(&devStatus_mem, data->data, sizeof(XAITYPEUNSIGN), data->data_len);
        
        
        if (devStatus_mem <= 2) { //devStatus_mem >= 0  unsigned number always true
            
            
            devStatus = (XAIDeviceStatus)devStatus_mem;
        }
        
        
        isSuccess = true;
        
        
    } while (0);
    
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(getStatus:withFinish:)]) {
        
        [_delegate getStatus:devStatus withFinish:isSuccess];
    }
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
     [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DeviceStatusID]];
    
    purgePacketParamStatusAndData(param);
}


- (id) initWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid{
    
    if (self = [super init]) {
        
        _apsn = apsn;
        _luid = luid;
    }
    
    return self;
    
}

@end
