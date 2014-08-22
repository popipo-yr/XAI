//
//  XAILightListCellID.h
//  XAI
//
//  Created by office on 14-8-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"
#import "XAILight.h"

typedef enum {
    
    XAILightListVCCellStatus_open = 1,
    XAILightListVCCellStatus_close = 2,
    XAILightListVCCellStatus_start = 3,
    XAILightListVCCellStatus_err = 4,

}XAILightListVCCellStatus;

@class XAILightListVC;

@interface _XAILightListVCCell : XAIObjectCell <XAILigthtDelegate>

@property (nonatomic,weak) XAILight* weakLight;

- (void) setInfo:(XAIObject*)aObj;
//- (void) setLightStatus:(XAILightStatus)lightStatus oprstatus:(XAIObjectOprStatus)status;
@end



#define  XAILightListCellID @"XAILightListCellID"
@interface XAILightListVCCell : _XAILightListVCCell


@end


#define  XAILightListCellChildID @"XAILightListCellChildID"
@interface XAILightListVCChildCell : _XAILightListVCCell


@end


#define  XAILightListCell2ID @"XAILightListCell2ID"
@interface XAILightListVCCell2 : SWTableViewCell
<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>{

    NSArray* _datas;
    NSMutableArray* _cells;
    
    XAILightListVCChildCell* _curInputCell;
    
    UIImageView* _xuxianView;
    UIImageView* _xuxianView2;
    


}

@property (nonatomic, weak)  NSObject*  hasMe;
@property (nonatomic,strong)  IBOutlet UITableView* cTableView;
@property (nonatomic,strong)  IBOutlet UIView* backView;
@property (nonatomic, weak)  XAILightListVC* topVC;

- (BOOL) isallInCenter;
- (void) setDatas:(NSArray*)datas;

- (void) hidenAll;

- (void) refreshOpr;

- (void) enableChild:(BOOL)bl;

@end
