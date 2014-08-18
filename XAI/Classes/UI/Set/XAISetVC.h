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

@interface XAISetVC : XAITableViewController
<UITableViewDataSource,UITableViewDelegate,XAIUserServiceDelegate>{


    NSArray*  _userItems;
    
    XAIUserService* _userService;
    
    XAIUser* _userInfo;
    
    NSString* _newName;
    NSString* _newPwd;
    NSString* _homeName;
    
    XAIChangeNameVC* _nameVC;
    XAIChangeNameVC* _homeVC;
    XAIChangePasswordVC* _pawVC;
    NSArray* _swipes;
}

+ (UIViewController*) create;

@end
