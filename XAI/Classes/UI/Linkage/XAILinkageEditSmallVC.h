//
//  XAILinkageInfoVC.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAILinkageEditVC.h"
#import "XAIObjectCell.h"
#import "XAILinkageService.h"
#import "XAILinkageEditCell.h"


@interface XAILinkageEditSmallVC : XAILinkageEditSupVC
<UITableViewDataSource,UITabBarDelegate,XAILinkageServiceDelegate,XAILinkageInfoCellDelegate>{

    XAILinkageService* _linkageService;
    
    NSString* _name;
    
    NSIndexPath* _selIndex;
    
    XAILinkage* _linkage;
    XAILinkage* _oldLinkage;
    
    UIActivityIndicatorView* _activityView;
    
    BOOL _gEditing;
}


@property (nonatomic,strong) IBOutlet UITableView* cTableView;
@property (nonatomic,strong) IBOutlet UIButton* gEditBtn;

-(IBAction)globalEditClick:(id)sender;
- (IBAction)okClick:(id)sender;

+ (UIViewController*)create;
+ (UIViewController*)create:(XAILinkage*)linkage;


- (void) setName:(NSString*)name;
- (void) setLinkage:(XAILinkage*)linkage;
- (XAILinkage*) getLinkage;


- (void) setLinkageUseInfo:(XAILinkageUseInfo*)useInfo;

@end
