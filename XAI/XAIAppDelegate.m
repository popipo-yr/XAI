//
//  AAAppDelegate.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIAppDelegate.h"

#import "XAIData.h"
#import "XAIReLoginRefresh.h"
#include "XAIToken.h"

#import "XAILinkageTime.h"
#import "XAILoginVC.h"


#include "mosquitto.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#import "ssl/openssl/crypto.h"




@implementation XAIAppDelegate


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) changeMQTTClinetID:(NSString*)clientID apsn:(XAITYPEAPSN)apsn{
    
    
    _mosquittoClient = [[MosquittoClient alloc] initWithClientId:clientID];
    
    [_mosquittoClient setDelegate:_mqttPacketManager];
    [_mosquittoClient setKeepAliveDelegate:self];
    [[MQTT shareMQTT].client willRemove];
    [[MQTT shareMQTT] setClient:_mosquittoClient];
    [MQTT shareMQTT].tmpApsn = apsn;
    
    [[XAIAlert shareAlert] stop];
    [[XAIAlert shareAlert] setApsn:apsn];
    
    //[[XAIAlert shareAlert] startFocus];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _isReConnect = false;
    
    [XAIObjectGroupManager shareManager];
    
    //[self initializeStoryBoardBasedOnScreenSize];
    
    XAILauchVC* lauchVC = (XAILauchVC*)[XAILauchVC create];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set the initial view controller to be the root view controller of the window object
    self.window.rootViewController  = lauchVC;
    
    // Set the window object to be the key window and show it
    [self.window makeKeyAndVisible];
    
    
    _mqttPacketManager = [[MQTTPacketManager alloc] init];
    //_noAcceptHandle = [[XAINoAcceptPacketHandle alloc] init];
    //[_mqttPacketManager addPacketManagerNoAccept:_noAcceptHandle];
    
    //uuid_t uid;
    //[[[UIDevice currentDevice] identifierForVendor] getUUIDBytes:uid];
    
    //NSString* uidStr = nil;
    //uidStr = [[NSString alloc] initWithCharacters:(const unichar *)uid length:sizeof(uuid_t)];
    //uidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //uidStr = [self getMacAddress];
    
    //NSString *clientId = [NSString stringWithFormat:@"ios%@", uidStr];
    
    
    //_mosquittoClient = [[MosquittoClient alloc] initWithClientId:@"ios"];
    
    //[_mosquittoClient setDelegate:_mqttPacketManager];
    
    
    //[[MQTT shareMQTT] setClient:_mosquittoClient];
    [[MQTT shareMQTT] setPacketManager:_mqttPacketManager];
    
    
    [XAIData shareData];
    //[[UIApplication  sharedApplication] setStatusBarHidden:false];
    
    if (!isIOS7) {
    
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
        self.window.backgroundColor = [UIColor colorWithRed:1 green:-1.0 blue:-1.0 alpha:1.0];
        // self.window.backgroundColor = [UIColor whiteColor];
        
        
    }else{
    
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    _netReachability = [Reachability reachabilityForLocalWiFi];
    
    [_netReachability startNotifier];
    
    _reLogin = [[XAIReLogin alloc] init];
    
    if (false == [XAIToken hasToken]) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                                 settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                                 categories:nil]];
            
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }else{
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
            
        }
    }
    
    [XAIAlert shareAlert];
    
    _datePicker = [[UIDatePicker alloc] init];
    
    
    [KeyboardStateListener sharedInstance];
    
    [XAILinkageTime share];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self stopRelogin];
    [[XAIData shareData] stopRefresh];
    [_mosquittoClient disconnect];
    [_mosquittoClient endwork];

    _needKeepTip = false;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[XAIObjectGroupManager shareManager] save];
    [[XAIData shareData] save];
    [[XAIAlert shareAlert] stop];

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    NSLog(@"xxxxxxxxxxxxxxxxxxxx");
//    [self reloginIsLogin:false];
//    [_mosquittoClient reconnect];
    
    [[XAIAlert shareAlert] startFocus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    XSLog(@"xxxxxxxxxxxxxxxxxxxx");
    if ([MQTT shareMQTT].isLogin) {
        [_mosquittoClient startwork];
        [self performSelector:@selector(reloginWhenGoIn) withObject:nil afterDelay:0.5f];
    }
    
    //[self reloginIsLogin:false];
    //[_mosquittoClient reconnect];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[XAIObjectGroupManager shareManager] save];
    [_mosquittoClient disconnect];
}

- (void)applicationDidFinishLaunching:(UIApplication *)app {
    // other setup tasks here....
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}

// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {

    XSLog(@"devToken=%@",devToken);
    
    [XAIToken saveToken:devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    XSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{

    XSLog(@"%@",userInfo);
}


-(void)initializeStoryBoardBasedOnScreenSize {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = [XAILoginVC create];
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
        
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
            
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = [XAILoginVC create];
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
        
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        
    {   // The iOS device = iPad
        
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
    }
}


- (void)reachabilityChanged:(NSNotification *)note {

    
    
    Reachability* curReach = [note object];
    //NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"NetNotConnect", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil) otherButtonTitles:nil];
        [alert show];
        
        _hasAlert = true;
    }
    
    if (![curReach isKindOfClass:[Reachability class]] ||
        [MQTT shareMQTT].isLogin == false ||
        _isReConnect == true) {
        return ;
    }
    
    if(status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        XSLog(@"WIFI");
        [[XAIData shareData] stopRefresh];
        [self reloginIsLogin:true];
       
    }
    if(status == ReachableViaWWAN)
    {
        XSLog(@"3G");
       
        [[XAIData shareData] stopRefresh];
        [self reloginIsLogin:true];
        
    }
}

- (void) stopRelogin{

    [_reLogin stop];
    if (_isReConnect ==  true) {
        _isReConnect = false;
    }
    
    if (_reLoginStartAlert != nil && [_reLoginStartAlert isVisible]) {
        [_reLoginStartAlert  dismissWithClickedButtonIndex:0 animated:YES];
    }
    
}
- (void)reloginWhenGoIn{
    [self reloginIsLogin:false];
}


- (void)reloginIsLogin:(BOOL)islogin{
    
    if (_isReConnect == true) {
        return;
    }
    
    XSLog(@"-------------");
    XSLog(@"islong = %@, hasalert = %@, is noreachable= %@",
          [MQTT shareMQTT].isLogin ? @"true" : @"false",
          false != _isReConnect ? @"true" : @"false",
          NotReachable != [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] ? @"true" : @"false");
    
    if ([MQTT shareMQTT].isLogin &&
        false == _isReConnect &&
        NotReachable != [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        /*重新获取数据,数据可能更新*/
        
        _isRelogin = islogin;
        _isReConnect = true;
        
        NSString* msg =[NSString stringWithString:NSLocalizedString(@"ReLoginStartUpdate", nil)];
        
        if (islogin) {
            
            msg= [NSString stringWithString:NSLocalizedString(@"ReLoginStart", nil)];
            
        }
        
        _reLoginStartAlert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:nil otherButtonTitles:nil,nil];
        
        UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        activeView.color = [UIColor redColor];
        [activeView startAnimating];
        
        if (isIOS7) {
            
            
            activeView.frame= CGRectMake(50, 10, 37, 37);
            
            activeView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
            
            
            //the magic line below,
            //we associate the activity indicator to the alert view: (addSubview is not used)
            [_reLoginStartAlert setValue:activeView forKey:@"accessoryView"];
            
        }else{
            
            
            activeView.center = CGPointMake(_reLoginStartAlert.bounds.size.width/2.0f,
                                            _reLoginStartAlert.bounds.size.height-40.0f);
            
            [_reLoginStartAlert addSubview:activeView];
        }
        
        
        [_reLoginStartAlert show];
        
        _reLogin.delegate = self;
        [_reLogin start];
        [_reLogin relogin];
        
        
    }else{
        
        if (_hasAlert) return;
    
        _isReConnect = true;
        [self XAIRelogin:nil loginErrCode:XAIReLoginErr_LoginFail];
    }
    
}

-(void)XAIRelogin:(XAIReLogin *)reLogin loginErrCode:(XAIReLoginErr)err{

    //_reLogin.delegate = nil;
    
    if (_isReConnect == false) {
        return;
    }
    
    /*成功,取消提示*/
    if (_reLoginStartAlert != nil && [_reLoginStartAlert isVisible]) {
        [_reLoginStartAlert  dismissWithClickedButtonIndex:0 animated:YES];
    }
    _isReConnect = false;
    
    XSLog(@"END .............");
    
    if (err != XAIReLoginErr_NONE) {
    /*重新登录错误,提示回到登录界面*/
        
        NSString* msg = NSLocalizedString(@"ReLoginUpdateFail", nil);
        
        if (_isRelogin) {
            
            msg = NSLocalizedString(@"ReLoginFail", nil);
        }
        
        _reLoginFailAlert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil) otherButtonTitles:nil];
        [_reLoginFailAlert show];
    
    
        [MQTT shareMQTT].isLogin = false;
        
    }else{
        
        _needKeepTip = true;
        
        do {
            
            UIViewController*  vc = self.window.rootViewController;
            
            if ([vc conformsToProtocol:@protocol(XAIReLoginRefresh)]) {
                
                if ([vc respondsToSelector:@selector(reloginRefresh)]) {
                    [vc performSelector:@selector(reloginRefresh) withObject:nil];
                }
            }
            
        } while (0);
        
        //[[XAIAlert shareAlert] startFocus];
        
        
        MQTT* curMQTT = [MQTT shareMQTT];
        /*订阅主题*/
//        [curMQTT.client subscribe:[MQTTCover serverStatusTopicWithAPNS:curMQTT.apsn
//                                                                  luid:MQTTCover_LUID_Server_03]];
        [curMQTT.client subscribe:[MQTTCover mobileCtrTopicWithAPNS:curMQTT.apsn
                                                               luid:curMQTT.luid]
                          withQos:2];
        [[XAIData shareData] startRefresh];
    }
    
    [_reLogin stop];
    _reLogin.delegate = nil;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (_reLoginFailAlert == alertView ||
        (_otherLoginTipAlert == alertView && buttonIndex == [alertView cancelButtonIndex])) {
        
        [self.window.rootViewController.view  endEditing:YES];
        
    
        [self initializeStoryBoardBasedOnScreenSize];
        //self.window.rootViewController  = [XAILoginVC create];

        _reLoginFailAlert = nil;
    }
    
    _hasAlert = false;
}

#pragma mark -- KeepAlive
-(void)didDisconnect{

    if (_isReConnect == false && [MQTT shareMQTT].isLogin == true && _needKeepTip == true) {
        
        [MQTT shareMQTT].isLogin = false;
        
        
        NSString* msg = NSLocalizedString(@"other space login", nil);
        
        _otherLoginTipAlert = [[UIAlertView alloc] initWithTitle:nil
                                                       message:msg
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"AlertOK", nil) otherButtonTitles:nil];
        [_otherLoginTipAlert show];

    }

    
}

//
//- (NSString *)_getMacAddress
//{
//    int                 mgmtInfoBase[6];
//    char                *msgBuffer = NULL;
//    size_t              length;
//    unsigned char       macAddress[6];
//    struct if_msghdr    *interfaceMsgStruct;
//    struct sockaddr_dl  *socketStruct;
//    NSString            *errorFlag = NULL;
//    
//    // Setup the management Information Base (mib)
//    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
//    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
//    mgmtInfoBase[2] = 0;
//    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
//    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
//    
//    // With all configured interfaces requested, get handle index
//    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
//        errorFlag = @"if_nametoindex failure";
//    else
//    {
//        // Get the size of the data available (store in len)
//        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
//            errorFlag = @"sysctl mgmtInfoBase failure";
//        else
//        {
//            // Alloc memory based on above call
//            if ((msgBuffer = malloc(length)) == NULL)
//                errorFlag = @"buffer allocation failure";
//            else
//            {
//                // Get system information, store in buffer
//                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
//                    errorFlag = @"sysctl msgBuffer failure";
//            }
//        }
//    }
//    
//    // Befor going any further...
//    if (errorFlag != NULL)
//    {
//        NSLog(@"Error: %@", errorFlag);
//        return errorFlag;
//    }
//    
//    // Map msgbuffer to interface message structure
//    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
//    
//    // Map to link-level socket structure
//    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
//    
//    // Copy link layer address data in socket structure to an array
//    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
//    
//    // Read from char array into a string object, into traditional Mac address format
//    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
//                                  macAddress[0], macAddress[1], macAddress[2],
//                                  macAddress[3], macAddress[4], macAddress[5]];
//    NSLog(@"Mac Address: %@", macAddressString);
//    
//    // Release the buffer memory
//    free(msgBuffer);
//    
//    return macAddressString;
//}
//
//// Return the local MAC addy
//// Courtesy of FreeBSD hackers email list
//// Accidentally munged during previous update. Fixed thanks to mlamb.
//- (NSString *) getMacAddress
//{
//    
//    int                 mib[6];
//    size_t              len;
//    char                *buf;
//    unsigned char       *ptr;
//    struct if_msghdr    *ifm;
//    struct sockaddr_dl  *sdl;
//    
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//    
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error/n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1/n");
//        return NULL;
//    }
//    
//    if ((buf = malloc(len)) == NULL) {
//        printf("Could not allocate memory. error!/n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2");
//        return NULL;
//    }
//    
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    
//    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    
//    NSLog(@"outString:%@", outstring);
//    
//    free(buf);
//    
//    return [outstring uppercaseString];
//}
@end
