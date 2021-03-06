//
//  XAITimeOut.m
//  XAI
//
//  Created by office on 14-5-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITimeOut.h"

@implementation XAITimeOut

-(id)init{

    if (self = [super init]) {
        
        _timeout = nil;
    }
    
    return self;
}


-(void)dealloc{
    
    if (_timeout != nil) {
        [_timeout invalidate];
        _timeout = nil;
    }
}

- (void) willRemove{

    if (_timeout != nil) {
        [self timeout];
        [_timeout invalidate];
        _timeout = nil;
    }

}

- (void) timeout{};

@end
