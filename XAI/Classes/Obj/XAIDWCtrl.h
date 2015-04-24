//
//  XAIDWCtrl.h
//  XAI
//
//  Created by office on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIObject.h"
#import "XAIDevDWCtrl.h"
#import "XAIDWCtrl_head.h"
#import "XAIDWCtrlWeat.h"


typedef NS_ENUM(NSUInteger, XAIDWCtrlOpr) {
    XAIDWCtrlOpr_open,
    XAIDWCtrlOpr_close,
    XAIDWCtrlOpr_stop,
    XAIDWCtrlOpr_none,
};

typedef enum XAIDWCtrlStatus{
    
    XAIDWCtrlStatus_Opened = 0,
    XAIDWCtrlStatus_Closed = 1,
    XAIDWCtrlStatus_Opening = 2,
    XAIDWCtrlStatus_Closing = 3,
    XAIDWCtrlStatus_Unkown = XAIObjStatusUnkown
    
}XAIDWCtrlStatus;


@protocol XAIDWCtrlDelegate;
@interface XAIDWCtrl : XAIObject<XAIDevDWCtrlDelegate,XAIDeviceStatusDelegate
,XAIDWCtrlWeatherDelegate>{
    
    XAIDevDWCtrl* _devDWCtrl;
    XAIDWCtrlOpr _curOpr;
    
    XAIDWCtrlWeat* _weat;
    
    XAIDWCtrlStatus _lastStatus;
    
}
@property (nonatomic, weak) id <XAIDWCtrlDelegate> delegate;
@property (readonly) XAIDWCtrlStatus lastStatus;

- (void) getCurStatus;
- (void) open;
- (void) close;
- (void) stop;
- (void) getWeatherStatus;

- (BOOL) isRain;
@end





@protocol XAIDWCtrlDelegate <NSObject>

- (void) dwc:(XAIDWCtrl*)dwc curStatus:(XAIDWCtrlStatus)status getIsSuccess:(BOOL)isSuccess;
- (void) dwc:(XAIDWCtrl*)dwc weatherStatus:(XAIDWCtrlWeather)weather getIsSuccess:(BOOL)isSuccess;

- (void) dwc:(XAIDWCtrl*)dwc openSuccess:(BOOL)isSuccess;
- (void) dwc:(XAIDWCtrl*)dwc closeSuccess:(BOOL)isSuccess;
- (void) dwc:(XAIDWCtrl*)dwc stopSuccess:(BOOL)isSuccess;


@end


@interface XADWCOpr : XAIObjectOpr

@end


