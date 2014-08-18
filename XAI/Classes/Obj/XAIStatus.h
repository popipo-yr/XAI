//
//  XAIStatus.h
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum{
    
    XAIObjectOprStatus_start,
    XAIObjectOprStatus_none,
    XAIObjectOprStatus_showMsg,
    
}XAIObjectOprStatus;

@interface XAIStatus : NSObject{
    
    XAIObjectOprStatus  _curOprStatus;
}

- (void) startOpr;
- (void) showMsg;
- (void) endOpr;


@property (nonatomic, readonly) XAIObjectOprStatus  curOprStatus;
@property (nonatomic, strong) NSString* curOprtip;



@end
