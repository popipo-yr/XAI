//
//  XAIDWCListCell.h
//  XAI
//
//  Created by office on 15/3/30.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIDWCBtn.h"

#define  XAIDWCListCellID @"XAIDWCListCellID"

@protocol XAIDWCListVCCellNewDelegate;

@interface XAIDWCListCell : UITableViewCell<XAIDevBtnDelegate>{
    
    UIImageView*  _conImgView;
    
    UIButton* _delBtn;
    UIButton* _editBtn;
    
}

@property (nonatomic,weak) id<XAIDWCListVCCellNewDelegate> delegate;
@property (nonatomic,strong)  XAIDWCBtn* oneBtn;

@property (nonatomic, weak)  NSObject*  hasMe;  //当前持有



+ (XAIDWCListCell*)create:(NSString*)useId;

-(void) setInfo:(XAIObject*)one withType:(XAIObjectType)type;
-(void) isEdit:(BOOL)isEdit;

@end


@protocol XAIDWCListVCCellNewDelegate <NSObject>

-(void) dwcCell:(XAIDWCListCell*)cell btnDelClick:(XAIDWCBtn*)btn;
-(void) dwcCell:(XAIDWCListCell*)cell btnEditClick:(XAIDWCBtn*)btn;
-(void) dwcCell:(XAIDWCListCell*)cell btnEditEnd:(XAIDWCBtn*)btn;
-(void) dwcCell:(XAIDWCListCell*)cell btnStatusChange:(XAIDWCBtn*)btn;

@end
