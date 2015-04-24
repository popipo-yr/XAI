//
//  XAIDevDWCtrl.h
//  XAI
//
//  Created by office on 15/3/30.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIDevice.h"



typedef enum XAIDevDWCtrlStatus{
    
    XAIDevDWCtrlStatusOpen = 0,
    XAIDevDWCtrlStatusClose = 1,
    XAIDevDWCtrlStatusStop = 2,
    XAIDevDWCtrlStatusOpening = 3,
    XAIDevDWCtrlStatusClosing = 4,
    
    XAIDevDWCtrlStatusUnkown = 9
    
}XAIDevDWCtrlStatus;


typedef enum XAIDevDWCtrlOpr{
    
    XAIDevDWCtrlOprOpen = 0,
    XAIDevDWCtrlOprClose = 1,
    XAIDevDWCtrlOprStop = 2,
    
    XAIDevDWCtrlOprUnkown = 9
    
}XAIDevDWCtrlOpr;

typedef NS_ENUM(NSUInteger, XAIDevDWCtrlWeatherStatus) {
    XAIDevDWCtrlWeatherStatus_Rain,
    XAIDevDWCtrlWeatherStatus_Sun,
    XAIDevDWCtrlWeatherStatus_Unknow,
};

@protocol XAIDevDWCtrlDelegate;
@interface XAIDevDWCtrl : XAIDevice

@property (nonatomic,weak) id<XAIDevDWCtrlDelegate> dwcDelegate;

- (void) getDwcStatus;
- (void) startOpr:(XAIDevDWCtrlOpr)opr;
- (void) getWeatherStatus;



-(NSArray *)getLinkageUseStatusInfos;
-(XAIDevDWCtrlStatus) linkageInfoStatus:(XAILinkageUseInfo*)useInfo;

@end





@protocol XAIDevDWCtrlDelegate <NSObject>
/*********************
 当调用getDwcStatus,如果失败直接通知代理curstatus,
 成功则通知代理status,这时server可能缓存了多个状态,则代理必须储存多个状态,通过id进行排序找出curstatus
 */
- (void) devDWCtrl:(XAIDevDWCtrl*)dwc setOpr:(XAIDevDWCtrlOpr)opr err:(XAI_ERROR)err;
- (void) devDWCtrl:(XAIDevDWCtrl*)dwc curStatus:(XAIDevDWCtrlStatus)status err:(XAI_ERROR)err;
- (void) devDWCtrl:(XAIDevDWCtrl*)dwc curStatus:(XAIDevDWCtrlStatus)status
             err:(XAI_ERROR)err otherInfo:(XAIOtherInfo*)otherInfo;
//天气
- (void) devDWCtrl:(XAIDevDWCtrl*)dwc weatherStatus:(XAIDevDWCtrlWeatherStatus)status
               err:(XAI_ERROR)err;
- (void) devDWCtrl:(XAIDevDWCtrl*)dwc weatherStatus:(XAIDevDWCtrlWeatherStatus)status
               err:(XAI_ERROR)err otherInfo:(XAIOtherInfo*)otherInfo;


@end


typedef NS_ENUM(NSUInteger,_XAIDevDWCtrlOpr){
    
    XAIDevDWCtrlOpr_GetCurStatus = __Dev_lastItem,
    XAIDevDWCtrlOpr_GetWeatherStatus,
    XAIDevDWCtrlOpr_SetStatus,
    __DevDWCtrlOpr_lastItem,
};

