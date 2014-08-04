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


- (void) addDev:(XAITYPELUID)dluid  withName:(NSString*)devName type:(XAIDeviceType)type
           apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid
{
    
    MQTT* curMQTT = [MQTT shareMQTT];

    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* name_data = generatePacketParamData();
    _xai_packet_param_data* type_data = generatePacketParamData();
    
    
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_APSN , sizeof(XAITYPEAPSN), &apsn,luid_data);
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID, sizeof(XAITYPELUID), &dluid,name_data);
    
    NSData* data = [devName dataUsingEncoding:NSUTF8StringEncoding];
    xai_param_data_set(name_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [data length], (void*)[devName UTF8String],type_data);
    
    
//    NSString* typestr = @"中文";
//    NSData* typeData  = [typestr dataUsingEncoding:NSUTF8StringEncoding];
//    xai_param_data_set(type_data, XAI_DATA_TYPE_ASCII_TEXT,
//                       [typeData length], (void*)[typestr UTF8String],NULL);
    /*一个字节*/
    xai_param_data_set(type_data, XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN, sizeof(uint8_t), &type,NULL);

    
    xai_param_ctrl_set(param_ctrl, curMQTT.apsn, curMQTT.luid, apsn, luid, XAI_PKT_TYPE_CONTROL,
                       0, 0, AddDevID,[[NSDate new] timeIntervalSince1970],4, apsn_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self] ;
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:[MQTTCover serverCtrlTopicWithAPNS:apsn luid:luid]
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    

    _devOpr = XAIDevServiceOpr_add;
    _DEF_XTO_TIME_Start

}
- (void) delDev:(XAITYPELUID)dluid apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{
    
    
    MQTT* curMQTT = [MQTT shareMQTT];

    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    //param
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    _xai_packet_param_data* luid_data = generatePacketParamData();
    
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_APSN , sizeof(XAITYPEAPSN), &apsn,luid_data);
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

    _devOpr = XAIDevServiceOpr_del;
    _DEF_XTO_TIME_Start

}
- (void) changeDev:(XAITYPELUID)dluid withName:(NSString*)newName apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{

    MQTT* curMQTT = [MQTT shareMQTT];
    
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
     _xai_packet_param_data* apsn_data = generatePacketParamData();
    _xai_packet_param_data* luid_data = generatePacketParamData();
    _xai_packet_param_data* name_data = generatePacketParamData();
   
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_APSN , sizeof(XAITYPEAPSN), &apsn,luid_data);
    
    xai_param_data_set(luid_data, XAI_DATA_TYPE_BIN_LUID,
                       sizeof(XAITYPELUID), &dluid, name_data);
    
     NSData* data = [newName dataUsingEncoding:NSUTF8StringEncoding];
    xai_param_data_set(name_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [data length], (void*)[newName UTF8String],NULL);
    
    
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

    
    _devOpr = XAIDevServiceOpr_changeName;
    _DEF_XTO_TIME_Start

}



/*开启定时*/
- (void) findAllDevWithApsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid{

    
    
    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:apsn
                                                         luid:luid
                                                        other:MQTTCover_DevTable_Other];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    if (!_bFinding) {
     
        _devOpr = XAIDevServiceOpr_findAll;
        _DEF_XTO_TIME_Start
        
    }
   
}

- (void) stopfindAllOnlineDev{
    
    [_timer invalidate];
    _timer = nil;
    
//    for (id obj in _allDevices) {
//        
//        if (![obj isKindOfClass:[XAIDevice class]]) continue;
//        
//        XAIDevice*  dev = obj;
//        
//        NSString* topic = [MQTTCover nodeDevTableTopicWithAPNS:dev.apsn luid:dev.luid];
//        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topic];
//        [[MQTT shareMQTT].client unsubscribe:topic];
//    }
    
    if (_deviceServiceDelegate != nil &&
        [_deviceServiceDelegate respondsToSelector:@selector(devService:finddedAllOnlineDevices:status:errcode:)]) {
        
        [_deviceServiceDelegate  devService:self finddedAllOnlineDevices:_onlineDevices status:YES errcode:XAI_ERROR_NONE];
        
        
        _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevServiceOpr_findOnline);
    }
    
    _bFinding = false;
}

- (void) startFindOnline{

    if (!_bFinding) return;
    
    for (id obj in _allDevices) {
        
        if (![obj isKindOfClass:[XAIDevice class]]) continue;
        
        XAIDevice*  dev = obj;
        
        dev.delegate = self;
        [dev getDeviceInfo];
        
//        NSString* topic = [MQTTCover nodeDevTableTopicWithAPNS:dev.apsn luid:dev.luid];
//        
//        [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topic];
//        [[MQTT shareMQTT].client subscribe:topic];
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
    
    _devOpr = XAIDevServiceOpr_findOnline;
    _DEF_XTO_TIME_Start
}

#pragma mark -- Helper

- (int) findAllDevWithParamStatus:(_xai_packet_param_status*) param{
    
    [_allDevices removeAllObjects];
    
    NSMutableArray* devAry = [[NSMutableArray alloc] init];
    
    
    int devParamCout = 5; /*每个设备有5个参数*/
    
    int realCount = param->data_count / devParamCout;
    
    if ((0 != param->data_count % devParamCout) || realCount < 0) {
        
        realCount = 0;
        NSLog(@"err...");
    }
    
    for (int i = 0; i < realCount; i++) {
        
        XAIDevice* aDevice = [[XAIDevice alloc] init];
        
        BOOL  allType = false;
        
        do {
            
            _xai_packet_param_data* status_data = getParamDataFromParamStatus(param, i*devParamCout + 4);
            
            if (status_data == NULL || (status_data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || status_data->data_len <= 0) break;
            
            
            XAITYPEUNSIGN  devStatus_mem = 0;
            
            byte_data_copy(&devStatus_mem, status_data->data, sizeof(XAITYPEUNSIGN), status_data->data_len);
            
            
            //if (devStatus_mem > 2) break; //devStatus_mem >= 0  unsigned number always true
                
            aDevice.devStatus = (XAIDeviceStatus)devStatus_mem;
        


            
            
            _xai_packet_param_data* type_data = getParamDataFromParamStatus(param, i*devParamCout + 3);
            
            if (type_data == NULL || (type_data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || type_data->data_len <= 0) break;
            
            
            uint8_t _type = *((uint8_t*)type_data->data);
            
            XAIDeviceType type = _type;
            aDevice.devType = type;
            
            

//            if (type_data->data_len != sizeof(XAIDeviceType)) {
//                
//                XAIDeviceType type = 0; //必须初始化
//                byte_data_copy(&type, type_data->data, sizeof(XAIDeviceType), type_data->data_len);
//                
//                aDevice.devType = type;
//                
//                
//            }else{
//            
//                XAIDeviceType type = *((XAIDeviceType*)(type_data->data));
//                aDevice.devType = type;
//            }
            

            
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, i*devParamCout + 2);
            
            if (data == NULL || (data->data_type != XAI_DATA_TYPE_ASCII_TEXT) || data->data_len <= 0) break;
            
            NSString* name = [[NSString alloc] initWithBytes:data->data length:data->data_len encoding:NSUTF8StringEncoding];
            
            aDevice.name = name;
            
            
            
            _xai_packet_param_data* luid_data = getParamDataFromParamStatus(param, i*devParamCout + 1);
            
            if (luid_data == NULL || (luid_data->data_type != XAI_DATA_TYPE_BIN_LUID) || luid_data->data_len <= 0) break;
            
            
            XAITYPELUID luid;
            byte_data_copy(&luid, luid_data->data, sizeof(XAITYPELUID), luid_data->data_len);
            
            
            aDevice.luid = luid;
            
            
            _xai_packet_param_data* apsn_data = getParamDataFromParamStatus(param, i*devParamCout + 0);
            
            if (apsn_data == NULL ||  (apsn_data->data_type != XAI_DATA_TYPE_BIN_APSN) || apsn_data->data_len <= 0) break;
            
            
            XAITYPEAPSN apsn;
            byte_data_copy(&apsn, apsn_data->data, sizeof(XAITYPEAPSN), apsn_data->data_len);
            
            
            aDevice.apsn = apsn;
            
            
            if ([self converToObjType:aDevice] == false) break;
            
            allType = YES;
            
            
            [_allDevices addObject:aDevice];
            
            
        } while (0);
        
        if (allType) {
            
            [devAry addObject:aDevice];
        }
        
    }
    
    if ((nil != _deviceServiceDelegate) &&
        [_deviceServiceDelegate respondsToSelector:@selector(devService:findedAllDevice:status:errcode:)]) {
        
        [_deviceServiceDelegate devService:self findedAllDevice:devAry status:YES errcode:XAI_ERROR_NONE];
        
        _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevServiceOpr_findAll);
    }
    
    
    if (_bFinding) {/*查找在线的设备*/
        
        [self startFindOnline];
        
    }

    
    return 0;
}


- (BOOL) converToObjType:(XAIDevice*)device{
    
    BOOL isSuc = true;

    switch (device.devType) {
        case XAIDeviceType_light:{
            
            device.corObjType = XAIObjectType_light;
            
        }
            break;
        case XAIDeviceType_light_2:{
            
            device.corObjType = XAIObjectType_light2_1;
            
        }
            break;
        case XAIDeviceType_window:{
            
            device.corObjType = XAIObjectType_window;
            
        }
            break;
        case XAIDeviceType_door:{
            
            device.corObjType = XAIObjectType_door;
        }
            break;
            
        case XAIDeviceType_Inf:{
            device.corObjType = XAIObjectType_IR;
        }
            break;
            
        default:{
            
            isSuc = false;
        }
        break;
    }
    
    return isSuc;

}

#pragma mark - Device Delegate
-(void)device:(XAIDevice *)device getInfoIsSuccess:(BOOL)bSuccess isTimeOut:(BOOL)bTimeOut{

    
    if (bSuccess) {
        
        
        
        
//        /*mustchange*/
//        if ([device.model isEqualToString:@"SWITCH-1"]) {//单控灯
//            
//            device.type = XAIObjectType_light;
//            
//        }else if([device.model isEqualToString:@"MAGNET"]){
//            
//            device.type = XAIObjectType_window;
//            
//        }else{
//            
//            device.type = XAIObjectType_light;
//            
//        }
//        
//        if ([device.model isEqualToString:@"SWITCH-2"]) {//双控灯
//            
//            XAIDevice* dev2 = [device copy];
//            dev2.type = XAIObjectType_light2_1;
//            [_onlineDevices addObject:dev2]; //添加2次
//        }
        
        
        /*mustchange*/
        
        if ([self converToObjType:device]) {
            
            if (device.devType == XAIDeviceType_light_2) {
                
                XAIDevice* dev2 = [device copy];
                dev2.corObjType = XAIObjectType_light2_2;
                [_onlineDevices addObject:dev2]; //添加2次
            
            }
            
            [_onlineDevices addObject:device];
            
        }
        
        
        
        if(_timer != nil){
            
            [_timer invalidate];
            
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5  // 10ms
                                                  target:self
                                                selector:@selector(stopfindAllOnlineDev)
                                                userInfo:nil
                                                 repeats:YES];
        
    }

}


#pragma mark -- MQTTPacketManagerDelegate
- (void)reciveACKPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    if (ack == NULL) return;
    
    
    BOOL bSuccess = (ack->err_no == XAI_ERROR_NONE);
    
    switch (ack->scid) {
        case AddDevID:{
            
            if ((nil != _deviceServiceDelegate) &&
                [_deviceServiceDelegate respondsToSelector:@selector(devService:addDevice:errcode:)]) {
                
                [_deviceServiceDelegate devService:self addDevice:bSuccess errcode:ack->err_no];
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevServiceOpr_add);
            
        }break;
            
        case DelDevID:{
            
            if ((nil != _deviceServiceDelegate) &&
                [_deviceServiceDelegate respondsToSelector:@selector(devService:delDevice:errcode:)]) {
                
                [_deviceServiceDelegate devService:self delDevice:bSuccess errcode:ack->err_no];
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevServiceOpr_del);
            
        }break;
            
        case AlterDevNameID:{
            
            if ((nil != _deviceServiceDelegate) &&
                [_deviceServiceDelegate respondsToSelector:@selector(devService:changeDevName:errcode:)]) {
                
                [_deviceServiceDelegate devService:self changeDevName:bSuccess errcode:ack->err_no];
            }
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevServiceOpr_changeName);
            
            
        }break;
            
            
        default:break;
    }
    
    purgePacketParamACKAndData(ack);
    
}


- (void) reciveStatusPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_status* status = generateParamStatusFromData(datas, size);
    if (status == NULL) return;

    if ([MQTTCover isServerTopic:topic]) {
        
        switch (status->oprId) {
            case DevTableID:
            {
                NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                                     luid:_luid
                                                                    other:MQTTCover_DevTable_Other];
                
                [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
                
                [self findAllDevWithParamStatus:status];
                
                
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
            
        case XAI_PKT_TYPE_DEV_INFO_REPLY:
        {
            
            //[self reciveDevPacket:datas size:size topic:topic];
        
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


static int __k = 0;
- (id) initWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid{
    
    if (self = [super initWithApsn:apsn Luid:luid]) {
        [self _init];
        __k += 1;
        NSLog(@"++++++++++:%d",__k);
    }
    return self;
}
-(id)init{
    
    if (self = [super init]) {
        [self _init];
        __k += 1;
        NSLog(@"++++++++++:%d",__k);
    }
    
    return self;
}

-(void)dealloc{
    if (_timer != nil) {
        
        [_timer invalidate];
        _timer = nil;
    }
    
    _allDevices = nil;
    _onlineDevices = nil;
    
    __k -= 1;
    NSLog(@"-----------:%d",__k);
    
}


- (void) addDev:(XAITYPELUID)dluid  withName:(NSString*)devName type:(XAIDeviceType)type{

    [self addDev:dluid withName:devName type:type apsn:_apsn luid:_luid];
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

- (void) _setFindOnline{

    [_onlineDevices removeAllObjects];
    _bFinding = true;
}


-(void)timeout{
    
    [super timeout];
    
    if (_devOpr == XAIDevServiceOpr_add &&
        (nil != _deviceServiceDelegate) &&
        [_deviceServiceDelegate respondsToSelector:@selector(devService:addDevice:errcode:)]) {
        
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            [_deviceServiceDelegate devService:self addDevice:false errcode:XAI_ERROR_TIMEOUT];
        
        }else if(_devOpr == XAIDevServiceOpr_del&&
             (nil != _deviceServiceDelegate) &&
             [_deviceServiceDelegate respondsToSelector:@selector(devService:delDevice:errcode:)]) {
        
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_deviceServiceDelegate devService:self delDevice:false errcode:XAI_ERROR_TIMEOUT];
            
    }else if(_devOpr == XAIDevServiceOpr_changeName&&
             (nil != _deviceServiceDelegate) &&
             [_deviceServiceDelegate respondsToSelector:@selector(devService:changeDevName:errcode:)]) {
        
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_deviceServiceDelegate devService:self changeDevName:false errcode:XAI_ERROR_TIMEOUT];
    
    }else if(_devOpr == XAIDevServiceOpr_findAll&&
            (nil != _deviceServiceDelegate) &&
            [_deviceServiceDelegate respondsToSelector:@selector(devService:findedAllDevice:status:errcode:)]) {
        
        
        NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                             luid:_luid
                                                            other:MQTTCover_DevTable_Other];
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
        [_deviceServiceDelegate devService:self findedAllDevice:nil status:false errcode: XAI_ERROR_TIMEOUT];
        
    }else if (_devOpr == XAIDevServiceOpr_findOnline&&
              (nil != _deviceServiceDelegate) &&
              [_deviceServiceDelegate respondsToSelector:@selector(devService:finddedAllOnlineDevices:status:errcode:)]) {
        
        NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                             luid:_luid
                                                            other:MQTTCover_DevTable_Other];
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
        [_deviceServiceDelegate devService:self finddedAllOnlineDevices:nil status:false errcode: XAI_ERROR_TIMEOUT];
    }
}

@end


