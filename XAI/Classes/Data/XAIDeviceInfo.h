//
//  XAIDeviceInfo.h
//  XAI
//
//  Created by touchhy on 14-4-2.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//


@interface XAIDeviceInfo : NSObject

@property (copy)  NSString* name;
@property (assign) int  groID;
@property  (assign) int opeID; //操作数据的id

@end



@interface XAIDeviceOperation : NSObject

@property  (assign) int theID;
@property (copy) NSString*  userName;
@property (strong) NSTimer*  time;
@property (copy) NSString*  operations; //should be enum

@end
