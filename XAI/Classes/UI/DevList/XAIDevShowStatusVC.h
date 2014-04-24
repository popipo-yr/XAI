//
//  DeviceShowStatusVC.h
//  XAI
//
//  Created by office on 14-4-23.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIObject.h"

@interface XAIDevShowStatusVC : UIViewController <UITableViewDataSource,UITableViewDelegate>{

    UIImageView* _statusView;
    UIActivityIndicatorView* _activityView;
    UISwipeGestureRecognizer* _recognizer;
    UISwipeGestureRecognizer* _recognizerRight;
    
    NSArray* _oprDatasAry;
}


@property (nonatomic, strong) IBOutlet UIImageView* statusView;

/*状态页面*/
@property (nonatomic, strong) IBOutlet UIView* secondView;
@property (nonatomic, strong) IBOutlet UITableView* oprTableView;
@property (nonatomic, strong) IBOutlet UILabel* modelLabel;
@property (nonatomic, strong) IBOutlet UILabel* factoryLabel;


- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer;


+ (XAIDevShowStatusVC*) statusWithObject:(XAIObject*) aObj storyboard:(UIStoryboard*)storyboard ;

@end


@interface XAIDevShowStatusVCCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic,strong)  IBOutlet UILabel*  oprLable;
@property (nonatomic,strong)  IBOutlet UILabel*  timeLable;

@end