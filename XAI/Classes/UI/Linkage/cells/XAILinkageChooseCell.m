//
//  XAILinkageInfoAddCell.m
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageChooseCell.h"

@implementation XAILinkageChooseCell


+(XAILinkageChooseCell *)create:(NSString *)reuseId{
    
    XAILinkageChooseCell* cell = [[[UINib nibWithNibName:@"Link_Choose_Cell" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] lastObject];
    
    if ([cell isKindOfClass:[XAILinkageChooseCell class]]) {
        
        [cell setValue:reuseId forKey:@"reuseIdentifier"];
        
    }else{
        
        return nil;
    }
    
    return cell;
    
}

-(void)bgBtnClick:(id)sender{

    if (_delegate != nil
        && [_delegate respondsToSelector:@selector(chooseCellBgClick:)]) {
        [_delegate chooseCellBgClick:self];
    }

}

- (void) setInfo:(XAIObject*)obj{

    if (obj.nickName != nil && ![obj.nickName isEqualToString:@""]) {
        self.tipLabel.text = obj.nickName;
    }else{
        self.tipLabel.text = obj.name;
    }
    
    [self.bgBtn setImage:[self imgType:obj isSel:false]
                forState:UIControlStateNormal];
    [self.bgBtn setImage:[self imgType:obj isSel:true]
                forState:UIControlStateHighlighted];
    
}


-(UIImage*)imgType:(XAIObject*)obj isSel:(BOOL)isSel{
    
    NSString* imgStr = nil;
    

    if ([obj isKindOfClass:[XAILight class]]) {
        imgStr = @"link_sw_bg";
    }else if([obj isKindOfClass:[XAIDoor class]]){
        imgStr = @"link_dc_bg";
    
    }else if([obj isKindOfClass:[XAIIR class]]){
        imgStr = @"link_inf_bg";
    }
    

    if (isSel) {
        imgStr = [NSString stringWithFormat:@"%@_sel.png",imgStr];
    }else{
        imgStr = [NSString stringWithFormat:@"%@_nor.png",imgStr];
    }
    
    return [UIImage imageWithFile:imgStr];
    
}



@end
