//
//  XAIDebug.h
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _XAIDebug : NSObject


+ (void)debug:(NSString*)name obj:(id)obj sel:(SEL)sel param:(BOOL)bl time:(int)time;

@end


#define XAIDebug(name,_obj,_sel,p_bl,_time) [_XAIDebug debug:name obj:_obj sel:_sel  param:p_bl time:_time]
