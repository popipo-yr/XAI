//
//  XAILinkageAddNameVC.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageAddNameVC.h"
#import "XAILinkageInfoVC.h"

#define XAILinkageAddNameVCID @"XAILinkageAddNameVCID"


@implementation XAILinkageAddNameVC

+(UIViewController*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:XAILinkageAddNameVCID];
    return vc;
    
}

- (IBAction)btnClick:(id)sender{
    
    
    [_tf resignFirstResponder];

    NSString* text = _tf.text;
    
    
    UIViewController* vc = [XAILinkageInfoVC create:text];
    

    
    self.view.window.rootViewController = vc;
    

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


@end
