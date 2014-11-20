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
#import "XAILinkageServiceHelp.h"


#define _ST_LightListVCID @"XAILightListVCID"

@interface XAILightListVC : XAIHasTableViewVC
<XAIDeviceServiceDelegate,XAIDataRefreshDelegate
,XAIReLoginRefresh,XAILightListVCCellNewDelegate
,XAILinkageServiceHelpDelegate,UIAlertViewDelegate>{

    XAIDeviceService* _deviceService;
    
    NSArray* _types;
    
    NSMutableArray*  _deviceDatas; /*XAIObject数组*/
    
    
    NSMutableDictionary* _delInfo;   /*发起删除,记录service返回的id和删除对象,*/
    NSMutableDictionary* _cell2Infos; /*用于记录当前删除对象在当前显示列表对应的cell
                                       删除对象以hasme记录到cell,
                                       当更新cell,需移除hasme对应的删除对象,
                                       没有移除的service返回时,更新cell*/
    
    NSMutableArray* _deviceDatasNoManage; /*没有分类的数据*/
    
    
    XAISwitchBtn* _curEditBtn;
    NSMutableArray* _delAnimalIDs;  /*删除动画onebyone 需要记录cell的row*/
    BOOL _canDel;
    
    BOOL _gEditing;
    
    
    //fade 动画
    float _fade;
    BOOL _bFade;
    BOOL _bDelFade;
    
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


@interface XAILightCellData : NSObject
@property (readonly,strong) XAILight* oneLight;
@property (readonly,strong) XAILight* twoLight;
@property (readonly,assign) BOOL hasCon;

-(void)setOne:(XAILight *)one two:(XAILight*)two hasCon:(BOOL)hasCon;

@end


@interface XAILightListDelInfo : NSObject
@property (nonatomic,strong) NSArray* corObjs;
@property (nonatomic,strong) XAILightCellData* cellData;

@end

