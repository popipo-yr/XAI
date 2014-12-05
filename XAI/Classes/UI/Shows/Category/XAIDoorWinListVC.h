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
#import "XAIReLoginRefresh.h"
#import "XAIDoorWinCell.h"

#import "XAILinkageServiceHelp.h"

#define _ST_DoorWinListVCID @"XAIDoorWinListVCID"

@interface XAIDoorWinListVC : XAIHasTableViewVC
<XAIDeviceServiceDelegate,XAIDataRefreshDelegate,XAIReLoginRefresh
,XAIDCListVCCellNewDelegate,XAILinkageServiceHelpDelegate,UIAlertViewDelegate>{
    
    XAIDeviceService* _deviceService;
    
    
    NSArray* _types;
    
    NSMutableArray*  _deviceDatas; /*XAIObject数组*/
    NSMutableArray* _deviceDatasNoManage; /*没有分类的数据*/
    
    
    NSMutableDictionary* _delInfo;
    NSMutableArray* _delAnimalIDs;
    NSMutableDictionary* _cell2Infos;
    BOOL _canDel;
    
    XAIDCBtn* _curEditBtn;
    BOOL _gEditing;
    
    NSMutableDictionary* _cell2Purge;
    NSMutableArray* _linkageHelps;
}

@property (nonatomic,strong) IBOutlet UIImageView* tipImgView;
@property (nonatomic,strong) IBOutlet UIButton*  gEditBtn;
@property (nonatomic,strong) IBOutlet UIImageView* gStatusImgView;

-(IBAction)globalEditClick:(id)sender;
-(IBAction)bgGetClick:(id)sender;


+(UIViewController*)create;
    
    
@end


@interface XAIDCCellData : NSObject
@property (readonly,strong) XAIObject* oneObj;
@property (readonly,strong) XAIObject* twoObj;
@property (readonly,assign) BOOL hasCon;

-(void)setOne:(XAIObject *)one two:(XAIObject*)two;

@end


@interface XAIDCListDelInfo : NSObject
@property (nonatomic,strong) NSArray* corObjs;
@property (nonatomic,strong) XAIDCCellData* cellData;

@end


