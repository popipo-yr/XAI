//
//  ManageCell.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAIDevManageCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic,strong)IBOutlet UIImageView* headImageView;
@property (nonatomic,strong)  IBOutlet UILabel*  nameLable;
@property (nonatomic,strong)  IBOutlet UILabel*  contextLable;

@end
