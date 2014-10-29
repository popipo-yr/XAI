//
//  XAIChangePasswordVC.h
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewController.h"

@interface XAIChangePasswordVC : UIViewController
<UIAlertViewDelegate,UITextFieldDelegate>{


    id _okTarget;
    SEL _okSelector;
    
    UIActivityIndicatorView* _activityView;
    
     NSString* _barItemTitle;
    
    NSString* _oldPwd;

}

@property(nonatomic,strong) IBOutlet UITextField* nePwdTextField;
@property(nonatomic,strong) IBOutlet UITextField* nePwdRepTextField;
@property(nonatomic,strong) IBOutlet UITextField* oldPwdTextField;
@property(nonatomic,strong) IBOutlet UIView*  moveView;

-(IBAction)okClick:(id)sender;

- (void) setOldPwd:(NSString*)oldPWD;

- (void) setOKClickTarget:(id)target Selector:(SEL)selector;
- (void) endOkEvent;
- (void) endFailEvent:(NSString*)str;
- (void) setBarTitle:(NSString*)title;

- (void) starAnimal;
- (void) stopAnimal;

@end
