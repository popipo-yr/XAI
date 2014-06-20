//
//  AAAppDelegate.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIAppDelegate.h"

#import "XAIData.h"

#include "mosquitto.h"


@implementation XAIAppDelegate


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [XAIObjectGroupManager shareManager];
    
    [self initializeStoryBoardBasedOnScreenSize];
    
    _mqttPacketManager = [[MQTTPacketManager alloc] init];
    
    
    NSString *clientId = [NSString stringWithFormat:@"XAI%@", @""];
    _mosquittoClient = [[MosquittoClient alloc] initWithClientId:clientId];
    
    [_mosquittoClient setDelegate:_mqttPacketManager];
    
    
    [[MQTT shareMQTT] setClient:_mosquittoClient];
    [[MQTT shareMQTT] setPacketManager:_mqttPacketManager];
    
    
    [XAIData shareData];
    //[[UIApplication  sharedApplication] setStatusBarHidden:false];
    
    if (!isIOS7) {
    
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
        self.window.backgroundColor = [UIColor colorWithRed:1 green:-1.0 blue:-1.0 alpha:1.0];
        // self.window.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    _netReachability = [Reachability reachabilityForLocalWiFi];
    
    [_netReachability startNotifier];
    
    _reLogin = [[XAIReLogin alloc] init];
    _reLogin.delegate = self;
    

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [_mosquittoClient disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[XAIObjectGroupManager shareManager] save];
    [[XAIData shareData] save];
    [_mosquittoClient disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self reloginIsLogin:false];
    [_mosquittoClient reconnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[XAIObjectGroupManager shareManager] save];
    [_mosquittoClient disconnect];
}


-(void)initializeStoryBoardBasedOnScreenSize {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
            UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
        
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
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
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"NetNotConnect", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil) otherButtonTitles:nil];
        [alert show];
    }
    
    if(status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        NSLog(@"WIFI");
    
        [self reloginIsLogin:true];
       
    }
    if(status == ReachableViaWWAN)
    {
        NSLog(@"3G");
    }
}


- (void)reloginIsLogin:(BOOL)islogin{
    
    
    if ([MQTT shareMQTT].isLogin &&
        nil == _reLoginStartAlert &&
        NotReachable != [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        /*重新获取数据,数据可能更新*/
        
        _isRelogin = islogin;
        
        NSString* msg = NSLocalizedString(@"ReLoginStartUpdate", nil);
        
        if (islogin) {
            
            msg= NSLocalizedString(@"ReLoginStart", nil);
            
        }
        
        _reLoginStartAlert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:nil otherButtonTitles:nil];
        
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
        
        [_reLogin relogin];
        
    }
    
}

-(void)XAIRelogin:(XAIReLogin *)reLogin loginErrCode:(XAIReLoginErr)err{

    
    /*成功,取消提示*/
    [_reLoginStartAlert  dismissWithClickedButtonIndex:0 animated:YES];
    _reLoginStartAlert = nil;
    
    
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
        
        do {
            
            UIViewController*  tabBarVC = self.window.rootViewController;
            
            if (![tabBarVC isKindOfClass:[UITabBarController class]]) break;
            
            UIViewController* curVC = ((UITabBarController*)tabBarVC).selectedViewController;
            
            if (![curVC isKindOfClass:[UINavigationController class]]) break;
                
            [(UINavigationController*)curVC popToRootViewControllerAnimated:YES]; //回到起始位置
            
        } while (0);
        

        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (_reLoginFailAlert == alertView) {
        
        UIViewController* vc= [self.window.rootViewController.storyboard
                               instantiateViewControllerWithIdentifier:@"XAILoginVCID"];
        
        [self.window setRootViewController:vc];
        
        _reLoginFailAlert = nil;
    }
}

@end
