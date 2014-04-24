//
//  XAIObject.h
//  XAI
//
//  Created by office on 14-4-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"

typedef enum XAIObjectType{
    
    XAIObjectType_door = 0,
    XAIObjectType_light = 1,
    
    
}XAIObjectType;

typedef int  XAIGOURPID;


@interface XAIObject : NSObject{
    
    NSString* _name;
    XAIObjectType _type; /*类别,门，窗，灯?*/
    XAIGOURPID _groupId; /*分组使用*/
    XAITYPEAPSN _apsn;
    XAITYPELUID _luid;
    NSString* _lastOpr; /*最后一次操作*/
    
}

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) XAIObjectType type; /*类别,门，窗，灯?*/
@property (nonatomic, assign) XAIGOURPID groupId; /*分组使用*/
@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, assign) XAITYPELUID luid;
@property (nonatomic, strong) NSString* lastOpr; /*最后一次操作*/

- (void) initDev; /*初始化设备*/

+ (NSString*) typeImageName:(XAIObjectType)type; /*类型对应的图片*/

@end


@interface XAIObjectOpr : NSObject

@property (nonatomic, strong) NSString* opr;
@property (nonatomic, strong) NSString* time;

@end


#define XAIGOURPID_DEFAULT 0

@interface XAIObjectGroup  :  NSObject{

    XAIGOURPID _curid;
    NSMutableArray*  _members;
    
}

@property (nonatomic, assign) XAIGOURPID curid;
@property (nonatomic, strong) NSArray*  members;

- (BOOL) hasMember:(NSString*) aMember;
- (BOOL) addMember:(NSString*) aMember;
- (BOOL) delMember:(NSString*) aMember;
- (int) memberCount;


@end

/*分组信息,所有的分组*/
@interface XAIObjectGroupManager : NSObject{

    /*
     {
     1 : [guid,guid...]
     2 : [guid,guid...]
     }
     */
    
    NSMutableDictionary* _obj_group_map; /*实物对应分组表,会储存到本地*/
    NSMutableDictionary* _group_map;  /*分组对应实物表*/
    
    XAIGOURPID _lastusedID; /*最后使用的id, 用于生产新的设备分组id,第一次使用将是默认值 */


}


+ (XAIObjectGroupManager*) shareManager;

- (void) save; /*保存信息*/
- (void) getGroupNameWithGroupId:(XAIGOURPID) ID;
- (XAIGOURPID) generateNewGroup; /*创建一个新的组,返回组的id*/
- (BOOL) delGroup:(XAIGOURPID) ID; /*删除组，如果组下有数据不能删除*/
- (XAIGOURPID) getGroupObjectIn:(NSString*)obj_guid;

@end
