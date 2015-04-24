//
//  XAIObjectGenerate.m
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectGenerate.h"

@implementation XAIObjectGenerate


+ (NSString*) typeOprClassName:(XAIObjectType)type{
    
    NSString* className = nil;
    
    switch (type) {
        case XAIObjectType_door:{
            
            className = @"XAIDoorOpr";
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
            
        case XAIObjectType_DWC_C:
        case XAIObjectType_DWC_D:
        case XAIObjectType_DWC_W:
        {
            
            className = @"XADWCOpr";
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
        case XAIObjectType_DWC_C:{
            
            className = @"XAIDWCtrl";
        } break;
        case XAIObjectType_DWC_D:{
            
            className = @"XAIDWCtrl";
        } break;
        case XAIObjectType_DWC_W:{
            
            className = @"XAIDWCtrl";
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
