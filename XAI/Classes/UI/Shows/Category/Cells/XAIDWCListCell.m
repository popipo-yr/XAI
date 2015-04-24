//
//  XAIDWCListCell.m
//  XAI
//
//  Created by office on 15/3/30.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIDWCListCell.h"
#import "XAIData.h"

@implementation XAIDWCListCell

+ (XAIDWCListCell*)create:(NSString*)useId{
    
    
    XAIDWCListCell* new = [[XAIDWCListCell alloc] init];
    
    [new _init];
    [new setValue:useId forKey:@"reuseIdentifier"];
    
    return new;
}

-(void)_init{
    
    float width = [UIScreen mainScreen].bounds.size.width;
    
    self.frame = CGRectMake(0, 0, width, 160);
    
    
    
    _oneBtn = [XAIDWCBtn create];
    
    
    
    CGSize btnSize = _oneBtn.frame.size;
    float inv = (width - btnSize.width) / 2.0f;
    
    
    
    
    _oneBtn.frame = CGRectMake(inv, 0,btnSize.width, btnSize.height);
    
    [self addSubview:_oneBtn];
    
    
    
    [self setBackgroundColor:[UIColor clearColor]];
    
//    UILabel* sep = [[UILabel alloc] initWithFrame:CGRectMake(0, 99, width, 1)];
//    [sep setBackgroundColor:[UIColor grayColor]];
//    sep.alpha = 0.4F;
//    
//    
//    [self addSubview:sep];
    
    
    _oneBtn.delegate = self;

}

-(void) setInfo:(XAIObject*)one withType:(XAIObjectType)type{
    
    [_oneBtn setInfo:one withType:type];
    
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

-(void)btnEditClick:(XAIDevBtn *)btn{
    
    XAIDWCBtn* sBtn = (XAIDWCBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(dwcCell:btnEditClick:)]
        && [sBtn isKindOfClass:[XAIDWCBtn class]]) {
        [_delegate dwcCell:self btnEditClick:sBtn];
    }
}

-(void)btnDelClick:(XAIDevBtn *)btn{
    
    XAIDWCBtn* sBtn = (XAIDWCBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(dwcCell:btnDelClick:)]
        && [sBtn isKindOfClass:[XAIDWCBtn class]]) {
        
        [_delegate dwcCell:self btnDelClick:sBtn];
    }
}

-(void)btnEditEnd:(XAIDevBtn *)btn{
    
    XAIDWCBtn* sBtn = (XAIDWCBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(dwcCell:btnEditEnd:)]
        && [sBtn isKindOfClass:[XAIDWCBtn class]]) {
        
        [_delegate dwcCell:self btnEditEnd:sBtn];
    }
    
    
}


-(void)btnEditOk:(XAIDevBtn *)btn{
    
    
    XAIDWCBtn* sBtn = (XAIDWCBtn*)btn;
    if (sBtn != nil
        && sBtn.weakObj != nil) {
        
        sBtn.weakObj.nickName = sBtn.nameTipLab.text;
        
        [[XAIData shareData] upDateObj:sBtn.weakObj];
    }
    
}

-(void)btnStatusChange:(XAIDevBtn *)btn{
    
    XAIDWCBtn* sBtn = (XAIDWCBtn*)btn;
    
    if ( nil != _delegate
        && [_delegate respondsToSelector:@selector(dwcCell:btnStatusChange:)]
        && [sBtn isKindOfClass:[XAIDWCBtn class]]) {
        
        [_delegate dwcCell:self btnStatusChange:sBtn];
    }
}

@end
