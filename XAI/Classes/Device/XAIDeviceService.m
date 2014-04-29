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
#import "XAIPacketDevTypeInfo.h"

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



/*开启定时*/
- (void) findAllDevWithApsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{

    
    
    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:apsn
                                                         luid:luid
                                                        other:MQTTCover_DevTable_Other];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    
   
}

- (void) stopfindAllOnlineDev{
    
    [_timer invalidate];
    _timer = nil;
    
    for (id obj in _allDevices) {
        
        if (![obj isKindOfClass:[XAIDevice class]]) continue;
        
        //        XAITYPELUID luid;
        //        NSScanner* scanner = [NSScanner scannerWithString:obj];
        //        [scanner scanHexLongLong:&luid];
        XAIDevice*  dev = obj;
        
        NSString* topic = [MQTTCover nodeDevTableTopicWithAPNS:dev.apsn luid:dev.luid];
        //[MQTTCover nodeStatusTopicWithAPNS:_apsn luid:luid other:Key_DeviceStatusID];
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topic];
        [[MQTT shareMQTT].client unsubscribe:topic];
    }

    
    
    if (_deviceServiceDelegate != nil &&
        [_deviceServiceDelegate respondsToSelector:@selector(devService:finddedAllOnlineDevices:status:errcode:)]) {
        
        [_deviceServiceDelegate  devService:self finddedAllOnlineDevices:_onlineDevices status:YES errcode:XAI_ERROR_OK];
    }
    
    _bFinding = false;
}

- (void) startFindOnline{

    if (!_bFinding) return;
    
    for (id obj in _allDevices) {
        
        if (![obj isKindOfClass:[XAIDevice class]]) continue;
        
//        XAITYPELUID luid;
//        NSScanner* scanner = [NSScanner scannerWithString:obj];
//        [scanner scanHexLongLong:&luid];
        XAIDevice*  dev = obj;
        
        NSString* topic = [MQTTCover nodeDevTableTopicWithAPNS:dev.apsn luid:dev.luid];
        
        [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topic];
        [[MQTT shareMQTT].client subscribe:topic];
    }
}

- (void) findAllOnlineDevWithApsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid useSecond:(int) sec{

    if (_bFinding) {
        
        return;
    }
    
    [_onlineDevices removeAllObjects];
    _bFinding = YES;
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:sec  // 10ms
                                             target:self
                                           selector:@selector(stopfindAllOnlineDev)
                                           userInfo:nil
                                            repeats:YES];
    
    [self findAllDevWithApsn:apsn luid:luid];
}

#pragma mark -- Helper

- (int) findAllDevWithParamStatus:(_xai_packet_param_status*) param{
    
    [_allDevices removeAllObjects];
    
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
            
            
            [_allDevices addObject:aDevice];
            
            
        } while (0);
        
        if (allType) {
            
            [devAry addObject:aDevice];
        }
        
    }
    
    if ((nil != _deviceServiceDelegate) &&
        [_deviceServiceDelegate respondsToSelector:@selector(devService:findedAllDevice:status:errcode:)]) {
        
        [_deviceServiceDelegate devService:self findedAllDevice:devAry status:YES errcode:XAI_ERROR_OK];
    }
    
    
    if (_bFinding) {/*查找在线的设备*/
        
        [self startFindOnline];
        
    }

    
    return 0;
}


#pragma mark -- MQTTPacketManagerDelegate
- (void)reciveACKPacket:(void*)datas size:(int)size topic:topic{
    
    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    if (ack == NULL) return;
    
    
    BOOL bSuccess = (ack->err_no == XAI_ERROR_OK);
    
    switch (ack->scid) {
        case AddDevID:{
            
            if ((nil != _deviceServiceDelegate) &&
                [_deviceServiceDelegate respondsToSelector:@selector(devService:addDevice:errcode:)]) {
                
                [_deviceServiceDelegate devService:self addDevice:bSuccess errcode:ack->err_no];
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            
        }break;
            
        case DelDevID:{
            
            if ((nil != _deviceServiceDelegate) &&
                [_deviceServiceDelegate respondsToSelector:@selector(devService:delDevice:errcode:)]) {
                
                [_deviceServiceDelegate devService:self delDevice:bSuccess errcode:ack->err_no];
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
        }break;
            
        case AlterDevNameID:{
            
            if ((nil != _deviceServiceDelegate) &&
                [_deviceServiceDelegate respondsToSelector:@selector(devService:changeDevName:errcode:)]) {
                
                [_deviceServiceDelegate devService:self changeDevName:bSuccess errcode:ack->err_no];
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

    if ([MQTTCover isServerTopic:topic]) {
        
        switch (status->oprId) {
            case DevTableID:
            {
                
                [self findAllDevWithParamStatus:status];
                
                
            }break;
                
            default:break;
        }
    
    }
    
    purgePacketParamStatusAndData(status);
}

- (void) reciveDevPacket:(void*)datas size:(int)size topic:topic{
    
    _xai_packet_param_dti* dti = generateParamDTIFromData(datas, size);
    
    
  if([MQTTCover isNodeTopic:topic] && dti != NULL){
      
      XAITYPEAPSN apsn = [MQTTCover nodeTopicAPSN:topic];
      XAITYPELUID luid = [MQTTCover nodeTopicLUID:topic];
      
      XAIDevice*  oneDev = nil;
      
      NSEnumerator *enumerator = [_allDevices objectEnumerator];
      for (XAIDevice *aDev in enumerator) {
         
          if (aDev.apsn == apsn && aDev.luid == luid) {
              
              oneDev = aDev;
              break;
          }
      }
      
      
      if (nil !=  oneDev) {
          
          
          NSString* model = [[NSString alloc]initWithBytes:dti->model
                                                    length:sizeof(dti->model) encoding:NSUTF8StringEncoding];
          NSString* vender = [[NSString alloc] initWithBytes:dti->vender
                                                      length:sizeof(dti->vender) encoding:NSUTF8StringEncoding];
          
          oneDev.model = model;
          oneDev.vender = vender;
          
          oneDev.type = XAIObjectType_light;/*mustchange*/
          
          [_onlineDevices addObject:oneDev];

      }
      
  }
    
    purgePacketParamDTI(dti);
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
            
        case XAI_PKT_TYPE_DEV_INFO_REPLY:
        {
            
            [self reciveDevPacket:datas size:size topic:topic];
        
        }break;
            
        default:
            break;
    }
    
    
    purgePacketParamNormal(param);
}


- (void) _init{

    _onlineDevices = [[NSMutableSet alloc] init];
    _allDevices = [[NSMutableSet alloc] init];
    _bFinding = false;
    _timer = nil;
}


- (id) init{

    if (self = [super init]) {
        
        [self _init];

    }
    
    return self;
}


- (id) initWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid{

    if (self = [super initWithApsn:apsn Luid:luid]) {
        
        [self _init];
    }
    
    return self;

}

- (void) dealloc{
    
    if (_timer != nil) {
        
        [_timer invalidate];
        _timer = nil;
    }
    
    _allDevices = nil;
    _onlineDevices = nil;

}


- (void) addDev:(XAITYPELUID)dluid  withName:(NSString*)devName{

    [self addDev:dluid withName:devName apsn:_apsn luid:_luid];
}

- (void) delDev:(XAITYPELUID)dluid{

    [self delDev:dluid apsn:_apsn luid:_luid];
}

- (void) changeDev:(XAITYPELUID)dluid withName:(NSString*)newName{

    [self changeDev:dluid withName:newName apsn:_apsn luid:_luid];
}

- (void) findAllDev{

    [self findAllDevWithApsn:_apsn luid:_luid];
}

/*获取路由下所有在线设备的luid,订阅所有设备的status节点,返回信息的则在线*/
- (void) findAllOnlineDevWithuseSecond:(int) sec{

    [self findAllOnlineDevWithApsn:_apsn luid:_luid useSecond:sec];
}


@end


