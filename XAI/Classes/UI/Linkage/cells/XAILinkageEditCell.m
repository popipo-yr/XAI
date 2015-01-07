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
    
    if (name != nil) {
        
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:name];
        self.tipTF.attributedText = str;
        
    }else{
    
        self.tipTF.text = nil;
    }
    
    self.preLab.text = @"名  称:";
    
    
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


    
    
    [_centerBtn setImage:[UIImage imageWithFile:@"link_edit_cell_bg.png"]
                forState:UIControlStateNormal];
}

-(void)labelEditFinish{
    

    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(linkageInfoCell:tipEditEnd:)]) {
        [_delegate linkageInfoCell:self tipEditEnd:self.tipTF.text];
    }

    
}

-(void)labelEditStart{

    
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(linkageInfoCellEditStart:)]) {
        [_delegate linkageInfoCellEditStart:self];
    }
    
    
}

- (void)setCondInfo:(NSString*)str nameRange:(NSRange)range{
    
    self.preLab.text = @"条  件:";
    
    if (str != nil) {
        int endStart = str.length - range.location - range.length;
        
        NSString* allStr = [NSString stringWithFormat:@"%@",str];
        
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:allStr];
        
        [str addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]
                    range:NSMakeRange(0,1)];
        [str addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]
                    range:NSMakeRange(endStart, str.length-endStart)];
        
        
        self.tipTF.attributedText = str;
        
    }else{
        
        self.tipTF.text = nil;
    }


    self.tipTF.textAlignment = NSTextAlignmentLeft;
    self.tipTF.placeholder = @"请添加触发条件";
    self.tipTF.enabled = false;
    
    
    [_centerBtn setImage:[UIImage imageWithFile:@"link_edit_cell_bg.png"]
                forState:UIControlStateNormal];
    

}

- (void) setInfo:(NSString*)str index:(int)index{
    
    
    self.tipTF.textAlignment = NSTextAlignmentLeft;
    self.tipTF.enabled = false;
    
    
    if (str != nil) {
        

        self.preLab.text = [NSString stringWithFormat:@"触发%d:",index+1];
        
        
        NSMutableAttributedString* astr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [astr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]
                    range:NSMakeRange(0,2)];
        self.tipTF.attributedText = astr;

        
        [_centerBtn setImage:[UIImage imageWithFile:@"link_edit_cell_bg.png"]
                    forState:UIControlStateNormal];
        
    }else{
    
        self.preLab.text = nil;
        self.tipTF.attributedText = nil;
        [_centerBtn setImage:[UIImage imageWithFile:@"link_edit_add.png"]
                    forState:UIControlStateNormal];
        
        if (index == 0) {
            
            [_centerBtn setImage:[UIImage imageWithFile:@"link_edit_cell_bg.png"]
                        forState:UIControlStateNormal];
            _tipTF.placeholder = @"请添加触发动作";
            self.preLab.text = @"触 发:";
            
        }else{
            _tipTF.placeholder = nil;
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
