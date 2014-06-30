//
//  XAIMobileControl.h
//  XAI
//
//  Created by office on 14-6-30.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTTPacketManager.h"

@interface XAIMobileControl : NSObject <MQTTPacketManagerDelegate>

- (void) startListene;
- (void) stopListene;

@end


@interface XAIMCCMD : NSObject


@end

@protocol XAIMobileControlDelegate <NSObject>

- (void) mobileControl:(XAIMobileControl*)mc getCmd:(XAIMCCMD*)cmd;

@end

