//
//  XAILauchVC.m
//  XAI
//
//  Created by office on 14-9-29.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILauchVC.h"

@interface XAILauchVC ()

@end

@implementation XAILauchVC
+(UIViewController *)create{

    UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"NewLauch" bundle:nil];
    
    // Instantiate the initial view controller object from the storyboard
    UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
    
    return initialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){
     
        if ([UIScreen is_35_Size]) {
            _logView.frame = CGRectMake(_logView.frame.origin.x,
                                        140*0.5f,
                                        _logView.frame.size.width,
                                        _logView.frame.size.height);
            [_bgImgView setImage:[UIImage imageWithFile:@"lauchnew-3.5.png"]];
        }else{
        
            _logView.frame = CGRectMake(_logView.frame.origin.x,
                                        168*0.5f,
                                        _logView.frame.size.width,
                                        _logView.frame.size.height);
            [_bgImgView setImage:[UIImage imageWithFile:@"lauchnew-4.png"]];
        }
        
    //}
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _label.text = [NSString stringWithFormat:@"v.%@",version];
    
    
//    CABasicAnimation *animation = [ CABasicAnimation
//                                   animationWithKeyPath: @"transform" ];
//    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    
//    //围绕Z轴旋转，垂直与屏幕
//    animation.toValue = [ NSValue valueWithCATransform3D:
//                         
//                         
//                         CATransform3DMakeRotation(-M_PI, 0, 0, 1.0) ];
//    animation.duration = 1;
//    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
//    animation.cumulative = YES;
//    animation.repeatCount = 6;
//    
//    //在图片边缘添加一个像素的透明区域，去图片锯齿
//    CGRect imageRrect = CGRectMake(0, 0,_lightImgView.frame.size.width, _lightImgView.frame.size.height);
//    UIGraphicsBeginImageContext(imageRrect.size);
//    [_lightImgView.image drawInRect:CGRectMake(1,1,_lightImgView.frame.size.width-2,_lightImgView.frame.size.height-2)];
//    _lightImgView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [_lightImgView.layer addAnimation:animation forKey:nil];



}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    _curRotate = 0;
    float inv = 0.05f;
    _timer = [NSTimer scheduledTimerWithTimeInterval:inv // 10ms
                                              target:self
                                            selector:@selector(loop)
                                            userInfo:nil
                                             repeats:YES];
    
    _overTimer = [NSTimer scheduledTimerWithTimeInterval:inv*(40*2) // 10ms
                                                  target:self
                                                selector:@selector(stoploop)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loop{
    
    _curRotate += M_PI_2 / 10.0;
    _lightImgView.transform = CGAffineTransformMakeRotation(_curRotate);
}

-(void)stoploop{

    [_timer invalidate];
    [_overTimer invalidate];
    
    [self performSelector:@selector(initializeStoryBoardBasedOnScreenSize)
               withObject:nil
               afterDelay:0.5f];
    
    
    
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
            
            
            // Set the initial view controller to be the root view controller of the window object
            self.view.window.rootViewController  = initialViewController;
            
        }
        
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
            
            
            // Set the initial view controller to be the root view controller of the window object
            self.view.window.rootViewController  = initialViewController;

        }
        
    }
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        
    {   // The iOS device = iPad
        
        UISplitViewController *splitViewController = (UISplitViewController *)self.view.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
    }
}



@end
