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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification                                               object:nil];
    
    _keyboardIsUp = false;
}


-(void)viewDidDisappear:(BOOL)animated{


    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:Nil];
    
    [super viewDidDisappear:animated];
}



#define  moveLength  30
#define  _35moreLength 60

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


@end
