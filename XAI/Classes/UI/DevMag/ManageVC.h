//
//  ManageVC.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XAITableViewController.h"
#import "XAIDeviceService.h"
#import "XAIObject.h"

@interface ManageVC : XAITableViewController
<UITableViewDelegate,UITableViewDataSource,ZBarReaderDelegate,XAIDeviceServiceDelegate>{

    XAIDeviceService* _deviceService;
    NSMutableArray*  _objectAry;

}

@end
