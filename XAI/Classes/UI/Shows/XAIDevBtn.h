//
//  XAIDevBtn.h
//  XAI
//
//  Created by office on 14/10/29.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIObject.h"


typedef enum{
    
    XAIOCST_Open,
    XAIOCST_Close,
    XAIOCST_Unkown,
    
}XAIOCST;


/*操作状态*/
typedef enum{
    
    XAIOCOT_None,
    XAIOCOT_Start,
    XAIOCOT_Msg,
    
}XAIOCOT;

@protocol XAIDevBtnDelegate;
@interface  XAIDevBtn : UIView{
    
    XAIOCST  _status;
    XAIOCOT  _opr;
    
}

@property (nonatomic,weak) id<XAIDevBtnDelegate> delegate;

@property (nonatomic,strong) IBOutlet UILabel* nameTipLab;
@property (nonatomic,strong) IBOutlet UILabel* oprTipLab;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *delBtn;
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;

-(void) startEdit;
-(void) endEdit;

- (void) showOprStart;
- (void) showMsg;
- (void) showOprEnd;

- (void) setStatus:(XAIOCST)type;
- (void) firstStatus:(XAIOCST)staus opr:(XAIOCOT)opr tip:(NSString*)tip;

- (XAIOCOT) coverForm:(XAIObjectOprStatus)objOprStatus;

- (void) _init;

@end


@protocol XAIDevBtnDelegate <NSObject>

-(void)btnDelClick:(XAIDevBtn*)btn;
-(void)btnEditClick:(XAIDevBtn*)btn;

@end

