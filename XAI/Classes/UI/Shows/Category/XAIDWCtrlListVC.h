//
//  XAIDWCtrlListVC.h
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"


@interface XAIDWCtrlListVC : XAIHasTableViewVC{
    


    BOOL _gEditing;

}

@property (nonatomic,strong) IBOutlet UIImageView* tipImgView;
@property (nonatomic,strong) IBOutlet UIButton*  gEditBtn;
@property (nonatomic,strong) IBOutlet UIImageView* gStatusImgView;

-(IBAction)globalEditClick:(id)sender;
-(IBAction)bgGetClick:(id)sender;


+(UIViewController*)create;
    
    
@end

