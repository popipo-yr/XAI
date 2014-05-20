//
//  XAIDevice.h
//  XAI
//
//  Created by office on 14-4-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITimeOut.h"
#import "MQTT.h"
#import "XAIDeviceType.h"
#import "XAIObject.h"

#define Key_DeviceStatusID  127

typedef NSUInteger XAIDevOpr;

@protocol XAIDeviceStatusDelegate;
@interface  XAIDevice: XAITimeOut <MQTTPacketManagerDelegate>{

    XAITYPELUID _luid;
    XAITYPEAPSN _apsn;
    NSString* _name;
    NSString* _vender; /*生产商*/
    NSString* _model; /*型号*/
    
    XAIObjectType _type;
    
    XAIDevOpr _devOpr;

}

@property (nonatomic, assign) XAITYPELUID luid;
@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* vender; /*生产商*/
@property (nonatomic, strong) NSString* model; /*型号*/
@property (nonatomic, assign) XAIObjectType type;
@property (nonatomic, weak) id <XAIDeviceStatusDelegate> delegate;

- (void) getDeviceStatus;

/*状态关心*/
- (void) startFocusStatus;
- (void) endFocusStatus;

- (id) initWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid;

@end



typedef enum XAIDeviceStatus{
    
    XAIDeviceStatus_OFFLINE   = 0,
    XAIDeviceStatus_ONLINE    = 1,
    XAIDeviceStatus_SleepIng  = 2,
    XAIDeviceStatus_UNKOWN    = 0x99
    
}XAIDeviceStatus;



@protocol XAIDeviceStatusDelegate <NSObject>

- (void) getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish isTimeOut:(BOOL)bTimeOut;

@end

typedef NS_ENUM(NSUInteger,_XAIDevOpr){

    XAIDevOpr_GetStatus = 0,
    __Dev_lastItem,
};








