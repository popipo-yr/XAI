//
//  XAIUserServerListVC.h
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"

#import "XAIUserService.h"

#include "XAIData.h"
#import "XAIReLoginRefresh.h"

@interface XAIUserServerListVC : XAIHasTableViewVC
<XAIUserServiceDelegate,XAIDataRefreshDelegate,SWTableViewCellDelegate,XAIReLoginRefresh>{
    
    XAIUserService* _userServiece;
    
    NSMutableArray*  _userDatas;
    
    
    
    SWTableViewCell* _curInputCell;
    UITextField*  _curInputTF;
    
    NSMutableDictionary* _delInfo;
    NSMutableDictionary* _cellInfos;
    
}


+(UIViewController*)create;


@end
