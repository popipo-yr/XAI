//
//  XAIDWCtrlListVC.h
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"
#import "XAIDeviceService.h"
#import "XAIReLoginRefresh.h"
#import "XAIDWCListCell.h"

#import "XAILinkageServiceHelp.h"

#include "XAIData.h"


@interface XAIDWCtrlListVC : XAIHasTableViewVC<XAIDeviceServiceDelegate,XAIDataRefreshDelegate,XAIReLoginRefresh
,XAIDWCListVCCellNewDelegate,XAILinkageServiceHelpDelegate,UIAlertViewDelegate>{
    

    XAIDeviceService* _deviceService;
    
    NSArray* _types;
    
    NSMutableArray*  _deviceDatas; /*XAIObject数组*/
    NSMutableArray* _deviceDatasNoManage; /*没有分类的数据*/
    
    
    
    NSMutableDictionary* _delInfo;
    NSMutableArray* _delAnimalIDs;
    NSMutableDictionary* _cell2Infos;
    BOOL _canDel;
    
    XAIDWCBtn* _curEditBtn;
    
    NSMutableDictionary* _cell2Purge;
    NSMutableArray* _linkageHelps;


    BOOL _gEditing;

}

@property (nonatomic,strong) IBOutlet UIImageView* tipImgView;
@property (nonatomic,strong) IBOutlet UIButton*  gEditBtn;
@property (nonatomic,strong) IBOutlet UIImageView* gStatusImgView;

-(IBAction)globalEditClick:(id)sender;
-(IBAction)bgGetClick:(id)sender;


+(UIViewController*)create;
    
    
@end


@interface XAIDWCListCellData : NSObject
@property (readonly,strong) XAIObject* oneObj;

-(void)setOne:(XAIObject *)one;

@end


@interface XAIDWCListDelInfo : NSObject
@property (nonatomic,strong) NSArray* corObjs;
@property (nonatomic,strong) XAIDWCListCellData* cellData;

@end


