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

@interface XAIChatCell : UITableViewCell{

    UIView* _bubbleView;
    UIImageView* _photo;
}


-(void)setContent:(XAIMeg*)aMsg isfromeMe:(BOOL)isFromMe;

@end


#define XAIChatTimeCellID @"XAIChatTimeCellID"
@interface XAIChatTimeCell : UITableViewCell{

    UILabel* _label;

}


-(void)setDate:(NSDate*)date;

@end
