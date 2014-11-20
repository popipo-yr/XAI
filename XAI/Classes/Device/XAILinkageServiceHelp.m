//
//  LinkageServiceHelp.m
//  XAI
//
//  Created by office on 14-6-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageServiceHelp.h"


@implementation XAILinkageServiceHelp



-(id)init{

    if (self = [super init]) {
        
        
        _allLinkages = [[NSArray alloc] init];
        
        _linkageService = [[XAILinkageService alloc] init];
        _linkageService.apsn = [MQTT shareMQTT].apsn;
        _linkageService.luid = MQTTCover_LUID_Server_03;
        _linkageService.linkageServiceDelegate = self;

    }
    
    return self;
}

-(void)dealloc{

    [_linkageService willRemove];
    _linkageService.linkageServiceDelegate = nil;
}

-(void)findAllLinkages{
    [_linkageService findAllLinkages];
}

-(void) findOneByOne{

    if (_curIndex < [_allLinkages count]) {
        
        XAILinkage* aLinkage = [_allLinkages objectAtIndex:_curIndex];
        [_linkageService getLinkageDetail:aLinkage];

        
    }else{
        
        [self outWithErr:XAI_ERROR_NONE];
    }
    
}


-(void)linkageService:(XAILinkageService *)service findedAllLinkage:(NSArray *)linkageAry errcode:(XAI_ERROR)errcode{
    

    
    if (errcode == XAI_ERROR_NONE) {
       
        _allLinkages = [[NSArray alloc] initWithArray:linkageAry];
        _curIndex = 0;
        [self findOneByOne];
        //查找详情
        
    }else{
    
        [self outWithErr:errcode];
    }
}


-(void)linkageService:(XAILinkageService *)service getLinkageDetail:(XAILinkage *)linkage statusCode:(XAI_ERROR)errcode{
    
    
    if (errcode == XAI_ERROR_NONE) {
        
        NSMutableArray* useInfos = [[NSMutableArray alloc] initWithArray:linkage.condInfos];
        [useInfos addObject:linkage.effeInfo];
        
        for (XAILinkageUseInfo* info in useInfos) {
            if (info.dev_apsn == _curDev.apsn && info.dev_luid == _curDev.luid) {
                _isIn = true;
                [self outWithErr:errcode];
                break;
            }
        }
    }
    
    _curIndex += 1;
    if (_isIn == false) {
        [self findOneByOne];
    }
    
    
}


- (void) purgeHasDev:(XAIDevice*)aDev{
    
    if (_curDev != nil) return;

    _curDev = aDev;
    _isIn = false;
    [self findAllLinkages];
}


-(void) outWithErr:(XAI_ERROR)err{

    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(linkageServiceHelp:purgeDev:beHas:err:)]) {
        [_delegate linkageServiceHelp:self purgeDev:_curDev beHas:_isIn err:err];
        
    }

    _curDev = nil;
}


@end
