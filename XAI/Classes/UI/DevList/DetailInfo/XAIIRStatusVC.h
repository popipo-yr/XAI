//
//  XAIIRStatusVC.h
//  XAI
//
//  Created by office on 14-7-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevShowStatusVC.h"
#import "XAIIR.h"

@interface XAIIRStatusVC : XAIDevShowStatusVC <XAIIRDelegate>{

    XAIIR* _IR;
}

@property (nonatomic,strong) XAIIR* IR;

@end
