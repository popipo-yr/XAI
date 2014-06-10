//
//  XAIIPHelper.h
//  XAI
//
//  Created by office on 14-6-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XAIIPHelper : NSObject


- (int)getApserverIp:(const char*) host;


@end

int getdefaultgateway(in_addr_t * addr);
