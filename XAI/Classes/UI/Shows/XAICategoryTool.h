//
//  XAICategoryGenerate.h
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum XAICategoryType{

    XAICategoryType_doorwin = 1,
    XAICategoryType_light = 2,
    XAICategoryType_Inf = 3,
    XAICategoryType_user = 4,
    XAICategoryType_server = 5,
    XAICategoryType_bufang = 6,
    XAICategoryType_UnKown = -1,
    
}XAICategoryType;


@interface XAICategoryTool : NSObject

+ (NSArray*) devCategorys;
+ (NSString*) typeToName:(XAICategoryType)type;
+ (UIViewController*) nextViewforType:(XAICategoryType)type;

+ (NSString*) selImgStrForType:(XAICategoryType)type;
+ (NSString*) norImgStrForType:(XAICategoryType) type;

@end

