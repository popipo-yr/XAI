//
//  XAIDoorWinCell.h
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"
#import "XAIWindow.h"
#import "XAIDoor.h"

#define  XAIDoorWinCellID @"XAIDoorWinCellID"
@interface XAIDoorWinCell : XAIObjectCell<XAIWindownDelegate,XAIDoorDelegate>

@property (nonatomic,weak) XAIObject* weakObj;

- (void) setInfo:(XAIObject*)object;
@end
