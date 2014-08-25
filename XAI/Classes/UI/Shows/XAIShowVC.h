//
//  XAIShowVC.h
//  XAI
//
//  Created by office on 14-8-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIData.h"
#import "XAIScanVC.h"
#import "XAICategoryBtn.h"
#import "XAIUserService.h"



#define _ST_ShowVCID @"show_main"

@interface XAIShowVC : UIViewController<XAIScanVCDelegate,XAIUserServiceDelegate>{
    
    NSArray* _swipes;
    NSMutableArray* _categorys;
    
    NSString* _luidStr;
    
    XAIUserService* _userService;
    BOOL _isChangeBufang;
    
    XAICategoryBtn* _bufangBtn;
    

}

+ (UIViewController*) create;

@property (nonatomic,strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic,strong) IBOutlet UIButton* addBtn;

-(IBAction)userBtnClick:(id)sender;
-(void)devAddBtnClick:(id)sender;

@end
