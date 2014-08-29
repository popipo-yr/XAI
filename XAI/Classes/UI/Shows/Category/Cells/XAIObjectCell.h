//
//  XAIObjectCell.h
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SWTableViewCell.h"
#import "SWTableViewCellAdd.h"
#import "XAIObject.h"

typedef enum{
    
    XAIOCST_Open,
    XAIOCST_Close,
    XAIOCST_Unkown,
    
}XAIOCST;


typedef enum{
    
    XAIOCOT_None,
    XAIOCOT_Start,
    XAIOCOT_Msg,
    
    
}XAIOCOT;

@interface XAIObjectCell : SWTableViewCell{

    XAIOCST  _status;
    XAIOCOT  _opr;
    
    UIImageView* _moves;
    
    UIImageView* _headView;
    
}

@property (nonatomic,strong)  IBOutlet UIImageView*  tipImageView;
@property (nonatomic,strong)  IBOutlet UILabel*  nameLable;
@property (nonatomic,strong)  IBOutlet UILabel*  contextLable;
@property (nonatomic,strong)  IBOutlet UITextField* input;
@property (nonatomic,strong)  IBOutlet UILabel*  tipLabel;

- (void) showOprStart:(NSString*)tip;
- (void) showMsg:(NSString*)msg;
- (void) showOprEnd;


- (void) setStatus:(XAIOCST)type;
- (void) firstStatus:(XAIOCST)staus opr:(XAIOCOT)opr tip:(NSString*)tip;

- (XAIOCOT) coverForm:(XAIObjectOprStatus)objOprStatus;


- (NSString*)closeImg;
- (NSString*)openImg;

@end

