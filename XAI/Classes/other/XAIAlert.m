//
//  XAIAlert.m
//  XAI
//
//  Created by office on 14-6-30.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIAlert.h"
#import "XAIAppDelegate.h"
#import "XAIData.h"


static XAIAlert*  _XAIAlertSTATIC = NULL;

@implementation XAIAlert


+ (XAIAlert*) shareAlert{
    
    if (NULL == _XAIAlertSTATIC) {
        
        _XAIAlertSTATIC = [[XAIAlert alloc] init];
    }
    
    return _XAIAlertSTATIC;
    
}

-(id)init{
    
    if (self = [super init]) {
        
        _mc = [[XAIMobileControl alloc] init];
        _mc.mobileDelegate = self;
    }
    
    return self;
}

-(void)dealloc{

    [self stop];
    _mc.mobileDelegate = nil;
    _mc = nil;
}

- (void) setApsn:(XAITYPEAPSN)apsn{
    
    _apsn = apsn;
}


- (void) startFocus{
    
    [XAIMobileControl setMsgSave:_mc];
    [_mc startListeneAll:_apsn];
}
- (void) stop{
    
    if (_alertView != nil && [_alertView isVisible]) {
        [_alertView dismissWithClickedButtonIndex:0 animated:false];
    }
    [XAIMobileControl setMsgSave:nil];
    [_mc stopListeneAll:_apsn];
}

-(void)mobileControl:(XAIMobileControl *)mc getCmd:(XAIMCCMD *)cmd{
    
    if ([MQTT shareMQTT].isBufang == false) {
        return;
    }

    _alertView = [[UIAlertView alloc] initWithTitle:nil
                                            message:@"SHOWWWW"
                                           delegate:self
                                  cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [_alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    do {
        
        UITabBarController*  tabBarVC =  (UITabBarController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        
        if (![tabBarVC isKindOfClass:[UITabBarController class]]) break;
        
        
        NSArray* curVCS = ((UITabBarController*)tabBarVC).viewControllers;
        
        if ([curVCS count] == 0) break;
        
        
        UINavigationController* curVC = [curVCS  objectAtIndex:0];
        
        if (![curVC isKindOfClass:[UINavigationController class]]) break;
        
        [curVC popToRootViewControllerAnimated:false]; //回到起始位置
        
        tabBarVC.selectedViewController = curVC;
        
        /*进入提示位置*/
        
//        XAIObject* obj = [[XAIData shareData] findObj:0x210e2b26 luid:0x124b000413c931];
//
//
//        [curVC pushViewController:
//         [XAIDevShowStatusVCGenerate statusWithObject:obj storyboard:tabBarVC.storyboard] animated:YES];
        
        
        
    } while (0);
    
    _alertView = nil;

}

@end
