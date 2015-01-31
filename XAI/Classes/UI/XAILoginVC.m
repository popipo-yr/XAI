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

#define _K_APSN_COL  @"APSNCOL"
#define _K_APSN @"APSN"
#define _K_APSN_36 @"APSN36"
#define _K_Username @"username"

@interface XAILoginVC ()

@end

@implementation XAILoginVC

@synthesize nameLabel;
@synthesize passwordLabel;


+(XAILoginVC*)create{

    // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    // Instantiate the initial view controller object from the storyboard
    XAILoginVC *vc = [storyboard instantiateInitialViewController];
    
    if ([vc isKindOfClass:[XAILoginVC class]]) {
        return vc ;
    }

    return nil;
}

-(id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        _isLoging = false;
        _pushScan = false;
        _beBackgroud = false;
        
        _apsnDatas = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

-(void)dealloc{
    
    _userService.userServiceDelegate = nil;
    _devService.deviceServiceDelegate = nil;
    
    _userService = nil;
    _devService = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [passwordLabel setText:nil];
    [passwordLabel setSecureTextEntry:YES];
    [passwordLabel setPlaceholder:NSLocalizedString(@"TipPawd", nil)];
    
    
    [nameLabel setText:nil];
    [nameLabel setPlaceholder:NSLocalizedString(@"用户名", nil)];
    
    
    _keyboardIsUp = false;
    

    
    
//    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:_K_Username];
//    if (username != nil && [username isKindOfClass:[NSString class]] && ![username isEqualToString:@""]) {
//        [nameLabel setText:username];
//    }
    
    
    NSArray* saveApsns = [[NSUserDefaults standardUserDefaults] objectForKey:_K_APSN_COL];
    if (saveApsns != nil && [saveApsns isKindOfClass:[NSArray class]]) {
        [_apsnDatas addObjectsFromArray:saveApsns];
    }
    
    
    CGRect frame = _apsnPareView.frame;
    frame.origin = CGPointZero;
    XAIApsnView* apsnView = [[XAIApsnView alloc] initWithFrame:frame];
    apsnView.delegate = self;
    apsnView.dataSource = self;
    [_apsnPareView addSubview:apsnView];
    _apsnView = apsnView;

}

-(BOOL)prefersStatusBarHidden{

    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleDefault;
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSettings)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [self.nameLabel addTarget:self action:@selector(nameLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordLabel addTarget:self action:@selector(passwordLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    if (_pushScan) {//扫描返回不需要get
        return;
    }
    

}


- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:Nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:Nil];
    
    
    [self.nameLabel removeTarget:self action:@selector(nameLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordLabel removeTarget:self action:@selector(passwordLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];



    [self.passwordLabel resignFirstResponder];
    [self.passwordLabel resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

- (void)updateSettings{
    
    if (_beBackgroud == false) {
        return;
    }
    
    _beBackgroud = false;

    if (_pushScan) {//扫描返回不需要get
        return;
    }

}

-(void)enterBackground{

    _beBackgroud = true;
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
    
    
    BOOL hasErr = true;
    
    NSString* errTip = nil;
    
    do {
        
        if (_curApsn == 0) {
            
            //审核
            NSString* dateStr = @"2015-02-20";
            NSDateFormatter* formart = [[NSDateFormatter alloc] init];
            [formart  setDateFormat:@"yyyy-MM-dd"];
            NSDate* endDate = [formart dateFromString:dateStr];
            NSTimeInterval inv = [endDate  timeIntervalSinceDate:[NSDate new]];
            
            if (inv > 0) {
                _curApsn = 0x010e2b26;
            }else{
                errTip = NSLocalizedString(@"PleaseScanQRCode", nil);
                break;
            }

            
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
    
    NSString* nameWithAPSN = [NSString stringWithFormat:@"%@@%@"
                              ,self.nameLabel.text,[MQTTCover apsnToString:_curApsn]];
    
    NSString*  apsnStr = [MQTTCover apsnToString:_curApsn];
    apsnStr = [apsnStr substringFromIndex:2];
    NSString* apsnDomain = [NSString stringWithFormat:@"%@.xai.so",apsnStr];
    
    
    XAIAppDelegate *appDelegate = (XAIAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate changeMQTTClinetID:nameWithAPSN apsn:_curApsn];
    
    //save  info
    if (_apsnCurIndex < _apsnDatas.count) {
        NSDictionary* dic = [_apsnDatas objectAtIndex:_apsnCurIndex];
        if ([dic isKindOfClass:[NSDictionary class]]) {
           
            NSMutableDictionary* mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [mDic setObject:nameLabel.text forKey:_K_Username];
            [_apsnDatas replaceObjectAtIndex:_apsnCurIndex withObject:mDic];
            [[NSUserDefaults standardUserDefaults] setObject:_apsnDatas forKey:_K_APSN_COL];
        }
    }


    if (_isLoging) {
        return;
    }
    _isLoging = true;
    
    [_login loginWithName:self.nameLabel.text Password:self.passwordLabel.text Host:apsnDomain apsn:_curApsn needCheckCloud:![MQTT shareMQTT].isFromRoute];

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

- (void)loginFinishWithStatus:(BOOL)status loginErr:(XAILoginErr)err{
    
    if (status) {
        
        
        [self pushToken];
        
    }else{
        
    
        NSString* errstr = NSLocalizedString(@"LoginFailed", nil);
    
        if (err == XAILoginErr_TimeOut) {
            
            errstr = NSLocalizedString(@"LoginTimeOut", nil);
        }else if (err == XAILoginErr_UPErr) {
            
            errstr = NSLocalizedString(@"用户名或密码错误", nil);
        }else if(err == XAILoginErr_CloudOff){
        
            errstr = NSLocalizedString(@"云端处于离线状态", nil);
        }else if(err == XAILoginErr_CloudUnkown){
            
            errstr = NSLocalizedString(@"云端处于未知状态", nil);
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
        [_userService pushToken:token size:TokenSize isBufang:[MQTT shareMQTT].isBufang];
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
        
        [MQTT shareMQTT].isLogin = false;
        
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
        
        MQTT* curMQTT = [MQTT shareMQTT];
        /*订阅主题*/
        [curMQTT.client subscribe:[MQTTCover mobileCtrTopicWithAPNS:curMQTT.apsn luid:curMQTT.luid] withQos:2];
    
    }

    _isLoging =false;
}

-(IBAction)qrcodeBtnClick:(id)sender{
    
    if (_isLoging) return;

    XAIScanVC* scanvc = [XAIScanVC create];

    if ([scanvc isKindOfClass:[XAIScanVC class]]) {
        
        [self.nameLabel resignFirstResponder];
        [self.passwordLabel resignFirstResponder];
        
        scanvc.delegate = self;
        _pushScan = true;
        [self presentViewController:scanvc animated:YES completion:nil];
    }

}

-(void)scanVC:(XAIScanVC *)scanVC didReadSymbols:(NSString *)symbols{

    
    NSString *symbolStr = symbols;
    
    XAITYPEAPSN oneApsn;
    if (![self hasGetApsn:symbolStr retApsn:&oneApsn]) return;
    
    [scanVC dismissViewControllerAnimated:YES completion:nil];
    _pushScan = false;
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         symbolStr,_K_APSN,@"",_K_Username,nil];
    
    
    NSUInteger addIndex = _apsnCurIndex+1;
    if (addIndex > _apsnDatas.count) addIndex = _apsnDatas.count;
    
    [_apsnDatas insertObject:dic atIndex:addIndex];
    [_apsnView addViewAtIndex:addIndex];
    
    [[NSUserDefaults standardUserDefaults] setObject:_apsnDatas forKey:_K_APSN_COL];
    
}

-(void)scanVC:(XAIScanVC *)scanVC closeWithCacncel:(BOOL)cancel{

    _pushScan = false;
}

- (BOOL) hasGetApsn:(NSString*)apsn64Str retApsn:(XAITYPEAPSN*)apsnRef{
    
    if ([apsn64Str hasPrefix:@"X"] || [apsn64Str hasPrefix:@"x"]) {
        
        do {
            
            if (apsn64Str.length < 2) break;
            if (![apsn64Str hasPrefix:@"X"] && ![apsn64Str hasPrefix:@"x"]) break;
            
            NSString* bianHaoStr = [apsn64Str substringFromIndex:1];
            
            UInt64 bianHao = [MQTTCover string36ToUInt64:bianHaoStr];
            if (bianHao == 0) break;
            
            XAITYPEAPSN apsn  = [MQTTCover uint64ToApsn:bianHao];
            if (apsn == 0) break;
            
            *apsnRef = apsn;
            
            return true;
        } while (0);
        
        return false;
        
    }else{
        
        NSString* apsnStr = [NSString stringWithString:apsn64Str];
        if ([apsnStr hasPrefix:@"0x"] || [apsnStr hasPrefix:@"0X"]) {
            apsnStr = [apsnStr substringFromIndex:2];
        }
        
        XAITYPEAPSN oneApsn;
        NSScanner* scanner = [NSScanner scannerWithString:apsnStr];
        if ([scanner scanHexInt:&oneApsn]) {
            *apsnRef = oneApsn;
            return true;
        }
        
        return false;
    }

}


-(void)xaiIPHelper:(XAIIPHelper *)helper getIp:(NSString *)ip errcode:(_err)rc{

    if (rc == _err_none) {
        
        
        if (helper.getStep == _XAIIPHelper_GetStep_FromRoute) {
            [MQTT shareMQTT].isFromRoute = true;
        }else{
            [MQTT shareMQTT].isFromRoute = false;
        }
        
        
    }
    
}

-(void)closeKeyboard:(id)sender{

    [self.view endEditing:true];
}

#pragma MARK - APSNVIEW

-(NSUInteger)apsnViewCount:(XAIApsnView *)apsnView{

    return [_apsnDatas count] + 1;
}

-(NSString *)apsnViewIndexStr:(NSUInteger)index{
    
    
    XAITYPEAPSN apsn = [self apsnAtIndex:index];
    
    if (apsn != 0) {
        
        return [MQTTCover apsnToString:apsn];
    }

    return @"请扫描二维码";
}

-(BOOL)apsnViewCanDelIndex:(NSUInteger)index{

    return  index < _apsnDatas.count;
}

-(void)apsnView:(XAIApsnView *)apsnView curIndex:(NSUInteger)index{
    
    _apsnCurIndex = index;
    
    
    nameLabel.text = nil;
    passwordLabel.text = nil;
    
    _curApsn = [self apsnAtIndex:index];
    
    do {
        
        if(index >= _apsnDatas.count) break;
         NSDictionary* dic = [_apsnDatas objectAtIndex:index];
        if (![dic isKindOfClass:[NSDictionary class]]) break;
        
        nameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:_K_Username]];
        
    } while (0);
    
}

-(void)apsnView:(XAIApsnView *)apsnView delIndex:(NSUInteger)index{

    if (_apsnDatas.count > index){
        [_apsnDatas removeObjectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:_apsnDatas forKey:_K_APSN_COL];
    }
}
-(void)apsnView:(XAIApsnView *)apsnView selIndex:(NSUInteger)index{

    [self qrcodeBtnClick:nil];
}

-(XAITYPEAPSN)apsnAtIndex:(NSUInteger)index{

    XAITYPEAPSN oneApsn = 0;
    
    do {
        
        if(index >= _apsnDatas.count) break;
        NSDictionary* dic = [_apsnDatas objectAtIndex:index];
        if (![dic isKindOfClass:[NSDictionary class]]) break;
        
        NSString* apsnstr = [dic objectForKey:_K_APSN];
        
        if (apsnstr == nil
            || ![apsnstr isKindOfClass:[NSString class]]
            || [apsnstr isEqualToString:@""]) break;
        
        
        [self hasGetApsn:apsnstr retApsn:&oneApsn];
        
        
    } while (0);

    return oneApsn;
}

@end
