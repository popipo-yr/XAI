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
#import "XAIScanVC.h"
#import "XAIIPHelper.h"

@interface XAILoginVC : UIViewController
<XAILoginDelegate,XAIDeviceServiceDelegate,XAIUserServiceDelegate
,XAIScanVCDelegate,XAIIPHelperDelegate>{


    XAILogin*  _login;
    XAIIPHelper* _IPHelper;
    
    UIActivityIndicatorView* _activityView;
    
    XAIUserService* _userService;
    XAIDeviceService* _devService;
    
    int _findUser;
    int _findDev;
    
    BOOL _keyboardIsUp;
    BOOL _hasScan;
    BOOL _isLoging;
    
    NSString* _scanIP;
    XAITYPEAPSN _scanApsn;
}


@property  (nonatomic,strong) IBOutlet UITextField* nameLabel;
@property  (nonatomic,strong) IBOutlet UITextField* passwordLabel;
@property  (nonatomic,strong) IBOutlet UITextField* qrcodeLabel;
@property  (nonatomic,strong) IBOutlet UIView* qrcodeView;

-(IBAction)loginBtnClick:(id)sender;
-(IBAction)qrcodeBtnClick:(id)sender;
-(IBAction)closeKeyboard:(id)sender;


@end
