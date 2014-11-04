//
//  XAIInfListCell.h
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"
#import "XAIInfBtn.h"

#define  XAIInfListCellID @"XAIInfListCellID"

@protocol XAIInfListCellDelegate;
@interface XAIInfListCell : UITableViewCell<XAIDevBtnDelegate>

    

@property (nonatomic,weak) id<XAIInfListCellDelegate> delegate;


@property (nonatomic,strong)  XAIInfBtn* oneBtn;

@property (nonatomic, weak)  NSObject*  hasMe;  //当前持有


+ (XAIInfListCell*)create:(NSString*)useId;

-(void) setInfo:(XAIObject*)one;

-(void) isEdit:(BOOL)isEdit;


@end


@protocol XAIInfListCellDelegate <NSObject>

-(void) infCell:(XAIInfListCell*)cell btnDelClick:(XAIInfBtn*)btn;
-(void) infCell:(XAIInfListCell*)cell btnEditClick:(XAIInfBtn*)btn;
-(void) infCell:(XAIInfListCell*)cell btnEditEnd:(XAIInfBtn*)btn;
@optional
-(void) infCell:(XAIInfListCell*)cell btnBgClick:(XAIInfBtn*)btn;
-(void) infCell:(XAIInfListCell*)cell btnStatusChange:(XAIInfBtn*)btn;

@end

