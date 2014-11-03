//
//  XAIDCBtn.h
//  XAI
//
//  Created by office on 14/11/3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevBtn.h"
#import "XAIWindow.h"
#import "XAIDoor.h"

@interface XAIDCBtn : XAIDevBtn<XAIDoorDelegate,XAIWindownDelegate>{

    float _angle;
    BOOL  _bRoll;

}

@property (strong, nonatomic) IBOutlet UIImageView *statusTipImgView;
@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIImageView *waitRollImageView;


@property (nonatomic,weak) XAIObject* weakObj;

- (void) setInfo:(XAIObject*)object;

+(XAIDCBtn*)create;

@end
