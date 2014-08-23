//
//  LinkageListVC.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"
#import "XAILinkageService.h"

@interface XAILinkageListVC : XAIHasTableViewVC
<XAILinkageServiceDelegate,SWTableViewCellDelegate>{
    
    XAILinkageService* _linkageService;
    NSMutableArray*  _Datas;
    NSMutableDictionary* _delInfo;
    NSMutableDictionary* _changeInfo;
    NSMutableDictionary* _cellInfos;
    
    NSArray* _swipes;
    
}

@property (nonatomic,strong) IBOutlet UIView* retView;



+(UIViewController*)create;

@end
