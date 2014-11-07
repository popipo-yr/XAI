//
//  XAILinkageInfoCell.m
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageEditCell.h"

@implementation XAILinkageEditCell

-(void)setName:(NSString *)name{

    self.tipTF.text = name;
    self.tipTF.textColor = [UIColor whiteColor];
    self.tipTF.textAlignment = NSTextAlignmentLeft;
    self.tipTF.placeholder = @"请输入联动名称";
    self.tipTF.enabled = true;
    self.tipTF.returnKeyType = UIReturnKeyDone;
    [self.tipTF addTarget:self
                   action:@selector(labelEditFinish)
         forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.tipTF addTarget:self
                   action:@selector(labelEditStart)
         forControlEvents:UIControlEventEditingDidBegin];

    
    
    [_centerBtn setImage:[UIImage imageWithFile:@"link_edit_name_bg.png"]
                forState:UIControlStateNormal];
    
}

-(void)labelEditFinish{

    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(linkageInfoCell:tipEditEnd:)]) {
        [_delegate linkageInfoCell:self tipEditEnd:_tipTF.text];
    }

    
}

-(void)labelEditStart{
    
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(linkageInfoCellEditStart:)]) {
        [_delegate linkageInfoCellEditStart:self];
    }
    
    
}

- (void)setCondInfo:(NSString*)str{

    self.tipTF.text = str;
    self.tipTF.textColor = [UIColor whiteColor];
    self.tipTF.textAlignment = NSTextAlignmentLeft;
    self.tipTF.placeholder = @"请添加触发条件";
    self.tipTF.enabled = false;
    
    
    [_centerBtn setImage:[UIImage imageWithFile:@"link_edit_add_bg.png"]
                forState:UIControlStateNormal];
    
    _numberLab.hidden = true;

}

- (void) setInfo:(NSString*)str index:(int)index{
    self.tipTF.text = str;
    self.tipTF.textColor = [UIColor whiteColor];
    self.tipTF.textAlignment = NSTextAlignmentLeft;
    self.tipTF.enabled = false;
    
    
    if (str != nil) {
        
        [_centerBtn setImage:[UIImage imageWithFile:@"link_edit_save_bg.png"]
                    forState:UIControlStateNormal];
        
        _numberLab.text = [NSString stringWithFormat:@"%d",index+1];
        _numberLab.hidden = false;
    }else{
    
        [_centerBtn setImage:[UIImage imageWithFile:@"link_edit_add_bg.png"]
                    forState:UIControlStateNormal];
        _numberLab.hidden = true;
        
        if (index == 0) {
            
            _tipTF.placeholder = @"请添加触发动作";
        }else{
            _tipTF.placeholder = @"增加触发动作";
        }
    }
    

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
