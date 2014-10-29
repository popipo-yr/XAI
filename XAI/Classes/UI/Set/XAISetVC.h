//
//  UserVC.h
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAITableViewController.h"
#import "XAIUserService.h"

#import "XAIChangeNameVC.h"
#import "XAIChangePasswordVC.h"

#define _SI_SetVC @"show_set"

@interface XAISetVC : UIViewController
<XAIUserServiceDelegate>{

    
    XAIUserService* _userService;
    
    XAIUser* _userInfo;
    
    NSString* _newPwd;
    

    XAIChangePasswordVC* _pawVC;
    NSArray* _swipes;
}
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UITextField *pawdLab;

+ (UIViewController*) create;
- (IBAction)changePasw:(id)sender;

@end
