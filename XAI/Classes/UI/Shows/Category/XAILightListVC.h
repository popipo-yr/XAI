//
//  XAILightListVC.h
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"

#import "XAIData.h"
#import "XAIDeviceService.h"

#import "XAILightListCell.h"

#define _ST_LightListVCID @"XAILightListVCID"

@interface XAILightListVC : XAIHasTableViewVC
<XAIDeviceServiceDelegate,XAIDataRefreshDelegate,SWTableViewCellDelegate>{

    XAIDeviceService* _deviceService;
    
    NSArray* _types;
    
    NSMutableArray*  _deviceDatas; /*XAIObject数组*/
    
    
//    XAILightListVCCell* _curInputCell;
    
    SWTableViewCell* _curInputCell;
    UITextField*  _curInputTF;
}



+(UIViewController*)create;


- (void) willShowLeft:(UITableViewCell*)cell;
- (void) changeInputCell:(SWTableViewCell*)cell input:(UITextField*)input;
- (BOOL) hasInput;

@end


