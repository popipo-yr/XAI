//
//  XAIDebug.m
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDebug.h"

@implementation _XAIDebug

+ (void)debug:(NSString*)name obj:(id)obj sel:(SEL)sel param:(BOOL)bl time:(int)time{

    NSInvocation *anInvocation = [NSInvocation
                                  invocationWithMethodSignature:
                                  [NSClassFromString(name) instanceMethodSignatureForSelector:sel]];
    
    [anInvocation setSelector:sel];
    
    [anInvocation setTarget:obj];
    
    BOOL _bl = bl;
    [anInvocation setArgument:&_bl atIndex:2];
    
    [anInvocation performSelector:@selector(invoke) withObject:nil afterDelay:time];
    
    
}

@end
