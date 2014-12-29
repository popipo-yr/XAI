//
//  XAISwitchOneListVC.h
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"


@interface XAISwitchOneListVC : XAIHasTableViewVC{

    BOOL _gEditing;
}

@property (nonatomic,strong) IBOutlet UIImageView* tipImgView;
@property (nonatomic,strong) IBOutlet UIButton*  gEditBtn;
@property (nonatomic,strong) IBOutlet UIImageView* gStatusImgView;

-(IBAction)globalEditClick:(id)sender;

+(UIViewController*)create;

@end


