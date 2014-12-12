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
    
    //XAICategoryBtn* _bufangBtn;
    
    NSTimer* _refreshTimer;
    NSTimer* _alphaTimer;
    
    float _tipAlpha;
    float _tipAlphaAdd;
   
    
}

+ (UIViewController*) create;

@property (nonatomic,strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic,strong) IBOutlet UIButton* addBtn;
@property (nonatomic,strong) IBOutlet UILabel* label;
@property (nonatomic,strong) IBOutlet UIImageView* labelIV;
@property (nonatomic,strong) IBOutlet UIImageView* chatTipV;
@property (nonatomic,strong) IBOutlet UIImageView* centerBgImgV;
@property (nonatomic,strong) IBOutlet UIView* centerView;

@property (nonatomic,strong) IBOutlet UIButton* bufangBtn;
@property (nonatomic,strong) IBOutlet UIView* jiaohuView;


-(IBAction)userBtnClick:(id)sender;
-(IBAction)bufangBtnClick:(id)sender;
-(void)devAddBtnClick:(id)sender;

@end

