//
//  XAIStatus.m
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIStatus.h"

@implementation XAIStatus

-(id)init{

    if (self = [super init]) {

        _curOprStatus = XAIObjectOprStatus_none;
    }
    
    return self;
}

- (void) startOpr{
    _curOprStatus = XAIObjectOprStatus_start;
}
- (void) endOpr{
    _curOprStatus = XAIObjectOprStatus_none;
    _curOprtip = nil;
}

- (void) showMsg{
    
    _curOprStatus = XAIObjectOprStatus_showMsg;
    [self performSelector:@selector(endOpr) withObject:nil afterDelay:3.0f];
}


@end
