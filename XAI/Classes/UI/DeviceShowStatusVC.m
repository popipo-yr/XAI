//
//  DeviceShowStatusVC.m
//  XAI
//
//  Created by office on 14-4-23.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "DeviceShowStatusVC.h"
#import "XAILight.h"
#import "XAILightStatusVC.h"

@implementation DeviceShowStatusVC

+ (DeviceShowStatusVC*) statusWithObject:(XAIObject*) aObj storyboard:(UIStoryboard*)storyboard {

    switch (aObj.type) {
        case XAIObjectType_light:{
        
            if ([aObj isKindOfClass:[XAILight class]]) {
                
                XAILightStatusVC* lightVC = [storyboard
                                             instantiateViewControllerWithIdentifier:@"XAILightStatusVCID"];
                lightVC.light = (XAILight*)aObj;
                
                return lightVC;
                
            }

        }
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}


- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        CGRect rx = [ UIScreen mainScreen ].bounds;
        
        _activityView = [[UIActivityIndicatorView alloc] init];
        
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityView.color = [UIColor redColor];
        _activityView.frame = CGRectMake(rx.size.width * 0.5f, rx.size.height * 0.5f, 0, 0);
        _activityView.hidesWhenStopped = YES;

    }
    
    
    return self;

}


- (void) viewWillAppear:(BOOL)animated{


    _recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handleSwipeLeft:)];
    
    [_recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:_recognizer];
    
    [super viewWillAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [self.view removeGestureRecognizer:_recognizer];
    

}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer{};
@end
