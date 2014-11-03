//
//  XAIDevHistoryVC.h
//  XAI
//
//  Created by office on 14/11/3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIObject.h"

@interface XAIDevHistoryVC : UIViewController{

    NSArray*  _datas;
}


@property (nonatomic,strong) XAIObject*  corObj;
@property (nonatomic,strong) UIViewController*  retVC;
@property (nonatomic,strong) IBOutlet UITableView* tableView;

-(IBAction)closeClick:(id)sender;
-(IBAction)clearClick:(id)sender;

+(XAIDevHistoryVC *)create;



@end

#define _C_XAIDevHistoryVCCellHeight 60
#define _C_XAIDevHistoryVCCellID @"XAIDevHistoryVCCellID"
@interface XAIDevHistoryVCCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel* contentLab;

@end
