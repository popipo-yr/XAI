//
//  XAIChatCell
//
//
//  Created by iHope on 13-12-31.
//  Copyright (c) . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIUser.h"

#define XAIChatCellID @"XAIChatCellID"

@interface XAIChatCell : UITableViewCell

@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UIImageView *photo;

-(void)setContent:(XAIMeg*)aMsg isfromeMe:(BOOL)isFromMe;

@end
