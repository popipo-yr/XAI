//
//  XAIInfListCell.h
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"
#import "XAIIR.h"

#define  XAIInfListCellID @"XAIInfListCellID"

@interface XAIInfListCell : XAIObjectCell<XAIIRDelegate>{

    NSTimer* timer;
}

@property (nonatomic,weak) XAIObject* weakObj;
- (void) setInfo:(XAIObject*)object;

@end
