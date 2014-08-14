//
//  XAIHasTableViewVC.h
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"



@interface XAIHasTableViewVC : UIViewController <UITableViewDataSource,UITableViewDelegate>{

    UIActivityIndicatorView* _activityView;
    UIBarButtonItem* _editItem;
    
    UISwipeGestureRecognizer* _recognizer;
    
    NSIndexPath* _curDelIndexPath;
}

@property (nonatomic,strong) IBOutlet UITableView* tableView;

- (void)setSeparatorStyle:(int) count;

- (void) addBtnClick:(id) sender;
- (void) delBtnClick:(NSIndexPath*) index;


@end
