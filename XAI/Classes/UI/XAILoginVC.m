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

#import "XAIToken.h"
#import "XAIAlert.h"

#import "XAIShowVC.h"


#import "Reachability.h"


#define findSuccess 1
#define findFail   2
#define findStart  0

#define _K_APSN @"APSN"
#define _K_Username @"username"

@interface XAILoginVC ()

@end

@implementation XAILoginVC

@synthesize nameLabel;
@synthesize passwordLabel;

-(id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        _IPHelper = [[XAIIPHelper alloc] init];
        _IPHelper.delegate = self;
        _isLoging = false;
    }
    
    return self;
}

-(void)dealloc{
    
    _userService.userServiceDelegate = nil;
    _devService.deviceServiceDelegate = nil;
    
    _userService = nil;
    _devService = nil;

    _IPHelper.delegate = nil;
    _IPHelper = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [passwordLabel setText:nil];
    [passwordLabel setSecureTextEntry:YES];
    [passwordLabel setPlaceholder:NSLocalizedString(@"TipPawd", nil)];
    
    
    [nameLabel setText:nil];
    [nameLabel setPlaceholder:NSLocalizedString(@"TipName", nil)];
    
    //TODO: THERE IS
    //_scanApsn = 0x1;
    //_scanIP = @"192.168.0.33";
    _hasScan = false;
    
    _keyboardIsUp = false;
    
    [_qrcodeLabel setText:nil];
//    [_qrcodeLabel setEnabled:YES];
    [_qrcodeLabel setPlaceholder:@"Server-IP"];
    
    

    
    NSString* apsnstr = [[NSUserDefaults standardUserDefaults] objectForKey:_K_APSN];
    apsnstr = @"210e2b26";
    //apsnstr = @"210e9b6e";
    //apsnstr = @"210e2757";
    
    //apsnstr = @"2923AEEA";
    
    if (apsnstr != nil && [apsnstr isKindOfClass:[NSString class]] && ![apsnstr isEqualToString:@""]) {
        [self hasGetApsn:apsnstr];
    }
    
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:_K_Username];
    if (username != nil && [username isKindOfClass:[NSString class]] && ![username isEqualToString:@""]) {
        [nameLabel setText:username];
    }

}

-(BOOL)prefersStatusBarHidden{

    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self setNeedsStatusBarAppearanceUpdate];
        
    }
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
    
    [self.qrcodeLabel addTarget:self action:@selector(qrcodeLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:Nil];
    
    
    
    
    [self.nameLabel removeTarget:self action:@selector(nameLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordLabel removeTarget:self action:@selector(passwordLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.qrcodeLabel removeTarget:self action:@selector(qrcodeLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.passwordLabel resignFirstResponder];
    [self.passwordLabel resignFirstResponder];
    [self.qrcodeLabel resignFirstResponder];
    
    [super viewWillDisappear:animated];
}


- (void)nameLabelReturn:(id)sender {
    
    [self.passwordLabel becomeFirstResponder];
    
}

- (void)qrcodeLabelReturn:(id)sender {
    
    [self.nameLabel becomeFirstResponder];
    
    _scanIP = _qrcodeLabel.text;
    
}



- (void)passwordLabelReturn:(id)sender {
    
    [self.passwordLabel resignFirstResponder];
    
}


#define  moveLength  90
#define  _35moreLength 80

- (void)keyboardWillShow:(NSNotification *)notif {
    
    if (_keyboardIsUp == true) return;
    
    _keyboardIsUp = true;
    
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
    
    _keyboardIsUp = false;
    
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
    
    //[_activityView startAnimating];
    
    //return;
    
    BOOL hasErr = true;
    
    NSString* errTip = nil;
    
    do {
        
        if (!_hasScan) {
            
            errTip = NSLocalizedString(@"PleaseScanQRCode", nil);
            break;
            
        }
        
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
        
        if (nil == _qrcodeLabel.text ||[_qrcodeLabel.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"ApServerIpNULL", nil);
            break;
        }
        
        
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
    
    //_scanApsn = 0x2923aeea;
    //_qrcodeLabel.text = @"192.168.1.236";
    
    NSString* nameWithAPSN = [NSString stringWithFormat:@"%@@%@"
                              ,self.nameLabel.text,[MQTTCover apsnToString:_scanApsn]];
    
    XAIAppDelegate *appDelegate = (XAIAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate changeMQTTClinetID:nameWithAPSN];
    
    [[NSUserDefaults standardUserDefaults] setObject:nameLabel.text forKey:_K_Username];

    if (_isLoging) {
        return;
    }
    _isLoging = true;
    
    [_login loginWithName:self.nameLabel.text Password:self.passwordLabel.text Host:_qrcodeLabel.text apsn:_scanApsn];
    //[_login loginWithName:@"admin" Password:@"admin" Host:@"192.168.1.1" apsn:0x1];


//    _findDev = findSuccess;
//    _findUser = findSuccess;
//    [self getDataFinsh];
}

#pragma mark - Delegate

- (void) userService:(XAIUserService *)userService findedAllUser:(NSSet *)users status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    _userService.userServiceDelegate = nil;
    _findUser =  isSuccess ? findSuccess : findFail;

    if (isSuccess) {
        
        /*存储数据 其他页面使用*/
        [[XAIData shareData] setUserList:[users allObjects]];
        
    }
    
    [self getDataFinsh];
    
}

-(void)userService:(XAIUserService *)userService pushToken:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    _userService.userServiceDelegate = nil;
    _userService = nil;
    
    if ((YES == isSuccess) &&  (errcode == XAI_ERROR_NONE)) {
        
        
        //[self getData];
        
    }else{
        
    
    }
    
    [self getData];
    
    //获取失败也要进行,失败不会更新代理,手动更新
    [[MQTT shareMQTT].packetManager change];
}

- (void) devService:(XAIDeviceService *)devService findedAllDevice:(NSArray *)devAry status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    _devService.deviceServiceDelegate = nil;
    _findDev =  isSuccess ? findSuccess : findFail;
    
    if (isSuccess) {
        /*存储数据 其他页面使用*/
        [[XAIData shareData] setObjList:devAry];
    }
    
    [self getDataFinsh];
    
}

- (void)loginFinishWithStatus:(BOOL)status isTimeOut:(BOOL)bTimeOut{
    
    if (status) {
        
        
        [self pushToken];
        
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
        
        _isLoging = false;
    
    }


}

- (void) pushToken{

    void* token = malloc(TokenSize+20);
    memset(token, 0, TokenSize);
    
    BOOL bl = [XAIToken getToken:&token size:NULL];
    
    if (bl) {
        
        _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
        _userService.userServiceDelegate = self;
        [_userService pushToken:token size:TokenSize user:[MQTT shareMQTT].curUser.luid];
    }else{
    
        [self getData];
    }
    
    free(token);


}

- (void) getData{

    _findDev = findStart;
    _findUser = findStart;
    
    /*获取设备列表,和用户列表*/
    _devService = [[XAIDeviceService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
    _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
    _devService.deviceServiceDelegate = self;
    _userService.userServiceDelegate = self;
    
    
    
    [_userService finderAllUser];
    //[_devService findAllOnlineDevWithuseSecond:2];
    [_devService findAllDev];

}


- (void) getDataFinsh{
    
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
    
        
        UIViewController* vc= [XAIShowVC create];
        
        XAIAppDelegate *appDelegate = (XAIAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate.window setRootViewController:vc];
        
        
        appDelegate.needKeepTip = true;
        //XAIAppDelegate* [UIApplication sharedApplication].delegate;
        _login = nil;
        
        [_activityView stopAnimating];
        _activityView = nil;
        
        _devService = nil;
        _userService = nil;
        
        [[XAIAlert shareAlert] startFocus];
        MQTT* curMQTT = [MQTT shareMQTT];
        /*订阅主题*/
//        [curMQTT.client subscribe:[MQTTCover serverStatusTopicWithAPNS:curMQTT.apsn
//                                                                  luid:MQTTCover_LUID_Server_03]];
        
        
        [curMQTT.client subscribe:[MQTTCover mobileCtrTopicWithAPNS:curMQTT.apsn luid:curMQTT.luid] withQos:2];


    
    }

    _isLoging =false;
}

-(IBAction)qrcodeBtnClick:(id)sender{

    
    //XAIScanVC* scanvc = [self.storyboard instantiateViewControllerWithIdentifier:XAIScanVC_SB_ID];
    XAIScanVC* scanvc = [XAIScanVC create];

    
    if ([scanvc isKindOfClass:[XAIScanVC class]]) {
        
        [self.nameLabel resignFirstResponder];
        [self.passwordLabel resignFirstResponder];
        
        scanvc.delegate = self;
        
        [self presentViewController:scanvc animated:YES completion:nil];
    }

}

-(void)scanVC:(XAIScanVC *)scanVC didReadSymbols:(ZBarSymbolSet *)symbols{

    
    
    [scanVC dismissViewControllerAnimated:YES completion:nil];
    
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    [self hasGetApsn:symbolStr];
    
    [[NSUserDefaults standardUserDefaults] setObject:symbolStr forKey:_K_APSN];
   
   
}

- (void) hasGetApsn:(NSString*)apsn{

    //symbolStr = @"210e2813";
    //_scanApsn = 0x210e2813;
    //_scanIP = @"192.168.0.33";
    
    
    NSScanner* scanner = [NSScanner scannerWithString:apsn];
    
    if ([scanner scanHexInt:&_scanApsn]) {
        _hasScan = true;
    }
    
    
    /*获取ip地址*/
    [_IPHelper getApserverIpWithApsn:_scanApsn fromRoute:_Macro_Host];

}


-(void)xaiIPHelper:(XAIIPHelper *)helper getIp:(NSString *)ip errcode:(_err)rc{

    if (rc == _err_none) {
        
        _scanIP = ip;
        [_qrcodeLabel setText:ip];
        [_qrcodeLabel setEnabled:false];
        
    }else{
    
        [_qrcodeLabel setText:nil];
        [_qrcodeLabel setEnabled:true];
    }
    
    //_scanIP = @"192.168.0.33";
    //[_qrcodeLabel setText:_scanIP];
}

@end
