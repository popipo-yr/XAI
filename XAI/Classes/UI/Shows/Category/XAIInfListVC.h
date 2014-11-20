//
//  XAIInfListVC.h
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"

#import "XAIDeviceService.h"
#import "XAIReLoginRefresh.h"
#import "XAIInfListCell.h"

#import "XAILinkageServiceHelp.h"

#include "XAIData.h"

@interface XAIInfListVC : XAIHasTableViewVC
<XAIDeviceServiceDelegate,XAIDataRefreshDelegate,XAIReLoginRefresh
,XAIInfListCellDelegate,XAILinkageServiceHelpDelegate,UIAlertViewDelegate>
{
    
    XAIDeviceService* _deviceService;
    
    NSArray* _types;
    
    NSMutableArray*  _deviceDatas; /*XAIObject数组*/
    NSMutableArray* _deviceDatasNoManage; /*没有分类的数据*/
    
    
    
    NSMutableDictionary* _delInfo;
    NSMutableArray* _delAnimalIDs;
    NSMutableDictionary* _cell2Infos;
    BOOL _canDel;
    
    XAIInfBtn* _curEditBtn;
    BOOL _gEditing;
    
    NSMutableDictionary* _cell2Purge;
    NSMutableArray* _linkageHelps;
    
}

@property (nonatomic,strong) IBOutlet UIImageView* tipImgView;
@property (nonatomic,strong) IBOutlet UIButton*  gEditBtn;

-(IBAction)globalEditClick:(id)sender;
-(IBAction)bgGetClick:(id)sender;

+(UIViewController*)create;


@end

@interface XAIInfListCellData : NSObject
@property (readonly,strong) XAIObject* oneObj;

-(void)setOne:(XAIObject *)one;

@end


@interface XAIInfoListDelInfo : NSObject
@property (nonatomic,strong) NSArray* corObjs;
@property (nonatomic,strong) XAIInfListCellData* cellData;

@end
