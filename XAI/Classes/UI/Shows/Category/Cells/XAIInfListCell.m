//
//  XAIInfListCell.m
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIInfListCell.h"
#import "XAIData.h"

@implementation XAIInfListCell

+ (XAIInfListCell*)create:(NSString*)useId{
    
    
    XAIInfListCell* new = [[XAIInfListCell alloc] init];
    
    
    [new _init];
    [new setValue:useId forKey:@"reuseIdentifier"];
    
    return new;
}

-(void)_init{
    
    float width = [UIScreen mainScreen].bounds.size.width;
    
    self.frame = CGRectMake(0, 0, width, 160);
    
    
    
    _oneBtn = [XAIInfBtn create];

    
    
    CGSize btnSize = _oneBtn.frame.size;
    float inv = (width - btnSize.width) / 2.0f;
    
    
    
    
    _oneBtn.frame = CGRectMake(inv, 0,btnSize.width, btnSize.height);
    
    [self addSubview:_oneBtn];
    
    
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    UILabel* sep = [[UILabel alloc] initWithFrame:CGRectMake(0, 159, width, 1)];
    [sep setBackgroundColor:[UIColor grayColor]];
    sep.alpha = 0.4F;
    
    
    [self addSubview:sep];
    
    
    _oneBtn.delegate = self;
    
    
}

-(void) setInfo:(XAIObject*)one{
    
    [_oneBtn setInfo:one];
    
    _oneBtn.hidden = (one == nil);
    
}

- (void) isEdit:(BOOL)isEdit{
    
    if (isEdit) {
        [self.oneBtn startEdit];
    }else{
        [self.oneBtn endEdit];
    }
    
}

#pragma mark - delegate

-(void)btnBgClick:(XAIDevBtn *)btn{
    
    XAIInfBtn* sBtn = (XAIInfBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(infCell:btnBgClick:)]
        && [sBtn isKindOfClass:[XAIInfBtn class]]) {
        [_delegate infCell:self btnBgClick:sBtn];
    }
}

-(void)btnEditClick:(XAIDevBtn *)btn{
    
    XAIInfBtn* sBtn = (XAIInfBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(infCell:btnEditClick:)]
        && [sBtn isKindOfClass:[XAIInfBtn class]]) {
        [_delegate infCell:self btnEditClick:sBtn];
    }
}

-(void)btnDelClick:(XAIDevBtn *)btn{
    
    XAIInfBtn* sBtn = (XAIInfBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(infCell:btnDelClick:)]
        && [sBtn isKindOfClass:[XAIInfBtn class]]) {
        
        [_delegate infCell:self btnDelClick:sBtn];
    }
}

-(void)btnEditEnd:(XAIDevBtn *)btn{
    
    XAIInfBtn* sBtn = (XAIInfBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(infCell:btnEditEnd:)]
        && [sBtn isKindOfClass:[XAIInfBtn class]]) {
        
        [_delegate infCell:self btnEditEnd:sBtn];
    }
    
    
}


-(void)btnEditOk:(XAIDevBtn *)btn{
    
    
    XAIInfBtn* sBtn = (XAIInfBtn*)btn;
    if (sBtn != nil
        && sBtn.weakObj != nil) {
        
        sBtn.weakObj.nickName = sBtn.nameTipLab.text;
        
        [[XAIData shareData] upDateObj:sBtn.weakObj];
    }
    
}

-(void)btnStatusChange:(XAIDevBtn *)btn{
    
    XAIInfBtn* sBtn = (XAIInfBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(infCell:btnStatusChange:)]
        && [sBtn isKindOfClass:[XAIInfBtn class]]) {
        
        [_delegate infCell:self btnStatusChange:sBtn];
    }}

@end
