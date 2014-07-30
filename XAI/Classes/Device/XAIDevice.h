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

typedef enum XAIDeviceStatus{
    
    XAIDeviceStatus_OFFLINE   = 0,
    XAIDeviceStatus_ONLINE    = 1,
    XAIDeviceStatus_SleepIng  = 2,
    XAIDeviceStatus_UNKOWN    = 0x99
    
}XAIDeviceStatus;

@protocol XAIDeviceStatusDelegate;
@interface  XAIDevice: XAITimeOut <MQTTPacketManagerDelegate>{

    XAITYPELUID _luid;
    XAITYPEAPSN _apsn;
    NSString* _name;
    NSString* _vender; /*生产商*/
    NSString* _model; /*型号*/
    
    XAIObjectType _corObjType;
    
    XAIDevOpr _devOpr;
    XAIDeviceType _devType;
    XAIDeviceStatus _devStatus;

}

@property (nonatomic, assign) XAITYPELUID luid;
@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* vender; /*生产商*/
@property (nonatomic, strong) NSString* model; /*型号*/
@property (nonatomic, assign) XAIObjectType corObjType;  //notgood
@property (nonatomic, assign) XAIDeviceType devType;
@property (nonatomic, assign)  XAIDeviceStatus devStatus;
@property (nonatomic, weak) id <XAIDeviceStatusDelegate> delegate;

- (void) getDeviceStatus;
- (void) getDeviceInfo;
//- (void) stopGetInfo;

/*状态关心*/
- (void) startFocusStatus;
- (void) endFocusStatus;

- (id) initWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid;

@end







@protocol XAIDeviceStatusDelegate <NSObject>

@optional

- (void) device:(XAIDevice*)device getStatus:(XAIDeviceStatus)status isSuccess:(BOOL)finish isTimeOut:(BOOL)bTimeOut;

- (void) device:(XAIDevice*)device getInfoIsSuccess:(BOOL)bSuccess isTimeOut:(BOOL)bTimeOut;

@end

typedef NS_ENUM(NSUInteger,_XAIDevOpr){

    XAIDevOpr_GetStatus = 0,
    XAIDevOpr_GetInfo = 1,
    __Dev_lastItem,
};



@interface XAIOtherInfo : NSObject

@property (nonatomic,assign) uint32_t time;
@property (nonatomic,assign) uint16_t msgid;
@property (nonatomic,assign) XAI_ERROR error;

@end




