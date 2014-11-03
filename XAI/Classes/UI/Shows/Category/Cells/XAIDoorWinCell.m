//
//  XAIDoorWinCell.m
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDoorWinCell.h"
#import "XAIData.h"

@implementation XAIDCListVCCellNew

+ (XAIDCListVCCellNew*)create:(NSString*)useId{
    
    
    XAIDCListVCCellNew* new = [[XAIDCListVCCellNew alloc] init];
    
    
    [new _init];
    [new setValue:useId forKey:@"reuseIdentifier"];
    
    return new;
}

-(void)_init{
    
    float width = [UIScreen mainScreen].bounds.size.width;
    
    self.frame = CGRectMake(0, 0, width, 160);
    
    
    
    _oneBtn = [XAIDCBtn create];
    _twoBtn = [XAIDCBtn create];
    
    
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
    
    
    [self addSubview:sep];
    
    
    _oneBtn.delegate = self;
    _twoBtn.delegate = self;
    
    
}

-(void) setInfoOne:(XAIObject*)one two:(XAIObject*)two{
    
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
    
}

#pragma mark - delegate

-(void)btnBgClick:(XAIDevBtn *)btn{

    XAIDCBtn* sBtn = (XAIDCBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(dcCell:btnBgClick:)]
        && [sBtn isKindOfClass:[XAIDCBtn class]]) {
        [_delegate dcCell:self btnBgClick:sBtn];
    }
}

-(void)btnEditClick:(XAIDevBtn *)btn{
    
    XAIDCBtn* sBtn = (XAIDCBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(dcCell:btnEditClick:)]
        && [sBtn isKindOfClass:[XAIDCBtn class]]) {
        [_delegate dcCell:self btnEditClick:sBtn];
    }
}

-(void)btnDelClick:(XAIDevBtn *)btn{
    
    XAIDCBtn* sBtn = (XAIDCBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(dcCell:btnDelClick:)]
        && [sBtn isKindOfClass:[XAIDCBtn class]]) {
        
        [_delegate dcCell:self btnDelClick:sBtn];
    }
}

-(void)btnEditEnd:(XAIDevBtn *)btn{
    
    XAIDCBtn* sBtn = (XAIDCBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(dcCell:btnEditEnd:)]
        && [sBtn isKindOfClass:[XAIDCBtn class]]) {
        
        [_delegate dcCell:self btnEditEnd:sBtn];
    }
    
    
}


-(void)btnEditOk:(XAIDevBtn *)btn{
    
    
    XAIDCBtn* sBtn = (XAIDCBtn*)btn;
    if (sBtn != nil
        && sBtn.weakObj != nil) {
        
        sBtn.weakObj.nickName = sBtn.nameTipLab.text;
        
        [[XAIData shareData] upDateObj:sBtn.weakObj];
    }
    
}

-(void)btnStatusChange:(XAIDevBtn *)btn{
    
    XAIDCBtn* sBtn = (XAIDCBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(dcCell:btnStatusChange:)]
        && [sBtn isKindOfClass:[XAIDCBtn class]]) {
        
        [_delegate dcCell:self btnStatusChange:sBtn];
    }}


@end
    
    
