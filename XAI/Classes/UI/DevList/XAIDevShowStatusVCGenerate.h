//
//  XAIDevShowStatusVCGenerate.h
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XAIDevShowStatusVC.h"
#import "XAILightStatusVC.h"
#import "XAIDoorStatusVC.h"
#import "XAIWindowStatusVC.h"

@interface XAIDevShowStatusVCGenerate : NSObject


+ (XAIDevShowStatusVC*) statusWithObject:(XAIObject*) aObj storyboard:(UIStoryboard*)storyboard;

@end
