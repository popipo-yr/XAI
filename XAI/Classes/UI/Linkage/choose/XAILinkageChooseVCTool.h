//
//  XAILinkageChooseVCTool.h
//  XAI
//
//  Created by office on 14/11/6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageChooseVC.h"

typedef enum {
    
    XAILinkageOneType_yuanyin,
    XAILinkageOneType_jieguo,
    
}XAILinkageOneType;

@interface XAILinkageChooseVCTool : NSObject


+(XAILinkageChooseVC*)create:(XAILinkageOneType)type;

@end
