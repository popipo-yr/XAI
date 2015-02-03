//
//  XAINodeStatus.m
//  XAI
//
//  Created by office on 15/1/17.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAINodeStatus.h"
#import "XAIPacketStatus.h"
#import "XAIObjectGenerate.h"
#import "XAIDoor.h"
#import "XAIIR.h"

@implementation XAINodeStatus

+(XAINodeStatus *)instance{

    static XAINodeStatus* _s_status = nil;
    
    if (_s_status == nil) {
        
        dispatch_once_t predicate = 0;
        dispatch_once(&predicate, ^{
            
            _s_status = [[XAINodeStatus alloc] init];
        });
    }
    
    
    return _s_status;
}

- (void)recivePacket:(void *)datas size:(int)size topic:(NSString *)topic mosqMsg:(MosquittoMessage *)mosq_msg{
    
    if (![MQTTCover isNodeStatusTopic:topic]) return;
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    if (NULL == param) return;
    
    XAITYPELUID  fromluid =  luidFromGUID(param->normal_param->from_guid);
    NSString* luidStr = [MQTTCover luidToString:fromluid];

    //查看状态的topic
    if ([luidStr hasPrefix:@"0x0005"]) {
        
        XAIDevDoorContactStatus curStatus = XAIDevDoorContactStatusUnkown;
        
        do {
            
            if (NULL == param) break;
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
            
            if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_BOOL) || data->data_len <= 0)break;
            
            XAITYPEBOOL isOpen;
            
            byte_data_copy(&isOpen, data->data, sizeof(XAITYPEBOOL), data->data_len);
            
            
            curStatus = [self coverPacketBOOLToDoorContactStatus:isOpen];
            
            if (curStatus == XAIDevDoorContactStatusUnkown) break;
            
            XAIDoor* door = [_saveInfo objectForKey:[NSNumber numberWithInt:fromluid]];
            if (nil == door || ![door isKindOfClass:[XAIDoor class]]) {
                /*服务器上的数据*/
                XAIDevice* aDevice = [[XAIDevice alloc] init];
                aDevice.luid = fromluid;
                aDevice.apsn = apsnFromGUID(param->normal_param->from_guid);
                aDevice.devType = XAIDeviceType_door;
                aDevice.corObjType = XAIObjectType_door;
                
                
                door = [[XAIDoor alloc] init];
                [door setInfoFromDevice:aDevice];

                [_saveInfo setObject:door forKey:[NSNumber numberWithInt:fromluid]];
            }
            
           
            XAIOtherInfo* otherInfo = [[XAIOtherInfo alloc] init];
            otherInfo.time = param->time;
            otherInfo.msgid = mosq_msg.mid;
            otherInfo.fromluid =  luidFromGUID(param->normal_param->from_guid);
            
            [door doorContact:nil status:curStatus err:XAI_ERROR_NONE otherInfo:otherInfo];
            
        } while (0);
        
        
    }else if([luidStr hasPrefix:@"0x0004"]) {
        
        XAIDevInfraredStatus curStatus = XAIDevInfraredStatusUnkown;
        
        do {
            
            if (NULL == param) break;
            
            _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
            
            if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_BOOL) || data->data_len <= 0)break;
            
            XAITYPEBOOL bStatus;
            
            byte_data_copy(&bStatus, data->data, sizeof(XAITYPEBOOL), data->data_len);
            
            
            curStatus = [self coverPacketBOOLToInfraredStatus:bStatus];
            
            if (curStatus == XAIDevInfraredStatusUnkown) break;
            
            
            XAIIR* ir = [_saveInfo objectForKey:[NSNumber numberWithInt:fromluid]];
            if (nil == ir || ![ir isKindOfClass:[XAIIR class]]) {
                /*服务器上的数据*/
                XAIDevice* aDevice = [[XAIDevice alloc] init];
                aDevice.luid = fromluid;
                aDevice.apsn = apsnFromGUID(param->normal_param->from_guid);
                aDevice.devType = XAIDeviceType_door;
                aDevice.corObjType = XAIObjectType_door;
                
                
                ir = [[XAIIR alloc] init];
                [ir setInfoFromDevice:aDevice];
                
                [_saveInfo setObject:ir forKey:[NSNumber numberWithInt:fromluid]];
            }
            
            
            XAIOtherInfo* otherInfo = [[XAIOtherInfo alloc] init];
            otherInfo.time = param->time;
            otherInfo.msgid = mosq_msg.mid;
            otherInfo.fromluid =  luidFromGUID(param->normal_param->from_guid);
            
            [ir infrared:nil status:curStatus err:XAI_ERROR_NONE otherInfo:otherInfo];
        } while (0);

    }
    purgePacketParamStatusAndData(param);
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

- (XAIDevInfraredStatus) coverPacketBOOLToInfraredStatus:(XAITYPEBOOL)typeBool{
    
    XAIDevInfraredStatus retStatus = XAIDevInfraredStatusUnkown;
    
    if (typeBool == XAITYPEBOOL_TRUE) {
        
        retStatus = XAIDevInfraredStatusDetectorThing;
        
    }else if(typeBool == XAITYPEBOOL_FALSE){
        
        retStatus = XAIDevInfraredStatusDetectorNothing;
        
    }
    
    return retStatus;
}


-(void)enabel:(BOOL)enabel{

    if (enabel == true) {
        
        if (_enabel == false) {
            [[MQTT shareMQTT].packetManager  addPacketManagerNoAccept:self];
        }
    
        
    }else{
    
        if (_enabel == true) {
            [[MQTT shareMQTT].packetManager removePacketManagerNoAccept:self];
            
        
            for (id key in _saveInfo) {
                XAIObject* obj = _saveInfo[key];
                if (![obj isKindOfClass:[XAIObject class]]) continue;
                [obj timeout];
            }
            
            [_saveInfo  removeAllObjects];
        }

    }
    
    _enabel = enabel;
}


-(instancetype)init{

    if (self = [super init]) {
        _saveInfo = [[NSMutableDictionary alloc] init];
        _enabel = false;
    }
    
    return self;
}


@end
