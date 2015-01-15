//
//  XAILinkage.h
//  XAI
//
//  Created by office on 14-6-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAILinkageUseInfo.h"
#import "XAIStatus.h"

typedef uint8_t XAILinkageNum;

typedef enum : uint8_t{
    
    XAILinkageStatus_DisActive = 1,
    XAILinkageStatus_Active = 2,
    XAILinkageStatus_Del = 3,
    XAILinkageStatus_UNKown = 9
    
}XAILinkageStatus;


@interface XAILinkage : XAIStatus{

    XAILinkageNum _num;
    XAILinkageStatus _status;
    NSString* _name;
    
}


@property (nonatomic,assign) XAILinkageNum num;
@property (nonatomic,assign) XAILinkageStatus status;
@property (nonatomic,strong) NSString* name;


@property (nonatomic,strong) NSMutableArray* resultInfos;
@property (nonatomic,strong) NSMutableArray* condInfos;


//- (void) getDetailInfo;

@end


