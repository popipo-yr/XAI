//
//  XAIDevShowStatusVCGenerate.m
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevShowStatusVCGenerate.h"

#import "XAIObjectGenerate.h"

@implementation XAIDevShowStatusVCGenerate


+ (XAIDevShowStatusVC*) statusWithObject:(XAIObject*) aObj storyboard:(UIStoryboard*)storyboard {
    
    switch (aObj.type) {
        case XAIObjectType_light:{
            
            if ([aObj isKindOfClass:[XAILight class]]) {
                
                XAILightStatusVC* lightVC = [storyboard
                                             instantiateViewControllerWithIdentifier:@"XAILightStatusVCID"];
                lightVC.light = (XAILight*)aObj;
                
                
                return lightVC;
                
            }
            
        }break;
        case XAIObjectType_light2:{
            
            if ([aObj isKindOfClass:[XAILight2 class]]) {
                
                XAILightStatusVC* lightVC = [storyboard
                                             instantiateViewControllerWithIdentifier:@"XAILightStatusVCID"];
                lightVC.light = (XAILight2*)aObj;
                
                
                return lightVC;
                
            }
            
        }break;
            
        case XAIObjectType_door:{
            
            if ([aObj isKindOfClass:[XAIDoor class]]) {
                
                XAIDoorStatusVC* doorVC = [storyboard
                                             instantiateViewControllerWithIdentifier:@"XAIDoorStatusVCID"];

                doorVC.door = (XAIDoor*)aObj;
                
                [doorVC.door startControl];
                
                return doorVC;
                
            }
            
        }break;
            
        case XAIObjectType_window:{
            
            if ([aObj isKindOfClass:[XAIWindow class]]) {
                
                XAIWindowStatusVC*  windowVC = [storyboard
                                             instantiateViewControllerWithIdentifier:@"XAIWindowStatusVCID"];
                
                windowVC.window = (XAIWindow*)aObj;
                
                [windowVC.window startControl];
                
                return windowVC;
                
            }
            
        }break;
            
        default:
            break;
    }
    
    return nil;
    
}


@end
