//
//  XAIInfBtn.h
//  XAI
//
//  Created by office on 14/11/3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevBtn.h"
#import "XAIIR.h"


@interface XAIInfBtn : XAIDevBtn<XAIIRDelegate>{

    float _angle;
    BOOL  _bRoll;
    
    NSTimer* _warnTimer;
    NSTimer* _workTimer;
    
    int _showWorkIndex;
    float _showWarnAlpha;
    BOOL _showWarnIsDel;
    
    UIImageView* _fuckImgView;

}

@property (strong, nonatomic) IBOutlet UIImageView *statusTipImgView;
@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIImageView *waitRollImageView;

@property (strong, nonatomic) IBOutlet UIImageView* nor1ImgView;
@property (strong, nonatomic) IBOutlet UIImageView* nor2ImgView;
@property (strong, nonatomic) IBOutlet UIImageView* nor3ImgView;



@property (nonatomic,weak) XAIObject* weakObj;

-(void)showWorkProc:(float)sec;
- (void) setInfo:(XAIObject*)object;

+(XAIInfBtn*)create;

@end
