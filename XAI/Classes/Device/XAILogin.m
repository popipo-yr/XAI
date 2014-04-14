//
//  XAILogin.m
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILogin.h"
#import "XAIPacketStatus.h"
//#include "openssl/ssl.h"

@implementation XAILogin

- (void) loginWithName:(NSString*)name Password:(NSString*)password Host:(NSString*)host{

    MosquittoClient*  mosq = [MQTT shareMQTT].client;

    host = @"192.168.1.1";
    name = @"admin@0x00000001";
    password = @"admin";
    
    
	[mosq setHost: host];
    [mosq setUsername:name];
    [mosq setPassword:password];
    [mosq setPort:9001];	
    
    [[MQTT shareMQTT].packetManager setConnectDelegate:self];
    
    [mosq connect];

}

- (void) didConnect:(NSUInteger)code {
	
    NSString* topicStr = @"0x00000001/SERVER/0x0000000000000003/OUT/STATUS/0x01";
    [[MQTT shareMQTT].client subscribe:topicStr];
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
}

- (void) didDisconnect {
	
}

#pragma mark -------------
#pragma makr PacketPro

- (XAITYPELUID) finderUserLuidHelper:(NSString*)username paramStatus:(_xai_packet_param_status*) param{

    int realCount = param->data_count / 3;
    
    if ((0 != param->data_count % 3) || realCount < 1) {
        
        return -1;
    }
    
    for (int i = 0; i < realCount; i++) {
        
        BOOL find = FALSE;
        
       _xai_packet_param_data* data = getParamDataFromParamStatus(param, i*3 + 3 -1);
        if ((data->data_type == XAI_DATA_TYPE_ASCII_TEXT) || data->data_len > 0) {
            
            NSString* name = [[NSString alloc] initWithBytes:data->data length:data->data_len encoding:NSUTF8StringEncoding];
            
            if ([name isEqualToString:username]) {
                
                find = TRUE;
            }
        }
        
        if (find) {
            
            _xai_packet_param_data* luid_data = getParamDataFromParamStatus(param, i*3 + 2 -1);
            if ((data->data_type == XAI_DATA_TYPE_BIN_LUID) || data->data_len > 0) {
                
                XAITYPELUID luid;
                byte_data_copy(&luid, luid_data->data, sizeof(XAITYPELUID), luid_data->data_len);
                
                
                return luid;
            }
            
        }
    }
    
    
    
    return -1;
    
}

- (void) sendPacketIsSuccess:(BOOL) bl{
}
- (void) recivePacket:(void*)datas size:(int)size topic:topic{
    
    if ([topic isEqualToString:@"0x00000001/SERVER/0x0000000000000003/OUT/STATUS/0x01"]) {
        
        _xai_packet_param_status*  status = generateParamStatusFromData(datas,size);
        
        [self finderUserLuidHelper:@"admin" paramStatus:status];
       
        
    }
    //test.....
    
    
//    switch (ack->scid) {
//        case AddUserID:{
//            
//            if (ack->err_no == 0) {
//                
//            }else{
//                
//                NSLog(@"FAILD ADD USER ");
//            }
//            
//            [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topic];
//        }
//            
//            break;
//            
//        default:
//            break;
//    }
    
    
    NSLog(@"anc");
    
}

@end
