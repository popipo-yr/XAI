//
//  XAIDeviceType.h
//  XAI
//
//  Created by office on 14-5-20.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum XAIDeviceType{
    
    XAIDeviceType_door = 0,
    XAIDeviceType_window = 1,
    XAIDeviceType_light = 2,
    XAIDeviceType_light_2 = 3,
    
}XAIDeviceType;


@interface XAIDeviceTypeUtil : NSObject

+ (NSArray*) typeAry;
+ (NSArray*) typeNameAry;
+ (NSString*) typeToName:(XAIDeviceType)type;
+ (XAIDeviceType) nameToType:(NSString*)name;

@end
