//
//  XAIData.h
//  XAI
//
//  Created by office on 14-4-28.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XAIUser.h"
#import "XAIUserService.h"
#import "XAIDeviceService.h"
#import "XAIRWProtocol.h"




@class XAIData;
@protocol XAIDataRefreshDelegate <NSObject>

- (void)xaiDataRefresh:(XAIData*)data;

@end



@class XAIObjectList;
@interface XAIData : NSObject
<MQTTPacketManagerDelegate,XAIUserServiceDelegate,XAIDeviceServiceDelegate>{

    NSMutableArray*  _userList; //xaiuser list
    NSMutableArray*  _objList;  //xaiobject list
    XAIObjectList*  _localObjInfo;  //本地数据

    
    NSMutableArray* _refreshDelegates;
    XAIUserService* _userService;
    XAIDeviceService* _devService;
    
}

- (void) addRefreshDelegate:(id<XAIDataRefreshDelegate>)delegate;
- (void) removeRefreshDelegate:(id<XAIDataRefreshDelegate>)delegate;

- (void) setUserList:(NSArray*)users;
- (NSArray*) getUserList;


- (void) setObjList:(NSArray*)devs;
- (NSArray*) getObjList;

- (void) upDataObj:(XAIObject*)obj;

- (void) save;

- (void) startRefresh;


+ (XAIData*) shareData;

+ (NSString*) getSavePathFile:(NSString*)fileName;

@end



@class XAIObject;

@interface XAIObjectList : NSObject <XAIDataInfo_ARY>{
    
    NSMutableArray* _objs;
    
}

//- (void) addObject:(XAIObject*)aObj;
- (BOOL) readObjects;
- (void) save;


- (NSArray*) getObjects;
- (void) addObjectInfo:(XAIObject*)obj;

- (XAIObject*) findLocalObjWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid type:(XAIObjectType)type;

@end






