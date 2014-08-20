//
//  WeiXinCell.m
//  WeixinDeom
//
//  Created by iHope on 13-12-31.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import "XAIChatCell.h"

@implementation XAIChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _bubbleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        _bubbleView.backgroundColor = [UIColor clearColor];
        
        _photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        
        [self.contentView addSubview:_bubbleView];
        [self.contentView addSubview:_photo];
        
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContent:(NSMutableDictionary*)dict
{
    if ([[dict objectForKey:@"name"]isEqualToString:@"rhl"]) {
        _photo.frame = CGRectMake(320-60, 10, 50, 50);
        _photo.image = [UIImage imageNamed:@"photoUsr"];
        
        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
            [self yuyinView:1 from:YES withPosition:65 withView:_bubbleView];
        }else{
            [self bubbleView:[dict objectForKey:@"content"] from:YES withPosition:65 withView:_bubbleView];
        }
        
    }else{
        _photo.frame = CGRectMake(10, 10, 50, 50);
        _photo.image = [UIImage imageNamed:@"photoXAI"];
        
        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
            [self yuyinView:1 from:NO withPosition:65 withView:_bubbleView];
        }else{
            [self bubbleView:[dict objectForKey:@"content"] from:NO withPosition:65 withView:_bubbleView];
        }
    }

}

//泡泡文本
- (void)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position withView:(UIView*)bulleView{
    for (UIView *subView in bulleView.subviews) {
        [subView removeFromSuperview];
    }
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
//    CGSize size = [text boundingRectWithSize:CGSizeMake(180.0f, 20000.0f) options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil].size;
    
	// build single chat bubble cell with given text
	UIView *returnView = bulleView;
	returnView.backgroundColor = [UIColor clearColor];
	
    //背影图片
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
    
//	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(30,30,25,18);
//    UIEdgeInsets edge = UIEdgeInsetsMake(25,25,15,30);
//    
//    if (fromSelf == YES) {
//        edge = UIEdgeInsetsMake(25,25,15,18);
//    }
    
    UIImage* image = [bubble resizableImageWithCapInsets:edge];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:image];
    
//    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    
   
	NSLog(@"%f,%f",size.width,size.height);
	
    
    //添加文本信息
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
	bubbleText.text = text;
	

	bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
	if(fromSelf)
		returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	else
		returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	
	[returnView addSubview:bubbleImageView];
	[returnView addSubview:bubbleText];
    
}

//泡泡语音
- (void)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf  withPosition:(int)position withView:(UIView *)yuyinView{
    
    for (UIView *subView in yuyinView.subviews) {
        [subView removeFromSuperview];
    }
    
    //根据语音长度
    int yuyinwidth = 66+fromSelf;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 250;
    if(fromSelf)
        yuyinView.frame =CGRectMake(320-position-yuyinwidth, 10, yuyinwidth, 54);
	else
		yuyinView.frame =CGRectMake(position, 10, yuyinwidth, 54);
    
    button.frame = CGRectMake(0, 0, yuyinwidth, 54);
    [yuyinView addSubview:button];
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    
    [button setImage:[UIImage imageNamed:fromSelf?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceNodeDownloading":@"ReceiverVoiceNodeDownloading"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%d''",logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
}

@end
