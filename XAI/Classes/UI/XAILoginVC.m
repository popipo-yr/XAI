//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILoginVC.h"
#import "XAIUserService.h"

#import "XAIData.h"


#define findSuccess 1
#define findFail   2
#define findStart  0

@interface XAILoginVC ()

@end

@implementation XAILoginVC

@synthesize nameLabel;
@synthesize passwordLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [passwordLabel setText:nil];
    [passwordLabel setSecureTextEntry:YES];
    [passwordLabel setPlaceholder:@"密码"];
    
    
    [nameLabel setText:nil];
    [nameLabel setPlaceholder:@"用户名"];
    
    
    [MQTT shareMQTT].apsn = 0x1;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification                                               object:nil];
    
    
    
    
    [self.nameLabel addTarget:self action:@selector(nameLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordLabel addTarget:self action:@selector(passwordLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:Nil];
    
    
    
    
    [self.nameLabel removeTarget:self action:@selector(nameLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordLabel removeTarget:self action:@selector(passwordLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];


    [super viewDidDisappear:animated];
}


- (void)nameLabelReturn:(id)sender {
    
    [self.passwordLabel becomeFirstResponder];
    
}

- (void)passwordLabelReturn:(id)sender {
    
    [self.passwordLabel resignFirstResponder];
    
}


#define  moveLength  90

- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGPoint  oldPoint = self.view.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    self.view.center = CGPointMake(oldPoint.x , oldPoint.y - moveLength);
    
    [UIView commitAnimations];
}



- (void)keyboardWillHide:(NSNotification *)notif {
    
    CGPoint  oldPoint = self.view.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];

    
    self.view.center = CGPointMake(oldPoint.x , oldPoint.y + moveLength);

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginBtnClick:(id)sender{
    
     CGRect rx = [ UIScreen mainScreen ].bounds;
    
    _activityView = [[UIActivityIndicatorView alloc] init];
    
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activityView.color = [UIColor redColor];
    _activityView.frame = CGRectMake(rx.size.width * 0.5f, rx.size.height * 0.5f, 0, 0);
    _activityView.hidesWhenStopped = YES;
    
    [_activityView startAnimating];
    
    [self.view addSubview:_activityView];

    _login = [[XAILogin alloc] init];
    _login.delegate = self;
    
    [_login loginWithName:@"admin" Password:@"admin" Host:@"192.168.1.1" apsn:0x1];


}

#pragma mark - Delegate

- (void) userService:(XAIUserService *)userService findedAllUser:(NSSet *)users status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    
    _findUser =  isSuccess ? findSuccess : findFail;

    if (isSuccess) {
        
        /*存储数据 其他页面使用*/
        [[XAIData shareData] setUserList:[users allObjects]];
        
    }
    
    [self getDateFinsh];
    
}

- (void) devService:(XAIDeviceService *)devService finddedAllOnlineDevices:(NSSet *)devs status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    _findDev =  isSuccess ? findSuccess : findFail;
    
    if (isSuccess) {
        
        /*存储数据 其他页面使用*/
        [[XAIData shareData] setObjList:[devs allObjects]];
        
    }

    
        
    [self getDateFinsh];
    
}

- (void)loginFinishWithStatus:(BOOL)status{
    
    _findDev = findStart;
    _findUser = findStart;
    
    /*获取设备列表,和用户列表*/
    _devService = [[XAIDeviceService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
    _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
    _devService.deviceServiceDelegate = self;
    _userService.userServiceDelegate = self;
    
    
    
    [_userService finderAllUser];
    [_devService findAllOnlineDevWithuseSecond:5];


}


- (void) getDateFinsh{
    
    NSString* errTip = nil;
    
    if (_findUser == findStart || _findDev == findStart) return;
    
    if (_findDev == findFail && _findUser == findFail) {
        
        errTip = @"获取用户列表,设备列表失败";
        
    }else if (_findUser == findFail) {
        
        errTip = @"获取用户列表失败";
        
    }else if (_findDev == findFail) {
        
        errTip = @"获取设备列表信息失败";
    }

    if (errTip != nil) {
        
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:errTip delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
         [_activityView stopAnimating];
        
        
    }else{
    
        [self performSegueWithIdentifier:@"XAIMainPageSegue" sender:nil];
        _login = nil;
        
        [_activityView stopAnimating];
        _activityView = nil;
        
        _devService = nil;
        _userService = nil;

    
    }
    

    




}

@end
