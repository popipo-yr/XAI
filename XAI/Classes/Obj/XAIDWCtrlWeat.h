//
//  XAIDWCtrlWeather.h
//  XAI
//
//  Created by office on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIObject.h"
#import "XAIDevDWCtrl.h"
#import "XAIDWCtrl_head.h"

@protocol XAIDWCtrlWeatherDelegate;
@interface XAIDWCtrlWeat : XAIObject<XAIDevDWCtrlDelegate,XAIDeviceStatusDelegate>{
    
    XAIDevDWCtrl* _devDWCtrl;
    
}

@property (nonatomic, weak) id <XAIDWCtrlWeatherDelegate> delegate;

- (void) getWeatherStatus;
@end





@protocol XAIDWCtrlWeatherDelegate <NSObject>

- (void) weat:(XAIDWCtrlWeat*)weat weatherStatus:(XAIDWCtrlWeather)weather getIsSuccess:(BOOL)isSuccess;

@end


@interface XADWCWeatherOpr : XAIObjectOpr

@end


