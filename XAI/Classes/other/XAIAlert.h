//
//  XAIAlert.h
//  XAI
//
//  Created by office on 14-6-30.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIMobileControl.h"

@interface XAIAlert : NSObject<XAIMobileControlDelegate,UIAlertViewDelegate>{

    XAIMobileControl* _mc;
    UIAlertView*  _alertView;
}

- (void) startFocus;
- (void) stop;
+ (XAIAlert*) shareAlert;


@end
