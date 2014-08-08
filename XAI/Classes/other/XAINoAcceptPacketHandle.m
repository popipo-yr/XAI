//
//  XAINoAcceptPacketHandle.m
//  XAI
//
//  Created by office on 14-7-30.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAINoAcceptPacketHandle.h"
#import "XAIPacketStatus.h"
#import "MQTTCover.h"
#import "XAIData.h"

#import "XAILight.h"

@implementation XAINoAcceptPacketHandle

- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic{
  
    do {
        
        /*不是设备状态数据则不进行处理*/
        if ([MQTTCover isNodeStatusTopic:topic] == false) { break;}
        
        XAIObject* obj = [[XAIData shareData] findObj:0x210e2b26 luid:0x124b000413c931];
        
        if (obj == nil) {break;}
        
        [obj step];
        
        XAIDevice* dev = [obj curDevice];
        
        if (dev == nil || ![dev respondsToSelector:@selector(recivePacket:size:topic:)]) { break;}
        
        [dev recivePacket:datas size:size topic:topic];
        
        
    } while (0);

}

@end
