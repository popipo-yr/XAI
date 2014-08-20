//
//  XAIMobileControl.h
//  XAI
//
//  Created by office on 14-6-30.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTTPacketManager.h"
#import "XAIMQTTDEF.h"
#import "XAIDevice.h"

@protocol XAIMobileControlDelegate;
@interface XAIMobileControl : XAIDevice <MQTTPacketManagerDelegate>

- (void) startListene;
- (void) stopListene;


- (void) sendMsg:(NSString*)context toApsn:(XAITYPEAPSN)apsn toLuid:(XAITYPELUID)luid;

@property(nonatomic,assign) id<XAIMobileControlDelegate> mobileDelegate;

@end


@interface XAIMCCMD : NSObject


@end

@protocol XAIMobileControlDelegate <NSObject>

@optional
- (void) mobileControl:(XAIMobileControl*)mc getCmd:(XAIMCCMD*)cmd;
- (void) mobileControl:(XAIMobileControl *)mc sendStatus:(XAI_ERROR)err;
- (void) mobileControl:(XAIMobileControl *)mc newMsg:(XAIMeg*)msg;

@end

