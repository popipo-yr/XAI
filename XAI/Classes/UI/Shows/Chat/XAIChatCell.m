//
//  XAIChatCell
//
//
//  Created by iHope on 13-12-31.
//  Copyright (c) . All rights reserved.
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

-(void)setContent:(XAIMeg*)aMsg isfromeMe:(BOOL)isFromMe{

    if (aMsg.fromLuid != 0x03) {
        
        _photo.image = [UIImage imageWithFile:@"photoUsr.png"];
        
    }else{
    
        _photo.image = [UIImage imageWithFile:@"photoXAI.png"];
    }
    
    if (isFromMe) {
        
        float width = [UIScreen mainScreen].bounds.size.width; //320
        _photo.frame = CGRectMake(width-60, 10, 50, 50);
        
    }else{
    
        _photo.frame = CGRectMake(10, 10, 50, 50);
    }
    
    if (aMsg.type == XAIMegType_Ctrl) {
      
      [self bubbleCtrlView:aMsg withPosition:65 withView:_bubbleView];
        
    }else{
    
        [self bubbleView:aMsg.context from:isFromMe withPosition:65 withView:_bubbleView];
    }
    
    

}

-(void)setContent:(NSMutableDictionary*)dict
{
    if ([[dict objectForKey:@"name"]isEqualToString:@"rhl"]) {
        
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
    UIFont *font = [UIFont systemFontOfSize:20];
//	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(180, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
	// build single chat bubble cell with given text
	UIView *returnView = bulleView;
	returnView.backgroundColor = [UIColor clearColor];
	
    //背影图片
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
    
//	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(30,35,25,18);
//    UIEdgeInsets edge = UIEdgeInsetsMake(25,25,15,30);
//    
//    if (fromSelf == YES) {
//        edge = UIEdgeInsetsMake(25,25,15,18);
//    }
    
    UIImage* image = [bubble resizableImageWithCapInsets:edge];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:image];
    
//    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    
   
	//NSLog(@"%f,%f",size.width,size.height);
	
    
    //添加文本信息
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
	bubbleText.text = text;
    bubbleText.font = font;
    
    if (fromSelf) {
        //bubbleText.textColor = [UIColor whiteColor];
    }
	

	bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
	if(fromSelf)
		returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	else
		returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	
	[returnView addSubview:bubbleImageView];
	[returnView addSubview:bubbleText];
    
}


//泡泡文本带控制
- (void)bubbleCtrlView:(XAIMeg*)aMsg withPosition:(int)position withView:(UIView*)bulleView{
    for (UIView *subView in bulleView.subviews) {
        [subView removeFromSuperview];
    }
    
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:20];
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [aMsg.context boundingRectWithSize:CGSizeMake(180, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    // build single chat bubble cell with given text
    UIView *returnView = bulleView;
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ReceiverTextNodeBkg" ofType:@"png"]];
    
    
    UIEdgeInsets edge = UIEdgeInsetsMake(30,35,25,18);
    
    UIImage* image = [bubble resizableImageWithCapInsets:edge];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:image];
    
    
    float perNor = 12.0f; //前方不平整的
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(perNor+10, 20.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = aMsg.context;
    bubbleText.font = font;
    
    //按钮的摆放,居中摆放
    float btnInvert = 2; //间隔
    float btnWidth = 56;
    float btnHeight = 24;
    
    int btnCount = [aMsg.ctrlInfo count];
    
    float totalWidth = bubbleText.frame.size.width+perNor;
    float needWidth = btnWidth*btnCount + btnInvert*(btnCount - 1) + perNor + 20;
    
    if (totalWidth < needWidth) {
        //totalWidth = 170 + perNor; //需要放下2个按钮
        totalWidth = needWidth;
    }
    

    float btnStartX = (totalWidth - btnWidth*btnCount - btnInvert*(btnCount-1))*0.5 +perNor*0.5;
    float btnStartY = bubbleText.frame.origin.y + bubbleText.frame.size.height+10.0f;
    
    float totalHeight = btnStartY + btnHeight + 5;
    
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, totalWidth , totalHeight);
    
    returnView.frame = CGRectMake(position, 0.0f, totalWidth+10.0f, totalHeight+10.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    
    for (int i = 0; i < btnCount; i++) {
        
    
        XAIMegCtrlInfo* ctrlInfo = [aMsg.ctrlInfo objectAtIndex:i];
        if ([ctrlInfo isKindOfClass:[XAIMegCtrlInfo class]]) {
            
            UIButton* aBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [aBtn setTitle:ctrlInfo.name forState:UIControlStateNormal];
            aBtn.frame = CGRectMake(btnStartX+btnInvert*i+btnWidth*i, btnStartY,
                                         btnWidth, btnHeight);
            
            [aBtn addTarget:self
                      action:@selector(btnClick:)
            forControlEvents:UIControlEventTouchUpInside];
            
            aBtn.tag = i;
            
            if (btnCount == 1) {
                
                [aBtn setBackgroundImage:[UIImage imageWithFile:@"chat_crl_btn_center.png"]
                                forState:UIControlStateNormal];
                
            }else{
                
                if (i == 0) {
                    
                    [aBtn setBackgroundImage:[UIImage imageWithFile:@"chat_crl_btn_left.png"]
                                    forState:UIControlStateNormal];
                }else if(i == btnCount - 1){
                    [aBtn setBackgroundImage:[UIImage imageWithFile:@"chat_crl_btn_ringt.png"]
                                    forState:UIControlStateNormal];

                }else{
                    [aBtn setBackgroundImage:[UIImage imageWithFile:@"chat_crl_btn_center.png"]
                                    forState:UIControlStateNormal];
                }
            
            }

            [returnView addSubview:aBtn];
            
            
        }
    }
    
}

-(void)btnClick:(id)sender{
    
    UIButton* btn = (UIButton*)sender;
    if (![btn isKindOfClass:[UIButton class]]) return;
    
    if (self.delegate != nil
        && [_delegate respondsToSelector:@selector(chatCell:clickBtnIndex:)]) {
        
        [_delegate chatCell:self clickBtnIndex:btn.tag];
    }
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
    label.text = [NSString stringWithFormat:@"%d''",(int)logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
}

+ (float) allHeight:(XAIMeg*)amsg{

    if ([amsg isKindOfClass:[XAIMeg class]]) {
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:20]};
        CGSize size = [amsg.context boundingRectWithSize:CGSizeMake(180, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        if (amsg.type == XAIMegType_Ctrl) {
            return size.height + 44 + 40;
        }
        
        
        return size.height+44;
    }
    
    return 0;
}

@end

@implementation XAIChatTimeCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(60, 5, 190, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        view.alpha = 0.2;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 190, 20)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.alpha = 0.5;
        
        [self.contentView addSubview:view];
        [self.contentView addSubview:_label];
        
        
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


-(void)setDate:(NSDate *)date{
    
    
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    _label.text = [format stringFromDate:date];
    
}

+ (float) allHeight{

    return 30;
}

@end
