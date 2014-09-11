//
//  XAIUserServerListCell.h
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"

#define XAIUserServerListCellID @"XAIUserServerListCellID"

@interface XAIUserServerListCell : XAIObjectCell{

    UILabel* _label;
}

@property (nonatomic, weak)  NSObject*  hasMe;

- (void) setInfo:(XAIUser*)object;
- (void)changeHead:(XAIUser*)aUser;
@end
