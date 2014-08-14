//
//  XAICategoryGenerate.m
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAICategoryTool.h"

#import "XAIChatVC.h"
#import "XAILightListVC.h"


@implementation XAICategoryTool


#define __CT_doorwin  @"门窗"
#define __CT_switch @"开关"
#define __CT_inf   @"红外"
#define __CT_server @"服务器"
#define __CT_user @"用户"

+ (NSArray*) devCategorys{

    return @[@(XAICategoryType_doorwin),@(XAICategoryType_light),@(XAICategoryType_Inf),@(XAICategoryType_server)];
}

+ (NSString*) typeToName:(XAICategoryType)type{
    
    switch (type) {
        case XAICategoryType_doorwin:
        {
            return __CT_doorwin;
        }
            break;
        case XAICategoryType_light:
        {
            return __CT_switch;
        }
            break;
        case XAICategoryType_Inf:
        {
            return __CT_inf;
        }
            break;
        case XAICategoryType_server:
        {
            return __CT_server;
        }
            break;
        case XAICategoryType_user:
        {
            return __CT_user;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

+ (UIViewController*) nextViewforType:(XAICategoryType)type{

    UIViewController* nextVC = nil;
    switch (type) {
        case XAICategoryType_doorwin:{
        
            break;
        }
        case XAICategoryType_light:{
            
            nextVC = [XAILightListVC create];
            break;
        }
        case XAICategoryType_Inf:{
            
            
            break;
        }
        case XAICategoryType_server:{
            
            nextVC = [[XAIChatVC alloc] init];
            break;
        }
        case XAICategoryType_user:{
            
            
            break;
        }
            
        default:
            break;
    }

    return nextVC;
}


@end
