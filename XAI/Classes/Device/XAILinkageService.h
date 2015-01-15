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

    
    NSMutableArray* _allLinkages;
    XAILinkage*  _getLinkage;
    
    NSMutableArray* _delIDs;
    NSMutableArray* _changeIDs;
    uint16_t curDelIDs;
    uint16_t curChangeIDs;

}


@property (weak,nonatomic) id<XAILinkageServiceDelegate> linkageServiceDelegate;


- (void)  addLinkageConds:(NSArray*)conds results:(NSArray*)results
                    status:(XAILinkageStatus)status name:(NSString*)name;

- (int) delLinkage:(XAILinkageNum)linkNum;
- (int) setLinkage:(XAILinkageNum)linkNum status:(XAILinkageStatus)linkageStatus;
- (void) findAllLinkages;
- (void) getLinkageDetail:(XAILinkage*)aLinkage;

@end



@protocol XAILinkageServiceDelegate <NSObject>

@optional

- (void) linkageService:(XAILinkageService*)service addStatusCode:(XAI_ERROR)errcode;
- (void) linkageService:(XAILinkageService*)service delStatusCode:(XAI_ERROR)errcode;
- (void) linkageService:(XAILinkageService*)service changeStatusStatusCode:(XAI_ERROR)errcode;

- (void) linkageService:(XAILinkageService*)service findedAllLinkage:(NSArray*)linkageAry
                errcode:(XAI_ERROR)errcode;

- (void) linkageService:(XAILinkageService *)service  getLinkageDetail:(XAILinkage*)linkage
             statusCode:(XAI_ERROR)errcode;


- (void) linkageService:(XAILinkageService*)service delStatusCode:(XAI_ERROR)errcode otherID:(int)otherID;
- (void) linkageService:(XAILinkageService*)service changeStatusStatusCode:(XAI_ERROR)errcode otherID:(int)otherID;

@end

typedef NS_ENUM(NSUInteger,_XAILinkageOpr){
    
    XAILinkageOpr_FindAll = __Dev_lastItem,
    XAILinkageOpr_GetDetail,
    XAILinkageOpr_Add,
    ___Linkage_lastItem,
};
