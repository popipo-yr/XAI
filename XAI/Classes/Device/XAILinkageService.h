//
//  LinkageService.h
//  XAI
//
//  Created by office on 14-6-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevice.h"
#import "XAILinkage.h"

@protocol XAILinkageServiceDelegate;
@interface XAILinkageService : XAIDevice <MQTTPacketManagerDelegate>{


}


@property (weak,nonatomic) id<XAILinkageServiceDelegate> linkageServiceDelegate;


- (void)  addLinkageParams:(NSArray*)params ctrlInfo:(XAILinkageUseInfoCtrl *)ctrlInfo
                    status:(XAILinkageStatus)status name:(NSString*)name;

- (void) delLinkage:(XAILinkageNum)linkNum;
- (void) setLinkage:(XAILinkageNum)linkNum status:(XAILinkageStatus)linkageStatus;
- (void) findAllLinkages;

@end



@protocol XAILinkageServiceDelegate <NSObject>

@optional

- (void) linkageService:(XAILinkageService*)service addStatusCode:(XAI_ERROR)errcode;
- (void) linkageService:(XAILinkageService*)service delStatusCode:(XAI_ERROR)errcode;
- (void) linkageService:(XAILinkageService*)service changeStatusStatusCode:(XAI_ERROR)errcode;

- (void) linkageService:(XAILinkageService*)service findedAllLinkage:(NSArray*)linkageAry
                errcode:(XAI_ERROR)errcode;

@end


