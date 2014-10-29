//
//  XAIUserAddVC.h
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewController.h"

#import "XAIUserService.h"

@interface XAIUserAddVC : UIViewController
<UIAlertViewDelegate,XAIUserServiceDelegate,UITextFieldDelegate>{

    NSArray* _addUserInfoAry;
    
    
    XAIUserService* _userService;
    
    UIActivityIndicatorView* _activityView;
    
}

@property (nonatomic,strong) IBOutlet UITextField* userNameTF;
@property (nonatomic,strong) IBOutlet UITextField* userPawdTF;
@property (nonatomic,strong) IBOutlet UITextField* userPawdRepTF;
@property (nonatomic,strong) IBOutlet UIButton*  sexBtn;
@property (nonatomic,strong) IBOutlet UIView* moveView;

+(XAIUserAddVC*)create;
- (IBAction)sexClick:(id)sender;

- (IBAction)headImgClick:(id)sender;
- (IBAction)okBtnClick:(id)sender;
@end
