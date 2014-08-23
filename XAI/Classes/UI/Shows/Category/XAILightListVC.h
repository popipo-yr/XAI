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
#import "XAIReLoginRefresh.h"


#define _ST_LightListVCID @"XAILightListVCID"

@interface XAILightListVC : XAIHasTableViewVC
<XAIDeviceServiceDelegate,XAIDataRefreshDelegate,SWTableViewCellDelegate,XAIReLoginRefresh>{

    XAIDeviceService* _deviceService;
    
    NSArray* _types;
    
    NSMutableArray*  _deviceDatas; /*XAIObject数组*/
    
    
    NSMutableDictionary* _delInfo;
    NSMutableDictionary* _cell2Infos;
    
    
//    XAILightListVCCell* _curInputCell;
    
    SWTableViewCell* _curInputCell;
    UITextField*  _curInputTF;
}

@property (nonatomic,strong) IBOutlet UIImageView* tipImgView;

+(UIViewController*)create;


- (void) willShowLeft:(UITableViewCell*)cell;
- (void) changeInputCell:(SWTableViewCell*)cell input:(UITextField*)input;
- (BOOL) hasInput;
- (BOOL) isSame:(SWTableViewCell*)cell;
- (void) hiddenOldInput;

@end


