//
//  XAILinkageInfoVC.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIObjectCell.h"
#import "XAILinkageService.h"
#import "XAILinkageInfoCell.h"


@interface XAILinkageInfoVC : UIViewController
<UITableViewDataSource,UITabBarDelegate,XAILinkageServiceDelegate,XAILinkageInfoCellDelegate>{

    XAILinkageService* _linkageService;
    
    NSString* _name;
    NSMutableArray* _datas;
    
    NSIndexPath* _selIndex;
    
    XAILinkage* _linkage;
    
    UIActivityIndicatorView* _activityView;
    
    BOOL _gEditing;
}


@property (nonatomic,strong) IBOutlet UITableView* cTableView;
@property (nonatomic,strong) IBOutlet UITextField* nameTF;
@property (nonatomic,strong) IBOutlet UITextField* condTF;
@property (nonatomic,strong) IBOutlet UIButton* gEditBtn;

-(IBAction)globalEditClick:(id)sender;
- (IBAction)condClick:(id)sender;
- (IBAction)okClick:(id)sender;

+ (UIViewController*)create:(NSString*)name;
+ (UIViewController*)create:(NSString*)name linkage:(XAILinkage*)linkage;


- (void) setName:(NSString*)name;
- (void) setLinkage:(XAILinkage*)linkage;


- (void) setLinkageUseInfo:(XAILinkageUseInfo*)useInfo;

@end
