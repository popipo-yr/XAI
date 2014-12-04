//
//  XAISwitchBtn.h
//  XAI
//
//  Created by office on 14/10/29.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevBtn.h"
#import "XAILight.h"

@interface XAISwitchBtn : XAIDevBtn<XAILigthtDelegate,UITextFieldDelegate>{

    float _angle;
    BOOL  _bRoll;
    
    float _fade;
    BOOL _bFade;
    BOOL _bDelFade;

}

@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;
@property (strong, nonatomic) IBOutlet UIImageView *statusTextImgView;
@property (strong, nonatomic) IBOutlet UIImageView *statusTipImgView;
@property (strong, nonatomic) IBOutlet UIImageView *unkownImgView;
@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIImageView *waitRollImageView;


//@property (nonatomic, weak)  XAILightListVC* topVC;
@property (nonatomic,weak) XAILight* weakLight;

+(XAISwitchBtn*)create;


- (void) setInfo:(XAILight*)aObj;

-(void) editNickStart;
-(void) editNickStop;

@end
