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
#import "XAIDoorWinListVC.h"



@implementation XAICategoryTool


#define __CT_doorwin  @"门窗"
#define __CT_switch @"开关"
#define __CT_inf   @"红外"
#define __CT_server @"服务器"
#define __CT_user @"用户"
#define __CT_bufang @"布防"

+ (NSArray*) devCategorys{

    return @[@(XAICategoryType_doorwin),@(XAICategoryType_light),@(XAICategoryType_Inf),@(XAICategoryType_bufang)];
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
        case XAICategoryType_bufang:
        {
            return __CT_bufang;
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
        
            nextVC = [XAIDoorWinListVC create];
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


+ (NSString*) selImgStrForType:(XAICategoryType)type{
    
    switch (type) {
        case XAICategoryType_doorwin:
        {
            return @"cg_dw_sel.png";
        }
            break;
        case XAICategoryType_light:
        {
            return @"cg_sw_sel.png";
        }
            break;
        case XAICategoryType_Inf:
        {
            return @"cg_inf_sel.png";
        }
            break;
        case XAICategoryType_server:
        {
            return nil;
        }
            break;
        case XAICategoryType_user:
        {
            return @"cg_user_sel.png";
        }
            break;
        case XAICategoryType_bufang:
        {
            return @"cg_bufang_sel.png";
        }
            break;
        default:
            break;
    }
    
    return nil;

}
+ (NSString*) norImgStrForType:(XAICategoryType) type{
    
    
    switch (type) {
        case XAICategoryType_doorwin:
        {
            return @"cg_dw_nor.png";
        }
            break;
        case XAICategoryType_light:
        {
            return @"cg_sw_nor.png";
        }
            break;
        case XAICategoryType_Inf:
        {
            return @"cg_inf_nor.png";
        }
            break;
        case XAICategoryType_server:
        {
            return nil;
        }
            break;
        case XAICategoryType_user:
        {
            return @"cg_user_nor.png";
        }
            break;
        case XAICategoryType_bufang:
        {
            return @"cg_bufang_nor.png";
        }
            break;
        default:
            break;
    }
    
    return nil;


}


@end
