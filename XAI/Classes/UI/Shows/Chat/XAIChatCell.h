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

@protocol XAIChatCellDelegate;
@interface XAIChatCell : UITableViewCell{

    UIView* _bubbleView;
    UIImageView* _photo;
}

@property(nonatomic,weak) id<XAIChatCellDelegate> delegate;
-(void)setContent:(XAIMeg*)aMsg isfromeMe:(BOOL)isFromMe;
+ (float) allHeight:(XAIMeg*)aMsg;

@end


#define XAIChatTimeCellID @"XAIChatTimeCellID"
@interface XAIChatTimeCell : UITableViewCell{

    UILabel* _label;

}


-(void)setDate:(NSDate*)date;
+ (float) allHeight;

@end


@protocol XAIChatCellDelegate <NSObject>

-(void) chatCell:(XAIChatCell*)cell  clickBtnIndex:(int)index;

@end
