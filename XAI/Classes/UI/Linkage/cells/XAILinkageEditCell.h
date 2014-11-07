//
//  XAILinkageInfoCell.h
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"

#define _C_XAILinkageEditCellID @"XAILinkageEditCellID"


@protocol XAILinkageInfoCellDelegate;
@interface XAILinkageEditCell : UITableViewCell


@property (nonatomic,weak) id<XAILinkageInfoCellDelegate>  delegate;

@property (nonatomic,strong) IBOutlet UITextField* tipTF;
@property (nonatomic,strong) IBOutlet UIButton*  delBtn;
@property (nonatomic,strong) IBOutlet UIButton*  centerBtn;
@property (nonatomic,strong) IBOutlet UILabel* numberLab;

- (IBAction)resultClick:(id)sender;
- (IBAction)delClick:(id)sender;

- (void) setName:(NSString*)name;
- (void) setCondInfo:(NSString*)str;
- (void) setInfo:(NSString*)str index:(int)index;


-(void) isEidt:(BOOL)isEdit;

@end

@protocol XAILinkageInfoCellDelegate  <NSObject>

-(void)linkageInfoCellResultClick:(XAILinkageEditCell*)cell;
-(void)linkageInfoCellDelClick:(XAILinkageEditCell*)cell;
-(void)linkageInfoCell:(XAILinkageEditCell*)cell tipEditEnd:(NSString*)str;
-(void)linkageInfoCellEditStart:(XAILinkageEditCell*)cell;

@end
