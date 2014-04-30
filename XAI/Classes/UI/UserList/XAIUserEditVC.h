//
//  XAIUserEditVC.h
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewController.h"

#import "XAIUser.h"
#import "XAIUserService.h"

#import "XAIChangeNameVC.h"
#import "XAIChangePasswordVC.h"

@interface XAIUserEditVC : XAITableViewController
<XAIUserServiceDelegate>{

    XAIUser* _userInfo;
    XAIUserService* _userService;
    
    XAIChangeNameVC* _nameVC;
    XAIChangePasswordVC* _pawVC;
    
    NSString* _newName;
    NSString* _newPwd;

}

@property (nonatomic,strong) XAIUser* userInfo;


@end
