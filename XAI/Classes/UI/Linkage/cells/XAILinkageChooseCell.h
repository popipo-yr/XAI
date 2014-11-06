//
//  XAILinkageInfoAddCell.h
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


#define _C_XAILinkageChooseCellID @"XAILinkageChooseCellID"

@interface XAILinkageChooseCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel* label;

- (void) setTip:(NSString*)tip;

@end
