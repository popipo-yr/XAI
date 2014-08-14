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

#define _ST_LightListVCID @"XAILightListVCID"

@interface XAILightListVC : XAIHasTableViewVC
<XAIDeviceServiceDelegate,XAIDataRefreshDelegate,SWTableViewCellDelegate>{

    XAIDeviceService* _deviceService;
    
    NSMutableArray*  _deviceDatas; /*XAIObject数组*/

}


+(UIViewController*)create;

@end


#define  XAILightListCellID @"XAILightListCellID"
@interface XAILightListVCCell : SWTableViewCell

@property (nonatomic,strong)  IBOutlet UIImageView*  headImageView;
@property (nonatomic,strong)  IBOutlet UILabel*  nameLable;
@property (nonatomic,strong)  IBOutlet UILabel*  contextLable;

@end