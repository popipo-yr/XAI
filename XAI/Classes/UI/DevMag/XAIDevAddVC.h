//
//  DevAddViewController.h
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIDeviceService.h"

@interface XAIDevAddVC : UIViewController
<UITableViewDataSource,UITableViewDelegate,XAIDeviceServiceDelegate,UIAlertViewDelegate>{

    NSString* _luidStr;
    
    UITableView * _typeTableView;
    UITextField * _nameTextField;
    
    NSArray*  _typeStrAry;
    
    NSIndexPath* _curSelIndexPath;
    
    XAIDeviceService* _deviceService;
}

+ (UIViewController*)create:(NSString*)luidStr;

@property (strong, nonatomic) IBOutlet UITableView *typeTableView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic,strong) NSString* luidStr;

@end
