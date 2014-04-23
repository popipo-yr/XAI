//
//  AAViewController.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAILogin.h"

@interface XAILoginVC : UIViewController <XAILoginDelegate>{


    XAILogin*  _login;
    
    UIActivityIndicatorView* _activityView;
}


@property  (nonatomic,weak) IBOutlet UITextField* nameLabel;
@property  (nonatomic,weak) IBOutlet UITextField* passwordLabel;

- (IBAction)loginBtnClick:(id)sender;


@end