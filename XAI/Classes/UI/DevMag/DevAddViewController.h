//
//  DevAddViewController.h
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIDeviceService.h"

@interface DevAddViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,XAIDeviceServiceDelegate>{

    NSString* _luidStr;
    
    UITableView * _typeTableView;
    UITextField * _nameTextField;
    
    NSArray*  _typeStrAry;
    
    NSIndexPath* _curSelIndexPath;
    
    XAIDeviceService* _deviceService;
}

@property (strong, nonatomic) IBOutlet UITableView *typeTableView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic,strong) NSString* luidStr;

@end
