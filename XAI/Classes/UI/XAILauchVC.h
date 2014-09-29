//
//  XAILauchVC.h
//  XAI
//
//  Created by office on 14-9-29.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAILauchVC : UIViewController{

    NSTimer* _timer;
    NSTimer* _overTimer;
    float _curRotate;
}

+ (UIViewController*)create;
@property (strong, nonatomic) IBOutlet UIView *logView;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;
@property (strong, nonatomic) IBOutlet UIImageView *lightImgView;
@property (strong, nonatomic) IBOutlet UILabel* label;

@end
