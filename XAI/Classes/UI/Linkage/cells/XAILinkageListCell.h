//
//  XAILinkageListCell.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"
#import "XAILinkage.h"
#import "XAIDevBtn.h"

#define XAILinkageListCellID @"XAILinkageListCellID"
#define _C_LinkageListCellHeight 95

@protocol XAILinkageListCellDelegate;

@interface XAILinkageListCell : UITableViewCell{

    XAIOCST  _status;
    XAIOCOT  _opr;
    
    
    BOOL _bRoll;
    float _angle;
    NSTimer* _roleTimer;
    
    NSTimer* _oprTimer;
}

@property (nonatomic, weak)  NSObject*  hasMe;

@property (nonatomic,strong) IBOutlet UIButton* statusBtn;
@property (nonatomic,strong) IBOutlet UIImageView* statusImgV;
@property (nonatomic,strong) IBOutlet UIImageView* invalidImgV;
@property (nonatomic,strong) IBOutlet UILabel* nameLable;
@property (nonatomic,strong) IBOutlet UIButton* delBtn;

@property (nonatomic,strong) IBOutlet UIImageView* statusRollImgV;
@property (nonatomic,strong) IBOutlet UIImageView* oprRollImgV;
@property (nonatomic,strong) IBOutlet UIImageView* oprRollBgImgV;

@property (nonatomic,weak) id<XAILinkageListCellDelegate> delegate;


-(IBAction)statusClick:(id)sender;
-(IBAction)delClick:(id)sender;

-(void) setInfo:(XAILinkage*)linkage;

-(void) isEidt:(BOOL)isEdit;


- (void) showOprStart;
- (void) showMsg;
- (void) showOprEnd;
//
//- (void) setStatus:(XAIOCST)type;
//- (void) firstStatus:(XAIOCST)staus opr:(XAIOCOT)opr tip:(NSString*)tip;

@end


@protocol XAILinkageListCellDelegate <NSObject>

-(void)linkListCellClickDel:(XAILinkageListCell*)cell;
-(void)linkListCellClickStatusClick:(XAILinkageListCell*)cell;

@end