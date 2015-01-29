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
#import "XAIApsnView.h"

@interface XAILoginVC : UIViewController
<XAILoginDelegate,XAIDeviceServiceDelegate,XAIUserServiceDelegate
,XAIScanVCDelegate,XAIIPHelperDelegate,XAIApsnViewDelegate,XAIApsnViewDataSource>{


    XAILogin*  _login;
    
    UIActivityIndicatorView* _activityView;
    
    XAIUserService* _userService;
    XAIDeviceService* _devService;
    
    int _findUser;
    int _findDev;
    
    BOOL _keyboardIsUp;
    BOOL _isLoging;
    

    XAITYPEAPSN _curApsn;
    
    BOOL _pushScan;
    BOOL _beBackgroud;
    
    NSMutableArray* _apsnDatas;
    XAIApsnView* _apsnView;
    NSUInteger  _apsnCurIndex;
}


@property  (nonatomic,strong) IBOutlet UITextField* nameLabel;
@property  (nonatomic,strong) IBOutlet UITextField* passwordLabel;

@property  (nonatomic,strong) IBOutlet UIView* apsnPareView;

-(IBAction)loginBtnClick:(id)sender;
-(IBAction)qrcodeBtnClick:(id)sender;
-(IBAction)closeKeyboard:(id)sender;

+(XAILoginVC*)create;

@end
