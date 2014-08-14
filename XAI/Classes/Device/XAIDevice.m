//
//  XAIDevice.m
//  XAI
//
//  Created by office on 14-4-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevice.h"
#import "XAIPacketStatus.h"
#import "XAIPacketDevTypeInfo.h"

#import "XAIObject.h"

@implementation XAIDevice


- (void) getDeviceStatus{

    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DeviceStatusID];
   
    //topicStr = @"0x00000001/NODES/0x00124b0003d430b6/OUT/STATUS/";
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    [[MQTT shareMQTT].client subscribe:topicStr];
    

    _devOpr = XAIDevOpr_GetStatus;
    _DEF_XTO_TIME_Start
    
    

}

- (void) getDeviceInfo{
    
    NSString* topicStr = [MQTTCover  nodeDevTableTopicWithAPNS:_apsn luid:_luid];

    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    _devOpr = XAIDevOpr_GetInfo;
    _DEF_XTO_TIME_Start;

}

//- (void) stopGetInfo{
//    
//    _DEF_XTO_TIME_End;
//    
//    NSString* _topic = [MQTTCover nodeDevTableTopicWithAPNS:_apsn luid:_luid];
//    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:_topic];
//    
//
//    
//}

-(void)timeout{
    
    
    if (_devOpr == XAIDevOpr_GetStatus &&
        nil != _delegate &&
        [_delegate respondsToSelector:@selector(device:getStatus:isSuccess:isTimeOut:)]) {
        
        [_delegate device:self getStatus:XAIDeviceStatus_UNKOWN isSuccess:false isTimeOut:true];
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
         [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DeviceStatusID]];
    }
    
    
    if (_devOpr == XAIDevOpr_GetInfo &&
        nil != _delegate &&
        [_delegate respondsToSelector:@selector(device:getInfoIsSuccess:isTimeOut:)]) {
        
        [_delegate device:self getInfoIsSuccess:false isTimeOut:true];
        
        
        NSString* _topic = [MQTTCover nodeDevTableTopicWithAPNS:_apsn luid:_luid];
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:_topic];
    }
    
    _DEF_XTO_TIME_End;
    
    [[MQTT shareMQTT].packetManager change];
    
}


- (void) _reciveStatusPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    return;
    
    //NSString* c = [[NSString alloc] initWithString:[MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DeviceStatusID]];
    
    if (![topic isEqualToString:[MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DeviceStatusID]]) {
        
        //NSLog(@"out-------");
        return;
    }
    
    
    _DEF_XTO_TIME_End;
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    BOOL  isSuccess = false;
    XAIDeviceStatus devStatus = XAIDeviceStatus_UNKOWN;
    
    do {
        
        if (NULL == param) break;
        
        _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
        
        if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || data->data_len <= 0)break;
        
        
        XAITYPEUNSIGN  devStatus_mem = 0;
        
        byte_data_copy(&devStatus_mem, data->data, sizeof(XAITYPEUNSIGN), data->data_len);
        
        
        if (devStatus_mem <= 2) { //devStatus_mem >= 0  unsigned number always true
            
            
            devStatus = (XAIDeviceStatus)devStatus_mem;
        }
        
        
        isSuccess = true;
        
        
    } while (0);
    
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(device:getStatus:isSuccess:isTimeOut:)]) {
        
        [_delegate device:self getStatus:devStatus isSuccess:isSuccess isTimeOut:false];
    }
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
     [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_DeviceStatusID]];
    
    purgePacketParamStatusAndData(param);

}

- (void) _reciveDevPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    if (![topic isEqualToString:[MQTTCover nodeDevTableTopicWithAPNS:_apsn luid:_luid]]) {
        
        return;
    }

    
     _DEF_XTO_TIME_End;
    
    _xai_packet_param_dti* dti = generateParamDTIFromData(datas, size);
    
    BOOL isSuc = false;
    
    do {
        
        if(![MQTTCover isNodeTopic:topic] || dti == NULL) break;
        
        XAITYPEAPSN apsn = [MQTTCover nodeTopicAPSN:topic];
        XAITYPELUID luid = [MQTTCover nodeTopicLUID:topic];
        
        if (_apsn != apsn || _luid != luid) break;
        
        NSString* model = [[NSString alloc] initWithUTF8String:(const char*)dti->model];
        NSString* vender = [[NSString alloc] initWithUTF8String:(const char*)dti->vender];
        
        
        
        _model = [[NSString alloc] initWithFormat:@"%@",[model uppercaseString]];
        _vender = vender;
        
        
        isSuc = true;
        
    } while (0);
    
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(device:getInfoIsSuccess:isTimeOut:)]) {
        
        [_delegate device:self getInfoIsSuccess:isSuc isTimeOut:false];
    }

    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:
     [MQTTCover nodeDevTableTopicWithAPNS:_apsn luid:_luid]];
    
    
    purgePacketParamDTI(dti);
}




- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    return;
    
    _xai_packet_param_normal* param = generateParamNormalFromData(datas, size);
    
    
    switch (param->flag) {
            
        case XAI_PKT_TYPE_STATUS:
        {
            [self _reciveStatusPacket:datas size:size topic:topic];
            
        }break;
            
        case XAI_PKT_TYPE_DEV_INFO_REPLY:
        {
            
            [self _reciveDevPacket:datas size:size topic:topic];
            
        }break;
            
        default:
            break;
    }
    
    
    purgePacketParamNormal(param);

    
    
    
  }

- (void)realInit{
    
    _devType = XAIDeviceType_UnKown;
    _corObjType = XAIObjectType_UnKown;
}

- (id)init{

    if (self = [super init]) {
        
        [self realInit];
    }
    
    return self;
}


- (void) willRemove{

    [super willRemove];
    //[[MQTT shareMQTT].packetManager forceRemovePacketManager:self];
}


-(void)dealloc{
    
    //
    XSLog(@"%s,%@,%p", __PRETTY_FUNCTION__,[[self class] description] ,self);
}

- (id) initWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid{
    
    if (self = [super init]) {
        
        _apsn = apsn;
        _luid = luid;
        [self realInit];

    }
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone
{
    XAIDevice* dev = [[XAIDevice allocWithZone:zone]init];
    dev.apsn = _apsn;
    dev.luid = _luid;
    dev.name = _name;
    dev.vender = _vender; /*生产商*/
    dev.model = _model; /*型号*/
    
    dev.corObjType = _corObjType;
    dev.devStatus = _devStatus;
    
    return dev;

}


- (void) startFocusStatus{}
- (void) endFocusStatus{}

@end


@implementation XAIOtherInfo
@end

