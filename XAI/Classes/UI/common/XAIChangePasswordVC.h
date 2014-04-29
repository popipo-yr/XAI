//
//  XAIChangePasswordVC.h
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewController.h"

@interface XAIChangePasswordVC : XAITableViewController<UIAlertViewDelegate>{

    UITextField* _newPwdTextField;
    UITextField* _newPwdRepTextField;
    id _okTarget;
    SEL _okSelector;
    
    
     NSString* _barItemTitle;
    
    NSString* _oldPwd;

}


- (void) setOldPwd:(NSString*)oldPWD;

- (void) setOKClickTarget:(id)target Selector:(SEL)selector;
- (void) endOkEvent;
- (void) endFailEvent:(NSString*)str;
- (void) setBarTitle:(NSString*)title;


@end
