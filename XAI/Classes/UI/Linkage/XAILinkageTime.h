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


- (void) setDingShi;
- (void) setYanShi;

+ (XAILinkageTime*)share;
- (IBAction)closeView:(id)sender;

-(void) addTo:(UIView*)view;
-(void) addTo:(UIView*)view point:(CGPoint)point;
-(void) addToCenter:(UIView*)view;

-(void)removeFromSuperview;

@end
