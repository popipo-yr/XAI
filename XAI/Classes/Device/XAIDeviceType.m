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
#define __switch @"开关"
#define __switch2 @"双控开关"
#define __inf   @"红外"

+ (NSArray*) typeAry{

    return @[@(XAIDeviceType_door),@(XAIDeviceType_light),@(XAIDeviceType_light_2),@(XAIDeviceType_Inf)];
}
+ (NSArray*) typeNameAry{
    
    return @[__door,__switch,__switch2,__inf];
}
+ (NSString*) typeToName:(XAIDeviceType)type{
    
    switch (type) {
        case XAIDeviceType_door:
        {
            return __door;
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
        case XAIDeviceType_Inf:
        {
            return __inf;
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
        
    }else if ([name isEqual:__switch]){
    
        return XAIDeviceType_light;
    
    }else if([name isEqual:__switch2]){
    
        return XAIDeviceType_light_2;
    
    }else if([name isEqual:__inf]){
        
        return XAIDeviceType_Inf;
    }

    return -1;
}

@end
