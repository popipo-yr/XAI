//
//  XAIChatVC
//  
//
//  Created by iHope on 13-11-8.
//  Copyright (c) All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIChatCell.h"
#import "XAIUser.h"
#import "XAIMobileControl.h"


@interface XAIChatVC : UIViewController <XAIMobileControlDelegate,XAIChatCellDelegate>{
    
    XAIUser* _user;
    XAIMobileControl* _mobile;
    
    NSMutableArray* _msgs ;
    
    NSMutableArray* _shows;

    CGPoint _oldMovePoint;
    
    CGRect _oldTableFrame;
    
    float _KeyBoardHeight;

}


@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UITextField* textField;
@property (nonatomic, strong) IBOutlet UIView* moveView;
@property (nonatomic, strong) IBOutlet UINavigationItem* cNavigationItem;

- (IBAction)sendBtnClick:(id)sender;

+(UIViewController*) create:(XAIUser*)user;


- (void) setUser:(XAIUser*)user;

@end
