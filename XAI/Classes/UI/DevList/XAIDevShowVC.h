//
//  ViewControllerEx.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAITableViewController.h"
#import "XAIDeviceService.h"

#import "XAIData.h"

@interface XAIDevShowVC : XAITableViewController
<UITableViewDelegate,UITableViewDataSource,XAIDeviceServiceDelegate,XAIDataRefreshDelegate>{

    XAIDeviceService* _deviceService;
    
    NSMutableArray*  _deviceDatas; /*XAIObject数组*/

}


//@property (retain,atomic) IBOutlet  UITableView* tableView;

@end
