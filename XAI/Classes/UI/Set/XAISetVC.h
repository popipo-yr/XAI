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

@interface XAISetVC : XAITableViewController <UITableViewDataSource,UITableViewDelegate>{


    NSArray*  _userItems;
    
    XAIUserService* _userService;
}



@end
