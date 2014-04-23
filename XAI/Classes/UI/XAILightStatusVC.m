//
//  XAILightStatusVC.m
//  XAI
//
//  Created by office on 14-4-23.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILightStatusVC.h"

@implementation XAILightStatusVC

- (void)viewDidLoad{

    [super viewDidLoad];
    
    _light.delegate = self;
    
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
    
    [_light getCurStatus];
    
    //[self performSelector:@selector(lightCurStatus:)];
    
    
    NSInvocation *anInvocation = [NSInvocation
                                  invocationWithMethodSignature:
                                  [XAILightStatusVC instanceMethodSignatureForSelector:@selector(lightCurStatus:)]];
    
    [anInvocation setSelector:@selector(lightCurStatus:)];
    [anInvocation setTarget:self];
    long status = 1;
    [anInvocation setArgument:&status atIndex:2];
    
    [anInvocation performSelector:@selector(invoke) withObject:nil afterDelay:1];
}


- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    CGRect curframe = self.view.frame;
    
    self.secondView.frame = CGRectMake(curframe.size.width*0.5f * 1.5
                                       ,0
                                       ,self.secondView.frame.size.width
                                       ,self.secondView.frame.size.height);

    [self.view addSubview:self.secondView];
    
    self.secondView.alpha = 0.0f;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.5f];
    //[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:NO];
   
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    self.secondView.alpha = 1.0f;
    
    
    
    
    self.secondView.frame = CGRectMake(curframe.size.width*0.5f
                                       ,0
                                       ,self.secondView.frame.size.width
                                       ,self.secondView.frame.size.height);

    
    
    
    [UIView commitAnimations];
}

#pragma mark - IBOUT

- (IBAction)swithChoose:(id)sender{

    if (_switchUI.on == YES) {
        
        [_light openLight];
        
    }else{
    
        [_light closeLight];
    
    }
    
    [_activityView startAnimating];
    
    
    NSInvocation *anInvocation = [NSInvocation
                                  invocationWithMethodSignature:
                                  [XAILightStatusVC instanceMethodSignatureForSelector:@selector(lightCloseSuccess:)]];
    
    [anInvocation setSelector:@selector(lightCloseSuccess:)];
    [anInvocation setTarget:self];
    BOOL status = YES;
    [anInvocation setArgument:&status atIndex:2];
    
    [anInvocation performSelector:@selector(invoke) withObject:nil afterDelay:1];
}

#pragma mark -- LightDelegate

#define LightOpenImg  @"obj_light_open.png"
#define LightCloseImg @"obj_light_close.png"

- (void) lightOpenSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [_statusView setImage:[UIImage imageNamed:LightOpenImg]];
        
        [_activityView stopAnimating];
    }
    
}
- (void) lightCloseSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [_statusView setImage:[UIImage imageNamed:LightCloseImg]];
        
        [_activityView stopAnimating];
    }
}

- (void) lightCurStatus:(XAILightStatus) status{
    
    NSString* imageName = (status == XAILightStatus_Open) ?LightOpenImg : LightCloseImg;
    
    [_statusView setImage:[UIImage imageNamed:imageName]];
    
    [_activityView stopAnimating];
}

@end
