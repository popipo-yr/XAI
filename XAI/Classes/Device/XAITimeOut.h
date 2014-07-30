//
//  XAITimeOut.h
//  XAI
//
//  Created by office on 14-5-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface XAITimeOut : NSObject{

    NSTimer* _timeout;
}

- (void) timeout;

@end


#define _DEF_XTO_TIME  (5.0f)
#define _DEF_XTO_TIMEWait  (0.5f)

#define _DEF_XTO_TIME_End \
if (_timeout != nil) { \
[_timeout invalidate]; \
}


#define _DEF_XTO_TIME_Start \
_DEF_XTO_TIME_End \
_timeout = [NSTimer scheduledTimerWithTimeInterval:_DEF_XTO_TIME  \
                                            target:self  \
                                          selector:@selector(timeout) \
                                          userInfo:nil  \
                                           repeats:NO];


#define _DEF_XTO_TIME_END_TRUE(one,two) \
if (one  == two) { \
    _DEF_XTO_TIME_End \
}


#define _DEF_XTO_TIME_Wait \
_DEF_XTO_TIME_End \
_timeout = [NSTimer scheduledTimerWithTimeInterval:(_DEF_XTO_TIMEWait)  \
    target:self  \
    selector:@selector(timeout) \
    userInfo:nil  \
    repeats:NO];




