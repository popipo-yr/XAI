//
//  XAIDCBtn.h
//  XAI
//
//  Created by office on 14/11/3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevBtn.h"
#import "XAIDoor.h"

@interface XAIDCBtn : XAIDevBtn<XAIDoorDelegate>{

    float _angle;
    BOOL  _bRoll;
    
    
    BOOL _bPower;

}

@property (strong, nonatomic) IBOutlet UIImageView *statusTipImgView;
@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIImageView *waitRollImageView;

@property (strong, nonatomic) IBOutlet UIView* powerView;

@property (nonatomic,weak) XAIObject* weakObj;

- (void) setInfo:(XAIObject*)object;

+(XAIDCBtn*)create;

@end
