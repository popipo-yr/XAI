//
//  XAILinkageInfoCell.h
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"

#define XAILinkageInfoCellID @"XAILinkageInfoCellID"


@protocol XAILinkageInfoCellDelegate;
@interface XAILinkageInfoCell : UITableViewCell


@property (nonatomic,weak) id<XAILinkageInfoCellDelegate>  delegate;

@property (nonatomic,strong) IBOutlet UITextField* tipTF;
@property (nonatomic,strong) IBOutlet UIImageView* tipView;
@property (nonatomic,strong) IBOutlet UIButton*  delBtn;

- (IBAction)resultClick:(id)sender;
- (IBAction)delClick:(id)sender;

- (void) setTiaojian:(NSString*)str;
- (void) setJieGuo:(NSString*)str;


-(void) isEidt:(BOOL)isEdit;

@end

@protocol XAILinkageInfoCellDelegate  <NSObject>

-(void)linkageInfoCellResultClick:(XAILinkageInfoCell*)cell;
-(void)linkageInfoCellDelClick:(XAILinkageInfoCell*)cell;

@end
