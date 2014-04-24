//
//  XAIChangeCell.m
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIChangeCell.h"

@implementation XAIChangeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTextFiledWithLable:(NSString*)string{

//    _textFiled.enabled = false;
//    cell.textFiled.alpha = 0;

    
    CGRect frame = _textFiled.frame;
    frame.origin.x += 2;
    
    UITextField* newText = [[UITextField alloc] initWithFrame:frame];
    newText.text = string;
    newText.borderStyle = UITextBorderStyleNone;
    
    [self addSubview:newText];
    
    [_textFiled removeFromSuperview];
    _textFiled = newText;
}

@end
