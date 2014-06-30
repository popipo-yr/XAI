//
//  XAIMobileControl.h
//  XAI
//
//  Created by office on 14-6-30.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTTPacketManager.h"

@protocol XAIMobileControlDelegate;
@interface XAIMobileControl : NSObject <MQTTPacketManagerDelegate>

- (void) startListene;
- (void) stopListene;

@property(nonatomic,assign) id<XAIMobileControlDelegate> delegate;

@end


@interface XAIMCCMD : NSObject


@end

@protocol XAIMobileControlDelegate <NSObject>

- (void) mobileControl:(XAIMobileControl*)mc getCmd:(XAIMCCMD*)cmd;

@end

