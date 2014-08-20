//
//  WeiXinCell.h
//  WeixinDeom
//
//  Created by iHope on 13-12-31.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XAIChatCellID @"XAIChatCellID"

@interface XAIChatCell : UITableViewCell

@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UIImageView *photo;

-(void)setContent:(NSMutableDictionary*)dict;

@end
