//
//  XAINodeStatus.h
//  XAI
//
//  Created by office on 15/1/17.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIDevice.h"

@interface XAINodeStatus : NSObject <MQTTPacketManagerDelegate>{

    NSMutableDictionary* _saveInfo;
    BOOL _enabel;
}


-(void)enabel:(BOOL)enabel;
+ (XAINodeStatus*) instance;

@end
