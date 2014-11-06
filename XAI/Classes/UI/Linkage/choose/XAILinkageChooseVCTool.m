//
//  XAILinkageChooseVCTool.m
//  XAI
//
//  Created by office on 14/11/6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageChooseVCTool.h"
#import "XAILinkageCondChooseVC.h"
#import "XAILinkageResultChooseVC.h"

@implementation XAILinkageChooseVCTool

+(XAILinkageChooseVC*)create:(XAILinkageOneType)type{

    if (type ==  XAILinkageOneType_yuanyin) {
        return [[XAILinkageCondChooseVC alloc] init];
    }else{
        return [[XAILinkageResultChooseVC alloc] init];
    }
}
@end
