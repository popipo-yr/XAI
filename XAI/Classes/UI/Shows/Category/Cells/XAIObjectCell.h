//
//  XAIObjectCell.h
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SWTableViewCell.h"

typedef enum{
    
    XAIObjectCellShowType_Start,
    XAIObjectCellShowType_Open,
    XAIObjectCellShowType_Close,
    XAIObjectCellShowType_Unkown,
    XAIObjectCellShowType_Error
    
}XAIObjectCellShowType;

@interface XAIObjectCell : SWTableViewCell{

    XAIObjectCellShowType preType;
    
    BOOL isShowErr;
    
}

@property (nonatomic,strong)  IBOutlet UIImageView*  headImageView;
@property (nonatomic,strong)  IBOutlet UILabel*  nameLable;
@property (nonatomic,strong)  IBOutlet UILabel*  contextLable;
@property (nonatomic,strong)  IBOutlet UITextField* input;

- (void) showStart;
- (void) showClose;
- (void) showOpen;
- (void) showError;
- (void) showUnkonw;

- (void) setPreType:(XAIObjectCellShowType)type;



@end

