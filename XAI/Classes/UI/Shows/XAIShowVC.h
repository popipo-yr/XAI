//
//  XAIShowVC.h
//  XAI
//
//  Created by office on 14-8-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIData.h"

#define _ST_ShowVCID @"show_main"

@interface XAIShowVC : UIViewController{
    
    NSArray* _swipes;
    NSMutableArray* _categorys;

}

+ (UIViewController*) create;

@property (nonatomic,strong) IBOutlet UIScrollView* scrollView;

-(IBAction)userBtnClick:(id)sender;

@end

