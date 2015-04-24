//
//  XAIDWCBtn.h
//  XAI
//
//  Created by office on 15/3/30.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIDevBtn.h"
#import "XAIDWCtrl.h"

@protocol XAIDWCBtnSliderDelegate ;

@interface XAIDWCBtn : XAIDevBtn<XAIDWCtrlDelegate>{
    
    float _angle;
    BOOL  _bRoll;
    BOOL _bPower;
    XAIObjectType _type;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *statusTipImgView;
@property (strong, nonatomic) IBOutlet UIImageView *waitRollImageViewOut;
@property (strong, nonatomic) IBOutlet UIImageView *waitRollImageViewIn;

@property (strong,nonatomic) IBOutlet UIButton* closeBtn;
@property (strong,nonatomic) IBOutlet UIButton* openBtn;
@property (strong,nonatomic) IBOutlet UIButton* stopBtn;

@property (strong,nonatomic) IBOutlet UILabel* oneOprTipLabel;

@property (strong,nonatomic) IBOutlet UIView* threeBtnView;

@property (nonatomic,weak) XAIObject* weakObj;
@property (nonatomic,weak) id<XAIDWCBtnSliderDelegate> sliderDelegate;

- (void) setInfo:(XAIDWCtrl*)object withType:(XAIObjectType)type;

+(XAIDWCBtn*)create;


-(IBAction)closeClick:(id)sender;
-(IBAction)stopClick:(id)sender;
-(IBAction)openClick:(id)sender;

@end


@protocol XAIDWCBtnSliderDelegate <NSObject>

-(void)dwcBtnSliderOpen:(XAIDWCBtn*)dwcBtn;
-(void)dwcBtnSliderStop:(XAIDWCBtn*)dwcBtn;
-(void)dwcBtnSliderClose:(XAIDWCBtn *)dwcBtn;

@end
