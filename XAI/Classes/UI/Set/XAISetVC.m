//
//  UserVC.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAISetVC.h"
#import "XAIChangeCell.h"
#import "XAIChangeNameVC.h"
#import "XAIChangePasswordVC.h"
#import "XAIAppDelegate.h"

#import "XAIShowVC.h"


#define _key_name_index 1
#define _key_pawd_index 2
#define _key_home_index 0

@interface XAISetVC ()

@end

@implementation XAISetVC

+ (UIViewController*) create{

    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Set_iPhone" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:_SI_SetVC];
    [vc changeIphoneStatus];
    
    return vc;
}

- (IBAction)changePasw:(id)sender {
    
    
    XAIChangePasswordVC* pawVC = [self.storyboard
                                  instantiateViewControllerWithIdentifier:@"XAIChangePasswordVCID"];
    
    [pawVC setOldPwd:_userInfo.pawd];
    [pawVC setOKClickTarget:self Selector:@selector(changePassword:)];
    [pawVC setBarTitle:NSLocalizedString(@"UserPawdChange", nil)];
    
    _pawVC = pawVC;
    
    [self.navigationController pushViewController:pawVC animated:YES];

}


- (id) initWithCoder:(NSCoder *) coder{

    self = [super initWithCoder:coder];
    
    if (self) {
        
        _userInfo = [MQTT shareMQTT].curUser;
        
        _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn
                                                       Luid:MQTTCover_LUID_Server_03];
        _userService.userServiceDelegate = self;
        //_userInfo.name = @"小明";
        //_userInfo.pawd = @"98980454";
    }
    
    return self;
}

-(void)dealloc{

    [_userService willRemove];
    _userService = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userInfo = [MQTT shareMQTT].curUser;
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _swipes = [[NSArray alloc] initWithArray:[self openSwipe]];
    
    _nameLab.text = _userInfo.name;
    _pawdLab.text = _userInfo.pawd;
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self stopSwipte:_swipes];
    
    [super viewDidDisappear:animated];
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



-(void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    //    [self animalView_R2L:[XAISetVC create].view];
    [self animalVC_L2R:[XAIShowVC create]];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void) changePassword:(NSString*)newPwd{
    
    _newPwd = newPwd;
    [_userService changeUser:_userInfo.luid oldPassword:_userInfo.pawd to:newPwd];
    [_pawVC starAnimal];
}


- (void) userOut{
    
    [[MQTT shareMQTT].client disconnect];

    UIViewController* vc= [self.storyboard
                           instantiateViewControllerWithIdentifier:@"XAILoginVCID"];
    
    XAIAppDelegate *appDelegate = (XAIAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:vc];

}





-(void)userService:(XAIUserService *)userService changeUserPassword:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (isSuccess) {
        
        [_pawVC endOkEvent];
        _userInfo.pawd = _newPwd;
        
        _pawdLab.text = _newPwd;
        
    }else{
        
        [_pawVC endFailEvent:NSLocalizedString(@"UserPawdChangeFaild", nil)];
    }
    
    [_pawVC stopAnimal];
}


@end
