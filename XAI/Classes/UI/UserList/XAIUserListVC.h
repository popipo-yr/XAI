//
//  XAIUserListVC.h
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewController.h"

#import "XAIUserService.h"

@interface XAIUserListVC : XAITableViewController
<UITableViewDataSource,UITabBarDelegate,XAIUserServiceDelegate>{

    XAIUserService* _userService;
    
    NSMutableArray* _userDatasAry;
}

@end


@interface XAIUserListVCCell : UITableViewCell

@property (nonatomic,strong)  IBOutlet UIImageView*  headImageView;
@property (nonatomic,strong)  IBOutlet UILabel*  nameLable;
@property (nonatomic,strong)  IBOutlet UILabel*  contextLable;

@end