//
//  XAIUser.m
//  XAI
//
//  Created by office on 14-4-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUser.h"
#import "XAIMQTTDEF.h"

@implementation XAIUser

- (BOOL) isAdmin{

   return  _luid == XAIUSERADMIN;
}
@end
