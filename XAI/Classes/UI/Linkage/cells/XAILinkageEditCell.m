//
//  XAILinkageInfoCell.m
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageEditCell.h"

@implementation XAILinkageEditCell


- (void) setJieGuo:(NSString*)str{
    self.tipTF.text = str;
    self.tipTF.textColor = [UIColor whiteColor];
    self.tipTF.textAlignment = NSTextAlignmentLeft;
    self.tipView.image = [UIImage imageWithFile:@"linkage_jieguo.png"];
}
- (void) setTiaojian:(NSString*)str{
    self.tipTF.text = str;
    self.tipTF.textColor = [UIColor blackColor];
    self.tipTF.textAlignment = NSTextAlignmentLeft;
    self.tipView.image = [UIImage imageWithFile:@"linkage_tiaojan.png"];
}



-(void) isEidt:(BOOL)isEdit{

    _delBtn.hidden = !isEdit;
    _delBtn.enabled = isEdit;
}

- (IBAction)resultClick:(id)sender{
    
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(linkageInfoCellResultClick:)]) {
        [_delegate linkageInfoCellResultClick:self];
    }

}
- (IBAction)delClick:(id)sender{

    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(linkageInfoCellDelClick:)]) {
        [_delegate linkageInfoCellDelClick:self];
    }
}

@end
