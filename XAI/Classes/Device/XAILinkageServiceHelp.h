//
//  LinkageServiceHelp.h
//  XAI
//
//  Created by office on 14-6-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageService.h"

@protocol XAILinkageServiceHelpDelegate;
@interface XAILinkageServiceHelp : NSObject <XAILinkageServiceDelegate>{

    XAILinkageService* _linkageService;
    
    NSArray* _allLinkages;
    NSUInteger  _curIndex;

    XAIDevice* _curDev;
    BOOL _isIn;
    
    
    
}


@property (weak,nonatomic) id<XAILinkageServiceHelpDelegate> delegate;

- (void) purgeHasDev:(XAIDevice*)aDev;

@end



@protocol XAILinkageServiceHelpDelegate <NSObject>

@optional

- (void) linkageServiceHelp:(XAILinkageServiceHelp*)service
                   purgeDev:(XAIDevice*)aDev
                      beHas:(BOOL)bHas
                        err:(XAI_ERROR)errcode;


@end

