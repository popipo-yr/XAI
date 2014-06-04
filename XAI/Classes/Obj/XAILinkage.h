//
//  XAILinkage.h
//  XAI
//
//  Created by office on 14-6-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAILinkageUseInfo.h"

typedef uint8_t XAILinkageNum;


@interface XAILinkage : NSObject{

    XAILinkageNum _num;
    XAILinkageUseInfo* _effeInfo;
    NSArray*  _condInfos;
}


@property (nonatomic,assign) XAILinkageNum num;
@property (nonatomic,strong) XAILinkageUseInfo* effeInfo;
@property (nonatomic,strong) NSArray* condInfos;

@end


typedef enum : uint8_t{
    
    XAILinkageStatus_DisActive = 1,
    XAILinkageStatus_Active = 2,
    XAILinkageStatus_UNKown = 3
    
}XAILinkageStatus;