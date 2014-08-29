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
    UIBarButtonItem* _returnItem;
    
    //UISwipeGestureRecognizer* _recognizer;
    
    NSIndexPath* _curDelIndexPath;
    
    CGRect _oldRect;
}

@property (nonatomic,strong) IBOutlet UITableView* tableView;
@property (nonatomic,strong) IBOutlet UINavigationItem* theNavigationItem;

- (void)setSeparatorStyle:(int) count;
-(void)returnClick:(id)sender;

- (void)moveTableViewToOld;

@end
