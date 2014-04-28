//
//  XAIData.m
//  XAI
//
//  Created by office on 14-4-28.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIData.h"

@implementation XAIData


static XAIData*  _s_XAIData_ = NULL;

+ (XAIData*) shareData{
    
    if (NULL == _s_XAIData_) {
        
        _s_XAIData_ = [[XAIData alloc] init];

    }
    
    return _s_XAIData_;
    
}


@end
