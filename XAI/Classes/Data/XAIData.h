//
//  XAIData.h
//  XAI
//
//  Created by office on 14-4-28.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XAIUser.h"

/*读写协议*/
@protocol XAIDataInfo_DIC  <NSObject>

- (void) readFromDIC:(NSDictionary*)dic;
- (NSDictionary*) writeToDIC;

@end


@protocol XAIDataInfo_ARY <NSObject>

- (void) readFromARY:(NSArray*)ary;
- (NSArray*) writeToARY;

@end



@class XAIObjectList;
@interface XAIData : NSObject{

    NSMutableArray*  _userList; //xaiuser list
    NSMutableArray*  _objList;  //xaiobject list
    XAIObjectList*  _localObjInfo;  //本地数据

}

- (void) setUserList:(NSArray*)users;
- (NSArray*) getUserList;


- (void) setObjList:(NSArray*)devs;
- (NSArray*) getObjList;


- (void) save;


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
- (void) addObject:(XAIObject*)obj;

- (XAIObject*) findLocalObjWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid;

@end






