//
//  XAILightListCellID.m
//  XAI
//
//  Created by office on 14-8-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILightListCell.h"
#import "XAILightListVC.h"
#import "XAIObjectGenerate.h"

@implementation XAILightListVCCellNew

+ (XAILightListVCCellNew*)create:(NSString*)useId{
    

    XAILightListVCCellNew* new = [[XAILightListVCCellNew alloc] init];
    
    
    [new _init];
    [new setValue:useId forKey:@"reuseIdentifier"];
    
    return new;
}

-(void)_init{

    float width = [UIScreen mainScreen].bounds.size.width;
    
     self.frame = CGRectMake(0, 0, width, 160);
    
    
    
    _oneBtn = [XAISwitchBtn create];
    _twoBtn = [XAISwitchBtn create];
    
    
    CGSize btnSize = _oneBtn.frame.size;
    float inv = (width - btnSize.width*2) / 3.0f;
    
    
    
    
    _oneBtn.frame = CGRectMake(inv, 0,btnSize.width, btnSize.height);
    _twoBtn.frame = CGRectMake(inv*2 + btnSize.width ,0,btnSize.width, btnSize.height);
    
    [self addSubview:_oneBtn];
    [self addSubview:_twoBtn];
    
    
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    UILabel* sep = [[UILabel alloc] initWithFrame:CGRectMake(0, 159, width, 1)];
    [sep setBackgroundColor:[UIColor grayColor]];
    sep.alpha = 0.4F;
    
    
    _conImgView = [[UIImageView alloc] initWithImage:[UIImage imageWithFile:@"switch_2_con.png"]];
    _conImgView.frame = CGRectMake((self.frame.size.width - _conImgView.frame.size.width) *0.5,
                                   (self.frame.size.height - _conImgView.frame.size.height)*0.5f,
                                   _conImgView.frame.size.width,
                                   _conImgView.frame.size.height);
    
    [self addSubview:_conImgView];
    _conImgView.hidden = true;
    
    [self addSubview:sep];
    

    _oneBtn.delegate = self;
    _twoBtn.delegate = self;


}

-(void) setInfoOne:(XAILight*)one two:(XAILight*)two hasCon:(BOOL)hasCon{

    _hasCon = hasCon;
    
    [_oneBtn setInfo:one];
    [_twoBtn setInfo:two];
    
    _oneBtn.hidden = (one == nil);
    _twoBtn.hidden = (two == nil);

}

- (void) isEdit:(BOOL)isEdit{

    if (isEdit) {
        [self.oneBtn startEdit];
        [self.twoBtn startEdit];
    }else{
        [self.oneBtn endEdit];
        [self.twoBtn  endEdit];
    }
    
    _conImgView.hidden = (isEdit && _hasCon) ? false : true;
}

#pragma mark - delegate

-(void)btnEditClick:(XAIDevBtn *)btn{
    
    XAISwitchBtn* sBtn = (XAISwitchBtn*)btn;

    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(lightCell:lightBtnEditClick:)]
        && [sBtn isKindOfClass:[XAISwitchBtn class]]) {
        [_delegate lightCell:self lightBtnEditClick:sBtn];
    }
}

-(void)btnDelClick:(XAIDevBtn *)btn{

     XAISwitchBtn* sBtn = (XAISwitchBtn*)btn;
    if (nil != _delegate
        && [_delegate respondsToSelector:@selector(lightCell:lightBtnDelClick:)]
        && [sBtn isKindOfClass:[XAISwitchBtn class]]) {
        
        [_delegate lightCell:self lightBtnDelClick:sBtn];
    }
}

-(void)btnEditEnd:(XAIDevBtn *)btn{

    XAISwitchBtn* sBtn = (XAISwitchBtn*)btn;
    if (nil != _delegate
        && [_delegate respondsToSelector:@selector(lightCell:lightBtnEditEnd:)]
        && [sBtn isKindOfClass:[XAISwitchBtn class]]) {
        
        [_delegate lightCell:self lightBtnEditEnd:sBtn];
    }


}


-(void)btnEditOk:(XAIDevBtn *)btn{


    XAISwitchBtn* sBtn = (XAISwitchBtn*)btn;
    if (sBtn != nil
        && sBtn.weakLight != nil) {
    
        sBtn.weakLight.nickName = sBtn.nameTipLab.text;
        
        [[XAIData shareData] upDateObj:sBtn.weakLight];
    }
        
  }

@end
