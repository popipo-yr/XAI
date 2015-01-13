//
//  DevAddViewController.h
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIDeviceService.h"

@interface XAIDevAddVC : UIViewController
<XAIDeviceServiceDelegate,UIAlertViewDelegate>{

    NSString* _luidStr;
    
    UITextField * _nameTextField;
    
    XAIDeviceService* _deviceService;
    
    UIActivityIndicatorView* _activityView;
}

+ (UIViewController*)create:(NSString*)luidStr;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UINavigationItem* cNavigationItem;
@property (strong, nonatomic) IBOutlet UINavigationBar*  cNavBar;
@property (strong, nonatomic) IBOutlet UILabel* tipLabel;

@property (nonatomic,strong) NSString* luidStr;

@end
