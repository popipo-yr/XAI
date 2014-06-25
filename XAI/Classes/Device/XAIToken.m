//
//  XAIToken.m
//  XAI
//
//  Created by office on 14-6-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIToken.h"

#define _K_Register @"_K_Register"
#define _K_Token @"_K_Token"

@implementation XAIToken

+ (void) saveToken:(NSData*)token{
    
    if ([token length] == TokenSize) {
        
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:_K_Token];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:_K_Register];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL) getToken:(void**)tokenRet size:(int*)size{
    
    do {
        
        if (tokenRet == NULL) break;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:_K_Register] == false) break;

        NSData* tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:_K_Token];
        if (![tokenData isKindOfClass:[NSData class]]) break;
        if ([tokenData length] != TokenSize) break;
        
        memcpy(*tokenRet, [tokenData bytes],TokenSize);
        
        if (size != NULL) {
            
            *size = TokenSize;
        }
        
        return true;
    } while (0);
    

    return false;
}

+ (BOOL) hasToken{

    return [[NSUserDefaults standardUserDefaults] boolForKey:_K_Register];
}

@end
