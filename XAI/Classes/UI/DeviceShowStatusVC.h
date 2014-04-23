//
//  DeviceShowStatusVC.h
//  XAI
//
//  Created by office on 14-4-23.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIObject.h"

@interface DeviceShowStatusVC : UIViewController{

    UIImageView* _statusView;
    UIActivityIndicatorView* _activityView;
    UISwipeGestureRecognizer* _recognizer;
}


@property (nonatomic, strong) IBOutlet UIImageView* statusView;

@property (nonatomic, strong) IBOutlet UIView* secondView;

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer;


+ (DeviceShowStatusVC*) statusWithObject:(XAIObject*) aObj storyboard:(UIStoryboard*)storyboard ;

@end
