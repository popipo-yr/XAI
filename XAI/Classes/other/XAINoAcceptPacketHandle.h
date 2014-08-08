//
//  XAINoAcceptPacketHandle.h
//  XAI
//
//  Created by office on 14-7-30.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//


/*
 没有接受的报文全部放到这里取处理,主要处理设备的状态
 */

#import "MQTTPacketManager.h"


@interface XAINoAcceptPacketHandle : NSObject <MQTTPacketManagerDelegate>



@end
