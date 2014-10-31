//
//  XAILightListCellID.h
//  XAI
//
//  Created by office on 14-8-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILight.h"
#import "XAISwitchBtn.h"


@protocol XAILightListVCCellNewDelegate;

@interface XAILightListVCCellNew : UITableViewCell<XAIDevBtnDelegate>{
    
    BOOL  _hasCon;
    UIImageView*  _conImgView;
    
}

@property (nonatomic,weak) id<XAILightListVCCellNewDelegate> delegate;


@property (nonatomic,strong)  XAISwitchBtn* oneBtn;
@property (nonatomic,strong)  XAISwitchBtn* twoBtn;

@property (nonatomic, weak)  NSObject*  hasMe;  //当前持有


+ (XAILightListVCCellNew*)create:(NSString*)useId;

-(void) setInfoOne:(XAILight*)one two:(XAILight*)two hasCon:(BOOL)hasCon;
-(void) isEdit:(BOOL)isEdit;


@end


@protocol XAILightListVCCellNewDelegate <NSObject>

-(void) lightCell:(XAILightListVCCellNew*)cell lightBtnDelClick:(XAISwitchBtn*)btn;
-(void) lightCell:(XAILightListVCCellNew*)cell lightBtnEditClick:(XAISwitchBtn*)btn;
-(void) lightCell:(XAILightListVCCellNew*)cell lightBtnEditEnd:(XAISwitchBtn*)btn;

@end
