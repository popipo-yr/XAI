//
//  XAIObjectGenerate.h
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "XAIObject.h"
#import "XAILight.h"
#import "XAILight2_CirculeTwo.h"
#import "XAILight2_CirculeOne.h"
#import "XAIDoor.h"
#import "XAIWindow.h"
#import "XAIIR.h"

@interface XAIObjectGenerate : NSObject


+ (NSString*) typeImageName:(XAIObjectType)type; /*类型对应的图片*/
+ (NSString*) typeOprClassName:(XAIObjectType)type; /*对应操作的类名*/
+ (NSString*) typeClassName:(XAIObjectType)type; /*对应的类名*/
+ (NSString*) typeImageOpenName:(XAIObjectType)type;

@end
