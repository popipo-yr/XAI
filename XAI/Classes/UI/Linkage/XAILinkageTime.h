//
//  XAILinkageTime.h
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAILinkageTime : UIView


@property (nonatomic,strong) IBOutlet UIButton* okBtn;
@property (nonatomic,strong) IBOutlet UIDatePicker* dataPicker;

@property (nonatomic,strong) IBOutlet UIView* yanshiView;
@property (nonatomic,strong) IBOutlet UIView* dingshiView;

@property (nonatomic,strong) IBOutlet UIButton* everyDayBtn;
@property (nonatomic,strong) IBOutlet UIButton* oneDayBtn;
@property (nonatomic,strong) IBOutlet UILabel*  yanshiTipLab;
@property (nonatomic,strong) IBOutlet UILabel*  dingshiTipLab;



-(IBAction)everyDayClick:(id)sender;
-(IBAction)oneDayClick:(id)sender;
-(IBAction)valueChange:(id)sender;

- (void) setDingShi;
- (void) setYanShi;

+ (XAILinkageTime*)share;
- (IBAction)closeView:(id)sender;

-(void) addTo:(UIView*)view;
-(void) addTo:(UIView*)view point:(CGPoint)point;
-(void) addToCenter:(UIView*)view;

-(void)removeFromSuperview;

@end
