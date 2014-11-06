//
//  LinkageListVC.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"
#import "XAILinkageService.h"
#import "XAILinkageListCell.h"

@interface XAILinkageListVC : XAIHasTableViewVC
<XAILinkageServiceDelegate,XAILinkageListCellDelegate>{
    
    XAILinkageService* _linkageService;
    NSMutableArray*  _Datas;
    NSMutableDictionary* _delInfo;
    NSMutableDictionary* _changeInfo;
    NSMutableDictionary* _cellInfos;
    
    NSArray* _swipes;
    
    NSMutableArray* _delAnimalIDs;
    BOOL _canDel;
    BOOL _gEditing;
    
}

@property (nonatomic,strong) IBOutlet UIView* retView;
@property (nonatomic,strong) IBOutlet UIButton* gEditBtn;

-(IBAction)globalEditClick:(id)sender;

+(XAILinkageListVC*)create;
+(XAILinkageListVC*)createWithNav;

@end
