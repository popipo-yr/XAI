//
//  XAIObjectGenerate.m
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectGenerate.h"

@implementation XAIObjectGenerate



+ (NSString*) typeImageName:(XAIObjectType)type{
    
    __autoreleasing NSString* imgNameStr = nil;
    
    switch (type) {
        case XAIObjectType_door:{
            
            imgNameStr = @"obj_door.png";
        }
            break;
        case XAIObjectType_window:{
            
            imgNameStr = @"obj_window.png";
        }
            break;
        case XAIObjectType_light2_1:
        case XAIObjectType_light2_2:
        case XAIObjectType_light:{
            
            imgNameStr = @"obj_light.png";
            
        } break;
            
        case XAIObjectType_IR:{
            imgNameStr = @"obj_IR.png";
        }
            
        default:
            break;
    }
    
    return imgNameStr;
}

+ (NSString*) typeImageOpenName:(XAIObjectType)type{
    
    __autoreleasing NSString* imgNameStr = nil;
    
    switch (type) {
        case XAIObjectType_door:{
            
            imgNameStr = @"obj_door_open.png";
        }
            break;
        case XAIObjectType_window:{
            
            imgNameStr = @"obj_window_open.png";
        }
            break;
        case XAIObjectType_light2_1:
        case XAIObjectType_light2_2:
        case XAIObjectType_light:{
            
            imgNameStr = @"obj_light_open.png";
            
        } break;
            
        case XAIObjectType_IR:{
            imgNameStr = @"obj_IR_open.png";
        }
            
        default:
            break;
    }
    
    return imgNameStr;
}


+ (NSString*) typeOprClassName:(XAIObjectType)type{
    
    NSString* className = nil;
    
    switch (type) {
        case XAIObjectType_door:{
            
            className = @"XAIDoorOpr";
        }
            break;
        case XAIObjectType_window:{
            
            className = @"XAIWindowOpr";
        }
            break;
        
        case XAIObjectType_light2_1:
        case XAIObjectType_light2_2:
        case XAIObjectType_light:{
            
            className = @"XAILightOpr";
            
        }
            break;
        
        case XAIObjectType_IR:{
        
            className = @"XAIIROpr";
        }break;
            
            
        default:{
        
            NSLog(@"=====================");
            NSLog(@"typeClassName-err....");
        }break;
    }
    
    
    return className;
    
}

+ (NSString*) typeClassName:(XAIObjectType)type{
    
    NSString* className = nil;
    
    switch (type) {
        case XAIObjectType_door:{
            
             className = @"XAIDoor";
        }
            break;
        case XAIObjectType_window:{
            
            className = @"XAIWindow";
        }
            break;
        case XAIObjectType_light:{
            
            className = @"XAILight";
            
        } break;
        case XAIObjectType_light2_1:{
            
            className = @"XAILight2_CirculeOne";
            
        } break;
            
        case XAIObjectType_light2_2:{
            
            className = @"XAILight2_CirculeTwo";
            
        } break;
            
        case XAIObjectType_IR:{
            
            className = @"XAIIR";
        } break;
            
        default:
        {
            NSLog(@"=====================");
            NSLog(@"typeClassName-err....");
        }
            break;
    }
    
    
    return className;
    
    
}


@end
