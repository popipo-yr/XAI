//
//  XAILinkageAlert.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAILinkageAlert : UIView

@property (nonatomic,strong) IBOutlet UIButton* leftBtn;
@property (nonatomic,strong) IBOutlet UIButton* rightBtn;
@property (nonatomic,strong) IBOutlet UIButton* closeBtn;
@property (nonatomic,strong) IBOutlet UIButton* bgBtn;
@property (nonatomic,strong) IBOutlet UILabel* label;


- (void) setLight:(NSString*)name;
- (void) setDW:(NSString*)name;
- (void) setIR:(NSString*)name;

- (void) setLightOpr:(NSString*)name;

@end
