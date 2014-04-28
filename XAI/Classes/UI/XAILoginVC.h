//
//  AAViewController.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAILogin.h"
#import "XAIUserService.h"
#import "XAIDeviceService.h"

@interface XAILoginVC : UIViewController
<XAILoginDelegate,XAIDeviceServiceDelegate,XAIUserServiceDelegate>{


    XAILogin*  _login;
    
    UIActivityIndicatorView* _activityView;
    
    XAIUserService* _userService;
    XAIDeviceService* _devService;
    
    int _findUser;
    int _findDev;
}


@property  (nonatomic,weak) IBOutlet UITextField* nameLabel;
@property  (nonatomic,weak) IBOutlet UITextField* passwordLabel;

- (IBAction)loginBtnClick:(id)sender;


@end
