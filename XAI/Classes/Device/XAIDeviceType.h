//
//  XAIDeviceType.h
//  XAI
//
//  Created by office on 14-5-20.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>



#define DB_DEVICE_MODEL_UNKNOWN    0x00   //未知设备
#define DB_DEVICE_MODEL_MAGNET     0x01    //门磁设备(归类到主界面的门磁区域)
#define DB_DEVICE_MODEL_SWITCH_1   0x02     //单联开关(归类到主界面的开关区域)
#define DB_DEVICE_MODEL_SWITCH_2   0x03     //双联开关(归类到主界面的开关区域)
#define DB_DEVICE_MODEL_IRS        0x04      //被动红外(归类到主界面的红外区域)
#define DB_DEVICE_MODEL_USER        0x05      //手机用户和路由器(归类到主界面的用户区域)
#define DB_DEVICE_MODEL_VIRTUAL        0x06     // 虚拟设备(暂时保留未用)


typedef enum XAIDeviceType{
    
    XAIDeviceType_door = DB_DEVICE_MODEL_MAGNET,
    XAIDeviceType_light = DB_DEVICE_MODEL_SWITCH_1,
    XAIDeviceType_light_2 = DB_DEVICE_MODEL_SWITCH_2,
    XAIDeviceType_Inf = DB_DEVICE_MODEL_IRS,
    XAIDeviceType_UnKown = DB_DEVICE_MODEL_UNKNOWN,
    
}XAIDeviceType;


@interface XAIDeviceTypeUtil : NSObject

+ (NSArray*) typeAry;
+ (NSArray*) typeNameAry;
+ (NSString*) typeToName:(XAIDeviceType)type;
+ (XAIDeviceType) nameToType:(NSString*)name;

@end
