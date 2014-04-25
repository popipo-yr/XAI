//
//  XAIUserEditVC.h
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewController.h"

#import "XAIUser.h"

@interface XAIUserEditVC : XAITableViewController{

    XAIUser* _userInfo;

}

@property (nonatomic,strong) XAIUser* userInfo;

@end
