//
//  XAIUser.h
//  XAI
//
//  Created by office on 14-4-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XAIMQTTDEF.h"

@interface XAIUser : NSObject{
    
    XAITYPELUID _luid;
    XAITYPEAPSN _apsn;
    NSString* _name;
}

@property (nonatomic, assign) XAITYPELUID luid;
@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* pawd;


@end
