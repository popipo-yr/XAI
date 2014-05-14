//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILoginVC.h"
#import "XAIAppDelegate.h"
#import "XAIUserService.h"
#import "XAIData.h"

#import "Reachability.h"


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
    [passwordLabel setPlaceholder:NSLocalizedString(@"TipPawd", nil)];
    
    
    [nameLabel setText:nil];
    [nameLabel setPlaceholder:NSLocalizedString(@"TipName", nil)];
    
    
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
#define  _35moreLength 80

- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGPoint  oldPoint = self.view.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    float  addLenght = 0;
    
    if ([UIScreen is_35_Size]) {
        
        addLenght = _35moreLength;
    }
    
    self.view.center = CGPointMake(oldPoint.x , oldPoint.y - (moveLength + addLenght));
    
    [UIView commitAnimations];
}



- (void)keyboardWillHide:(NSNotification *)notif {
    
    CGPoint  oldPoint = self.view.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];

    float  addLenght = 0;
    if ([UIScreen is_35_Size]) {
        
        addLenght = _35moreLength;
    }

    
    self.view.center = CGPointMake(oldPoint.x , oldPoint.y + moveLength + addLenght);
    
    [UIView commitAnimations];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginBtnClick:(id)sender{
    
    BOOL hasErr = true;
    
    NSString* errTip = nil;
    
    do {
        
        if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
            
            errTip = NSLocalizedString(@"NetNotReachable", nil);
            break;
        }
        
        if (nil == nameLabel.text ||[nameLabel.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"UserNameNULL", nil);
            break;
        }
        
        if (nil == passwordLabel.text ||[passwordLabel.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"UserPawdNULL", nil);
            break;
        }
        
        
//        if (nil == _qrcodeLabel.text ||[_qrcodeLabel.text isEqualToString:@""]) {
//            
//            errTip = NSLocalizedString(@"QrcodeNULL", nil);
//            break;
//        }
        
        if (![nameLabel.text onlyHasNumberAndChar]) {
            
            errTip = NSLocalizedString(@"UserNameErr", @"username string is not  require style");
            break;
        }
        
        if (![nameLabel.text isNameOrPawdLength]) {
            
            errTip = NSLocalizedString(@"UserNameLengthErr", @"username string leangth is not require length");
            break;
        }
        
        
        if (![passwordLabel.text onlyHasNumberAndChar]) {
            
            errTip = NSLocalizedString(@"UserPawdErr", @"password string is not  require style");
            break;
        }
        
        if (![passwordLabel.text isNameOrPawdLength]) {
            
            errTip = NSLocalizedString(@"UserPawdLengthErr", @"password string leangth is not require length");
            break;
        }
        
        
        
        hasErr = false;
        
    } while (0);
    
    
    if (hasErr) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errTip
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                              otherButtonTitles:nil];
        
        [alert show];
        return;

        
    }
    

    
    [self.nameLabel resignFirstResponder];
    [self.passwordLabel resignFirstResponder];
    
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
    
    [_login loginWithName:self.nameLabel.text Password:self.passwordLabel.text Host:@"192.168.1.1" apsn:0x1];
    //[_login loginWithName:@"admin" Password:@"admin" Host:@"192.168.1.1" apsn:0x1];


//    _findDev = findSuccess;
//    _findUser = findSuccess;
//    [self getDateFinsh];
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

- (void)loginFinishWithStatus:(BOOL)status isTimeOut:(BOOL)bTimeOut{
    
    if (status) {
        
        
        
        _findDev = findStart;
        _findUser = findStart;
        
        /*获取设备列表,和用户列表*/
        _devService = [[XAIDeviceService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
        _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
        _devService.deviceServiceDelegate = self;
        _userService.userServiceDelegate = self;
        
        
        
        [_userService finderAllUser];
        [_devService findAllOnlineDevWithuseSecond:5];
        
    }else{
        
    
        NSString* errstr = NSLocalizedString(@"LoginFailed", nil);
    
        if (bTimeOut) {
            
            errstr = NSLocalizedString(@"LoginTimeOut", nil);
        }
        
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errstr
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                              otherButtonTitles:nil];
        
        
        [alert show];
    
    
        [_activityView stopAnimating];
    
    }


}


- (void) getDateFinsh{
    
    NSString* errTip = nil;
    
    if (_findUser == findStart || _findDev == findStart) return;
    
    if (_findDev == findFail && _findUser == findFail) {
        
        errTip = NSLocalizedString(@"GetUsersAndDevsFaild", nil);
        
    }else if (_findUser == findFail) {
        
        errTip = NSLocalizedString(@"GetUsersFaild", nil);
        
    }else if (_findDev == findFail) {
        
        errTip = NSLocalizedString(@"GetDevsFaild", nil);
    }

    if (errTip != nil) {
        
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errTip
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                              otherButtonTitles:nil];
        
        [alert show];
        
         [_activityView stopAnimating];
        
        
    }else{
        
        [[XAIData shareData] save];
        
        /*设置数据更新*/
        [[XAIData shareData] startRefresh];
    
        //[self performSegueWithIdentifier:@"XAIMainPageSegue" sender:nil];
        
        UIViewController* vc= [self.storyboard
                               instantiateViewControllerWithIdentifier:@"XAIMainPage"];
        
        XAIAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.window setRootViewController:vc];
        
        //XAIAppDelegate* [UIApplication sharedApplication].delegate;
        _login = nil;
        
        [_activityView stopAnimating];
        _activityView = nil;
        
        _devService = nil;
        _userService = nil;
        
        
        

    
    }

}

-(IBAction)qrcodeBtnClick:(id)sender{

    
    XAIScanVC* scanvc = [self.storyboard instantiateViewControllerWithIdentifier:@"XAIScanVCID"];
    
    if ([scanvc isKindOfClass:[XAIScanVC class]]) {
        
        [self.nameLabel resignFirstResponder];
        [self.passwordLabel resignFirstResponder];
        
        scanvc.delegate = self;
        
        [self presentViewController:scanvc animated:YES completion:nil];
    }

}

-(void)scanVC:(XAIScanVC *)scanVC didReadSymbols:(ZBarSymbolSet *)symbols{


    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    if ([predicate evaluateWithObject:symbolStr]) {
        
    }
    else if([ssidPre evaluateWithObject:symbolStr]){
        
        NSArray *arr = [symbolStr componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        
        
        symbolStr = [NSString stringWithFormat:@"ssid: %@ \n password:%@",
                     [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1];
    }

}

@end
