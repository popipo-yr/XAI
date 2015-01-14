//
//  XAILinkageAddInfoVC.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIHasTableViewVC.h"
#import "XAIObject.h"
#import "XAILinkageTime.h"
#import "XAILinkageEditVC.h"
#import "XAILinkageChooseCell.h"



@interface XAILinkageChooseVC : UIViewController
<UITableViewDataSource,UITableViewDelegate,XAILinkageChooseCellDelegate>{
    
    UIView*  _oneview;
    //------------
    NSArray* _lTableViewDatas;
    NSArray* _rTableViewDatas;
    
    BOOL _isChooseAttr1;
    int _curType;
    
}


@property (nonatomic,retain) XAILinkageEditSupVC* infoVC;

@property (nonatomic,retain) IBOutlet UITableView* leftTableView;
@property (nonatomic,retain) IBOutlet UITableView* rightTableView;

@property (nonatomic,retain) IBOutlet UIButton* attrBtn;
@property (nonatomic,retain) IBOutlet UILabel*  tipLab;

@property (nonatomic,retain) IBOutlet UIImageView* titleImgV;
@property (nonatomic,retain) IBOutlet UIImageView* headImgV;

@property (nonatomic,retain) IBOutlet UIView* rightView;

@property(nonatomic,retain) IBOutlet UIView* rightHeadView;



-(IBAction)attrBtnClick:(id)sender;
- (void) reloadRight;
-(void)attrShow:(int)type;

+(XAILinkageChooseVC*)create;

@end

