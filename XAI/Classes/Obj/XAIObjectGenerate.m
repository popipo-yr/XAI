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
            
            imgNameStr = @"obj_door";
        }
            break;
        case XAIObjectType_window:{
            
            imgNameStr = @"obj_window";
        }
            break;
        case XAIObjectType_light2:
        case XAIObjectType_light:{
            
            imgNameStr = @"obj_light";
            
        } break;
            
        default:
            break;
    }
    
    return imgNameStr;
}

+ (NSArray*)  typeCanUse{
    
    __autoreleasing NSArray* types = @[[NSNumber numberWithInt:XAIObjectType_door],
                                       [NSNumber numberWithInt:XAIObjectType_light],
                                       [NSNumber numberWithInt:XAIObjectType_window]];
    
    return types;
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
        
        case XAIObjectType_light2:
        case XAIObjectType_light:{
            
            className = @"XAILightOpr";
            
        } break;
            
            
        default:break;
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
        case XAIObjectType_light2:{
            
            className = @"XAILight2";
            
        } break;
            
        default:
            break;
    }
    
    
    return className;
    
    
}


@end
