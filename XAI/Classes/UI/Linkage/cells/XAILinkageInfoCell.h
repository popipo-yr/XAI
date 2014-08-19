//
//  XAILinkageInfoCell.h
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"

#define XAILinkageInfoCellID @"XAILinkageInfoCellID"
//@interface XAILinkageInfoCell : XAIObjectCell
@interface XAILinkageInfoCell : SWTableViewCell

@property (nonatomic,strong) IBOutlet UILabel* label;
@property (nonatomic,strong) IBOutlet UIImageView* tipView;


- (void) setTiaojian:(NSString*)str;
- (void) setJieGuo:(NSString*)str;

- (void) setTiaojianTip:(NSString*)str;
- (void) setJieGuoTip:(NSString*)str;

@end
