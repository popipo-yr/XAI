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
#import "XAILinkageEditCell.h"

@interface XAILinkageEditSupVC : UIViewController

- (void) setLinkageUseInfo:(XAILinkageUseInfo*)useInfo;
-(XAILinkage *)getLinkage;

@end


@interface XAILinkageEditVC : XAILinkageEditSupVC
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


@property (nonatomic,strong) IBOutlet UITextField* nameTF;
@property (nonatomic,strong) IBOutlet UITextField* condTF;

-(IBAction)condClick:(id)sender;

-(IBAction)globalEditClick:(id)sender;
- (IBAction)okClick:(id)sender;

+ (UIViewController*)create;
+ (UIViewController*)create:(XAILinkage*)linkage;


- (void) setName:(NSString*)name;
- (XAILinkage*) getLinkage;


- (void) setLinkageUseInfo:(XAILinkageUseInfo*)useInfo;

@end
