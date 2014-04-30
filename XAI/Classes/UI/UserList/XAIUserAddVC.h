//
//  XAIUserAddVC.h
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewController.h"

#import "XAIUserService.h"

@interface XAIUserAddVC : XAITableViewController
<UIAlertViewDelegate,XAIUserServiceDelegate>{

    NSArray* _addUserInfoAry;
    
    UITextField* _userNameTF;
    UITextField* _userPawdTF;
    UITextField* _userPawdRepTF;
    
    XAIUserService* _userService;
}

@end
