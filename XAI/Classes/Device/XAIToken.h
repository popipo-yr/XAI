//
//  XAIToken.h
//  XAI
//
//  Created by office on 14-6-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TokenSize  (sizeof(uint8_t)*32)

@interface XAIToken : NSObject

+ (void) saveToken:(NSData*)token;
+ (BOOL) getToken:(void**)tokenRet size:(int*)size;
+ (BOOL) hasToken;

@end
