//
//  XAILightListCellID.h
//  XAI
//
//  Created by office on 14-8-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SWTableViewCell.h"

@class XAILightListVC;

#define  XAILightListCellID @"XAILightListCellID"
@interface XAILightListVCCell : SWTableViewCell

@property (nonatomic,strong)  IBOutlet UIImageView*  headImageView;
@property (nonatomic,strong)  IBOutlet UILabel*  nameLable;
@property (nonatomic,strong)  IBOutlet UILabel*  contextLable;
@property (nonatomic,strong)  IBOutlet UITextField* input;

@end


#define  XAILightListCellChildID @"XAILightListCellChildID"
@interface XAILightListVCChildCell : SWTableViewCell

@property (nonatomic,strong)  IBOutlet UIImageView*  headImageView;
@property (nonatomic,strong)  IBOutlet UILabel*  nameLable;
@property (nonatomic,strong)  IBOutlet UILabel*  contextLable;
@property (nonatomic,strong)  IBOutlet UITextField* input;

@end


#define  XAILightListCell2ID @"XAILightListCell2ID"
@interface XAILightListVCCell2 : SWTableViewCell
<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>{

    NSArray* _datas;
    XAILightListVCChildCell* _curInputCell;
    
    NSMutableArray* _cells;

}

@property (nonatomic,strong)  IBOutlet UITableView* cTableView;
@property (nonatomic, weak)  XAILightListVC* topVC;

- (BOOL) isallInCenter;
- (void) setDatas:(NSArray*)datas;

- (void) hidenAll;



@end
