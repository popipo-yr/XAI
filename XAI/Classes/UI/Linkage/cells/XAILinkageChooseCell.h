//
//  XAILinkageInfoAddCell.h
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectGenerate.h"


#define _C_XAILinkageChooseCellID @"XAILinkageChooseCellID"

@protocol XAILinkageChooseCellDelegate;
@interface XAILinkageChooseCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel* tipLabel;
@property (nonatomic,strong) IBOutlet UIButton* bgBtn;

@property (nonatomic,weak) id<XAILinkageChooseCellDelegate> delegate;

-(IBAction)bgBtnClick:(id)sender;

- (void) setInfo:(XAIObject*)obj;

+(XAILinkageChooseCell*)create:(NSString*)reuseId;

@end


@protocol  XAILinkageChooseCellDelegate <NSObject>

@optional
-(void)chooseCellBgClick:(XAILinkageChooseCell*)cell;

@end
