//
//  XAIDoorWinListVC.h
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"
#import "XAIDeviceService.h"
#import "XAIData.h"

#define _ST_DoorWinListVCID @"XAIDoorWinListVCID"

@interface XAIDoorWinListVC : XAIHasTableViewVC
<XAIDeviceServiceDelegate,XAIDataRefreshDelegate,SWTableViewCellDelegate>{
    
    XAIDeviceService* _deviceService;
    
    NSArray* _types;
    
    NSMutableArray*  _deviceDatas; /*XAIObject数组*/
    
    
    SWTableViewCell* _curInputCell;
    UITextField*  _curInputTF;
    
    NSMutableDictionary* _delInfo;
    
}


+(UIViewController*)create;
    
    
@end
