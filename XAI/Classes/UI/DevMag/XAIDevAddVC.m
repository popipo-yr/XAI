//
//  DevAddViewController.m
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevAddVC.h"
#import "XAIObject.h"
#import "XAIDeviceType.h"
#import "XAIShowVC.h"


@interface XAIDevAddVC ()

@end

#define DevAddViewControllerID @"DevAddViewControllerID"

@implementation XAIDevAddVC


+ (UIViewController*)create:(NSString*)luidStr{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone_Other" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:DevAddViewControllerID];
    
    [(XAIDevAddVC*)vc setLuidStr:luidStr];
    [vc changeIphoneStatus];
    return vc;


}


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _deviceService = [[XAIDeviceService alloc] init];
        _deviceService.apsn = [MQTT shareMQTT].apsn;
        _deviceService.luid = MQTTCover_LUID_Server_03;
        _deviceService.deviceServiceDelegate = self;
        
    }
    
    
    return self;
    
}

-(BOOL)prefersStatusBarHidden{
    
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (isIOS7) {
        
        
        [self.cNavBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.cNavBar setShadowImage:[UIImage new]];
        
    }else{
        
        [self.cNavBar setBackgroundImage:[UIImage imageWithColor:RGBA(255, 91, 0, 255)
                                                            size:CGSizeMake(1, 44)]
                           forBarMetrics:UIBarMetricsDefault];
        
    }
    

    [_nameTextField addTarget:self action:@selector(nameTextReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    UIImage* okImg = [UIImage imageWithFile:@"dev_add_btn_ok.png"] ;
    
    if ([okImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
        
        okImg = [okImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UIBarButtonItem* okItem = [[UIBarButtonItem alloc] initWithImage:okImg
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(addOneDevice:)];
    
    [okItem ios6cleanBackgroud];
    
    [self.cNavigationItem setRightBarButtonItem:okItem];
    
    
    UIImage* backImg = [UIImage imageWithFile:@"dev_add_btn_cancel.png"] ;
    
    if ([backImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
        
        backImg = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithImage:backImg
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backClick:)];
    
    [backItem ios6cleanBackgroud];
    
    
    [self.cNavigationItem setLeftBarButtonItem:backItem];
    
    
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    _activityView = [[UIActivityIndicatorView alloc] init];
    
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activityView.color = [UIColor redColor];
    _activityView.frame = CGRectMake(rx.size.width * 0.5f, rx.size.height * 0.5f, 0, 0);
    _activityView.hidesWhenStopped = YES;

    
    [self.view addSubview:_activityView];
    
    
    
    NSString* luidStr = _luidStr;
    NSString* tipStr = nil;
    if ([luidStr hasPrefix:@"0005"]) {
        tipStr = @"门磁";
    }else if ([luidStr hasPrefix:@"0002"]) {
        tipStr = @"开关";
    }else if ([luidStr hasPrefix:@"0003"]) {
        tipStr = @"双控开关";
    }else if ([luidStr hasPrefix:@"0004"]) {
        tipStr = @"红外";
    }else{
        tipStr = @"未知";
    }

    tipStr = [NSString stringWithFormat:@"请为%@设备添加名称",tipStr];
    
    NSMutableAttributedString* astr = [[NSMutableAttributedString alloc] initWithString:tipStr];

        
    [astr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:0/255.0 green:150/255.0 blue:255/255.0 alpha:1]
                 range:NSMakeRange(2,tipStr.length - 6)];
    
    _tipLabel.attributedText = astr;
    
    [_nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- DeviceServiceDelegate


- (void) devService:(XAIDeviceService*)devService addDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    if (devService != _deviceService) return;
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                          otherButtonTitles:nil];
    
    
    if (isSuccess ) {
        
        
        [alert setMessage:NSLocalizedString(@"AddDevSuc", nil)];
        alert.delegate = self;
        
    }else{
        
        [alert setMessage:NSLocalizedString(@"AddDevFaild", nil)];
        
        if (errcode == XAI_ERROR_LUID_EXISTED) {
            
            [alert setMessage:NSLocalizedString(@"DevWasInNet", nil)];
        }
        
    }
    
    [alert show];
    
    _activityView.hidden = true;

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    
    [self animalVC_L2R:[XAIShowVC create]];
}


#pragma mark --Helper

- (void)nameTextReturn:(id)seder{

    [_nameTextField resignFirstResponder];
}


- (void)backClick:(id)seder{

    [self animalVC_L2R:[XAIShowVC create]];
}


- (void)addOneDevice:(id)seder{
    
    BOOL hasErr = true;
    
    NSString* errTip = nil;
    
    do {
        
        if ( nil == _nameTextField.text || [_nameTextField.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"请输入设备名称", nil);
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

    
    NSString* name =  _nameTextField.text;
   
    
    XAITYPELUID luid;
    
    NSScanner* scanner = [NSScanner scannerWithString:_luidStr];
    [scanner scanHexLongLong:&luid];
    
    [_deviceService addDev:luid withName:name];
    
    [_activityView startAnimating];
    _activityView.hidden = false;
}


@end
