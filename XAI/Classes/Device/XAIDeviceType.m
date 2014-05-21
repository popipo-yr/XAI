//
//  XAIDeviceType.m
//  XAI
//
//  Created by office on 14-5-20.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDeviceType.h"

@implementation XAIDeviceTypeUtil

#define __door  @"门"
#define __window @"窗"
#define __switch @"开关"
#define __switch2 @"双控开关"

+ (NSArray*) typeAry{

    return @[@(XAIDeviceType_door),@(XAIDeviceType_window),@(XAIDeviceType_light),@(XAIDeviceType_light_2)];
}
+ (NSArray*) typeNameAry{
    
    return @[__door,__window,__switch,__switch2];
}
+ (NSString*) typeToName:(XAIDeviceType)type{
    
    switch (type) {
        case XAIDeviceType_door:
        {
            return __door;
        }
            break;
        case XAIDeviceType_window:
        {
            return __window;
        }
            break;
        case XAIDeviceType_light:
        {
            return __switch;
        }
            break;
        case XAIDeviceType_light_2:
        {
            return __switch2;
        }
            break;
            
        default:
            break;
    }

    return nil;
}
+ (XAIDeviceType) nameToType:(NSString*)name{
    
    if ([name isEqual:__door]) {
        
        return XAIDeviceType_door;
        
    }else if([name isEqual:__window]){
        
        return XAIDeviceType_window;
    
    }else if ([name isEqual:__switch]){
    
        return XAIDeviceType_light;
    
    }else if([name isEqual:__switch2]){
    
        return XAIDeviceType_light_2;
    
    }

    return -1;
}

@end
