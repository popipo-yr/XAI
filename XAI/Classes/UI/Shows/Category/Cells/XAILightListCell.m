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
    
    float height = 140;

    float width = [UIScreen mainScreen].bounds.size.width;
    
     self.frame = CGRectMake(0, 0, width, height);
    
    
    
    _oneBtn = [XAISwitchBtn create];
    _twoBtn = [XAISwitchBtn create];
    
    
    CGSize btnSize = _oneBtn.frame.size;
    float inv = (width - btnSize.width*2) / 3.0f;
    
    
    
    
    _oneBtn.frame = CGRectMake(inv, 0,btnSize.width, btnSize.height);
    _twoBtn.frame = CGRectMake(inv*2 + btnSize.width ,0,btnSize.width, btnSize.height);
    
    [self addSubview:_oneBtn];
    [self addSubview:_twoBtn];
    
    
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    UILabel* sep = [[UILabel alloc] initWithFrame:CGRectMake(0, height -1 , width, 1)];
    [sep setBackgroundColor:[UIColor grayColor]];
    sep.alpha = 0.4F;
    
    
    _conImgView = [[UIImageView alloc] initWithImage:[UIImage imageWithFile:@"switch_2_con.png"]];
    _conImgView.frame = CGRectMake((self.frame.size.width - _conImgView.frame.size.width) *0.5,
                                   (self.frame.size.height - _conImgView.frame.size.height)*0.5f,
                                   _conImgView.frame.size.width,
                                   _conImgView.frame.size.height);
    
    [self addSubview:_conImgView];
    //_conImgView.hidden = true;
    
    
    [self addSubview:sep];
    

    _oneBtn.delegate = self;
    _twoBtn.delegate = self;
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageWithFile:@"dev_change.png"] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    
    _delBtn    = [UIButton buttonWithType:UIButtonTypeCustom];
    [_delBtn setImage:[UIImage imageWithFile:@"dev_del_nor.png"] forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(delClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _editBtn.frame = CGRectMake(10, (height - 23)*0.5f, 23, 23);
    _delBtn.frame = CGRectMake(width - 10 - 23, (height - 23)*0.5f , 23, 23);
    
    [self addSubview:_editBtn];
    [self addSubview:_delBtn];
    
    _editBtn.hidden = true;
    _delBtn.hidden = true;


}

-(void)editClick{

    [self.oneBtn editNickStart];
    [self.twoBtn editNickStart];
    
}

-(void)delClick{

    if (nil != _delegate
        && [_delegate respondsToSelector:@selector(lightCell:lightBtnDelClick:)]) {
        
        [_delegate lightCell:self lightBtnDelClick:nil];
    }

}

-(void) setInfoOne:(XAILight*)one two:(XAILight*)two hasCon:(BOOL)hasCon{

    _hasCon = hasCon;
    
    [_oneBtn setInfo:one];
    [_twoBtn setInfo:two];
    
    _oneBtn.hidden = (one == nil);
    _twoBtn.hidden = (two == nil);
    _oneBtn.userInteractionEnabled = (one != nil);
    _twoBtn.userInteractionEnabled = (two != nil);
    
    _conImgView.hidden = !_hasCon;

}

- (void) isEdit:(BOOL)isEdit{

    if (isEdit) {
        [self.oneBtn startEdit];
        [self.twoBtn startEdit];
    }else{
        [self.oneBtn endEdit];
        [self.twoBtn  endEdit];
        
        [self.oneBtn editNickStop];
        [self.twoBtn editNickStop];
    }
    
    //_conImgView.hidden = (isEdit && _hasCon) ? false : true;
    
    _editBtn.hidden = !isEdit;
    _delBtn.hidden = !isEdit;
}

-(void) setOnlyNeedCenter:(BOOL)isNeed{
    
    //if (_twoBtn.hidden == false) return;

    CGSize btnSize = _oneBtn.frame.size;
    
    
    if (isNeed) {
        
        float inv = (self.frame.size.width - btnSize.width) / 2.0f;
        _oneBtn.frame = CGRectMake(inv, 0,btnSize.width, btnSize.height);
        
    }else{
    
        float inv = (self.frame.size.width - btnSize.width*2) / 3.0f;
        _oneBtn.frame = CGRectMake(inv, 0,btnSize.width, btnSize.height);
    }
}

#pragma mark - delegate

-(void)btnEditClick:(XAIDevBtn *)btn{
    
    XAISwitchBtn* sBtn = (XAISwitchBtn*)btn;

    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(lightCell:lightBtnEditClick:)]
        && [sBtn isKindOfClass:[XAISwitchBtn class]]) {
        [_delegate lightCell:self lightBtnEditClick:sBtn];
    }
    
    if (btn != self.oneBtn) {
        [self.oneBtn editNickStop];
    }
    
    if (btn != self.twoBtn) {
        [self.twoBtn editNickStop];
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

    [self.oneBtn editNickStop];
    [self.twoBtn editNickStop];
}


-(void)btnEditOk:(XAIDevBtn *)btn{


    XAISwitchBtn* sBtn = (XAISwitchBtn*)btn;
    if (sBtn != nil
        && sBtn.weakLight != nil) {
    
        sBtn.weakLight.nickName = sBtn.nameTipLab.text;
        
        [[XAIData shareData] upDateObj:sBtn.weakLight];
    }
        
}

-(void)btnStatusChange:(XAIDevBtn *)btn{

    XAISwitchBtn* sBtn = (XAISwitchBtn*)btn;
    if (nil != _delegate
        && [_delegate respondsToSelector:@selector(lightCell:lightBtnStatusChange:)]
        && [sBtn isKindOfClass:[XAISwitchBtn class]]) {
        
        [_delegate lightCell:self lightBtnStatusChange:sBtn];
    }
}


@end
