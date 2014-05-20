//
//  XAIDeviceType.m
//  XAI
//
//  Created by office on 14-5-20.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDeviceType.h"

@implementation XAIDeviceTypeUtil

+ (NSArray*) typeAry{

    return @[@(XAIDeviceType_door),@(XAIDeviceType_window),@(XAIDeviceType_light),@(XAIDeviceType_light_2)];
}
+ (NSArray*) typeNameAry{
    
    return @[@"门",@"床",@"单控开关",@"双控开关"];
}
+ (NSString*) typeToName:(XAIDeviceType)type{
    
    switch (type) {
        case XAIDeviceType_door:
        {
            return @"门";
        }
            break;
        case XAIDeviceType_window:
        {
            return @"窗";
        }
            break;
        case XAIDeviceType_light:
        {
            return @"单控开关";
        }
            break;
        case XAIDeviceType_light_2:
        {
            return @"双控开关";
        }
            break;
            
        default:
            break;
    }

    return nil;
}
+ (XAIDeviceType) nameToType:(NSString*)name{
    
    if ([name isEqual:@"门"]) {
        
        return XAIDeviceType_door;
        
    }else if([name isEqual:@"窗"]){
        
        return XAIDeviceType_window;
    
    }else if ([name isEqual:@"单控开关"]){
    
        return XAIDeviceType_light;
    
    }else if([name isEqual:@"双控开关"]){
    
        return XAIDeviceType_light_2;
    
    }

    return -1;
}

@end
