//
//  XAILinkageListCell.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"
#import "XAILinkage.h"

#define XAILinkageListCellID @"XAILinkageListCellID"
@interface XAILinkageListCell : XAIObjectCell

@property (nonatomic, weak)  NSObject*  hasMe;

- (void) setInfo:(XAILinkage*)linkage;
-  (void) setAdd;

@end
