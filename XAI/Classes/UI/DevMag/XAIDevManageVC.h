//
//  ManageVC.h
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XAITableViewWithOprController.h"
#import "XAIDeviceService.h"
#import "XAIObject.h"
#import "XAIChangeNameVC.h"

#import "XAIData.h"

@interface XAIDevManageVC : XAITableViewWithOprController
<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate
,ZBarReaderDelegate,XAIDeviceServiceDelegate,XAIDataRefreshDelegate>{

    XAIDeviceService* _deviceService;
    NSMutableArray*  _objectAry;
    
    XAIObject* _curOprObj;
    
    XAIChangeNameVC* _vc;
    
    
    NSString* _newName; //用于修改设备名字
    

}

@end
