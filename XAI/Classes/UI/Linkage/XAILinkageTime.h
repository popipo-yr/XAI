//
//  XAILinkageTime.h
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAILinkageTime : UIView


@property (nonatomic,strong) IBOutlet UIButton* rightBtn;
@property (nonatomic,strong) IBOutlet UIButton* closeBtn;
@property (nonatomic,strong) IBOutlet UIButton* bgBtn;
@property (nonatomic,strong) IBOutlet UIDatePicker* dataPicker;


- (void) setDingShi;
- (void) setYanShi;

@end
