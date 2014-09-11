//
//  XAIUser.h
//  XAI
//
//  Created by office on 14-4-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XAIMQTTDEF.h"
#import "XAIStatus.h"

#import "XAIRWProtocol.h"


@interface XAIMeg : NSObject <XAIDataInfo_DIC>

@property (nonatomic,strong) NSString* context;
@property (nonatomic,strong) NSDate*  date;
@property (nonatomic,assign) XAITYPELUID fromLuid;
@property (nonatomic,assign) XAITYPELUID  toLuid;
@property (nonatomic,assign) XAITYPEAPSN fromAPSN;
@property (nonatomic,assign) XAITYPEAPSN toAPSN;

@end

@interface XAIUser : XAIStatus{
    
    XAITYPELUID _luid;
    XAITYPEAPSN _apsn;
    NSString* _name;
    NSString* _pawd;
    

    
}



@property (nonatomic, assign) XAITYPELUID luid;
@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* pawd;
@property (nonatomic, assign) BOOL isOnline;

+ (NSArray*) readIM:(XAITYPELUID)meluid apsn:(XAITYPEAPSN)meapsn
           withLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn;
+ (BOOL) saveIM:(NSArray*)ary meLuid:(XAITYPELUID)meluid apsn:(XAITYPEAPSN)meapsn
       withLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn;


- (BOOL) isAdmin;

- (void) getStatus;

+ (void) readIMEnd:(XAITYPELUID)meluid apsn:(XAITYPEAPSN)meapsn
           withLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn;

+ (int) countOfAllNotReadIMCount;
+ (int) countOfOneNotReadIMCount:(XAITYPELUID)meluid apsn:(XAITYPEAPSN)meapsn
                        withLuid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn;

@end
