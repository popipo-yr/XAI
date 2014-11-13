//
//  XAIDoorWinCell.h
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDCBtn.h"

@protocol XAIDCListVCCellNewDelegate;

@interface XAIDCListVCCellNew : UITableViewCell<XAIDevBtnDelegate>{
    

    
}

@property (nonatomic,weak) id<XAIDCListVCCellNewDelegate> delegate;


@property (nonatomic,strong)  XAIDCBtn* oneBtn;
@property (nonatomic,strong)  XAIDCBtn* twoBtn;

@property (nonatomic, weak)  NSObject*  hasMe;  //当前持有


+ (XAIDCListVCCellNew*)create:(NSString*)useId;

-(void) setInfoOne:(XAIObject*)one two:(XAIObject*)two;

-(void) isEdit:(BOOL)isEdit;
-(void) setOnlyNeedCenter:(BOOL)isNeed;

@end


@protocol XAIDCListVCCellNewDelegate <NSObject>

-(void) dcCell:(XAIDCListVCCellNew*)cell btnDelClick:(XAIDCBtn*)btn;
-(void) dcCell:(XAIDCListVCCellNew*)cell btnEditClick:(XAIDCBtn*)btn;
-(void) dcCell:(XAIDCListVCCellNew*)cell btnEditEnd:(XAIDCBtn*)btn;
@optional
-(void) dcCell:(XAIDCListVCCellNew*)cell btnBgClick:(XAIDCBtn*)btn;
-(void) dcCell:(XAIDCListVCCellNew*)cell btnStatusChange:(XAIDCBtn*)btn;

@end

