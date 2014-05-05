//
//  XAIData.m
//  XAI
//
//  Created by office on 14-4-28.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIData.h"

#import "XAIObjectGenerate.h"
#import "XAIDevice.h"

#import "XAIPacket.h"
#import "XAIUserService.h"
#import "XAIDeviceService.h"

@implementation XAIData


static XAIData*  _s_XAIData_ = NULL;


- (void) setUserList:(NSArray*)users{

    [_userList setArray:users];
}
- (NSArray*) getUserList{
    
    return [NSArray arrayWithArray:_userList];


}


- (void) setObjList:(NSArray*)devs{
    
    NSMutableArray* objs = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [devs count]; i++) {
        
        /*服务器上的数据*/
        XAIDevice*  aDev = [devs objectAtIndex:i];
        
        if (![aDev isKindOfClass:[XAIDevice class]]) continue;
        
        
        XAIObject*  aObj = [[NSClassFromString([XAIObjectGenerate typeClassName:aDev.type]) alloc] init];
        if (aObj == nil) continue;
        
        [aObj setInfoFromDevice:aDev];
        
        /*本地数据*/
        
        XAIObject* aLocalObj = [_localObjInfo findLocalObjWithApsn:aObj.apsn Luid:aObj.luid type:aObj.type];
        
        if (aLocalObj != nil) {
            
            
            aObj.nickName = aLocalObj.nickName;
            aObj.lastOpr = aLocalObj.lastOpr;
            
        }else{
        
        
            aObj.nickName = aObj.name;
            [_localObjInfo addObjectInfo:aObj];
        }
        

        
        [objs addObject:aObj];
    }
    
    [_objList  setArray:objs];
    
}
- (NSArray*) getObjList{


    return [NSArray arrayWithArray:_objList];
}

- (void) upDataObj:(XAIObject*)obj{

    [_localObjInfo addObjectInfo:obj];
    [_localObjInfo save];
}

- (void) save{

    [_localObjInfo save];
}

+ (XAIData*) shareData{
    
    if (NULL == _s_XAIData_) {
        
        _s_XAIData_ = [[XAIData alloc] init];

    }
    
    return _s_XAIData_;
    
}

+ (NSString *)getDirectoryOfDocumentFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); // 获取所有Document文件夹路径
    NSString *documentsPath = paths[0]; // 搜索目标文件所在Document文件夹的路径，通常为第一个
    
    if (!documentsPath) {
        NSLog(@"Documents目录不存在");
    }
    
    return documentsPath;
}

+ (NSString*) getSavePathFile:(NSString *)fileName{

    
    if ([fileName isEqualToString:@""]) {
        return nil;
    }
    
    NSString *documentsPath = [self getDirectoryOfDocumentFolder];
    if (documentsPath) {
        return [documentsPath stringByAppendingPathComponent:fileName]; // 获取用于存取的目标文件的完整路径
    }
    
    return nil;

}

-(id)init{

    if (self = [super init]) {
        
        _userList = [[NSMutableArray alloc] init];
        _objList = [[NSMutableArray alloc] init];
        _localObjInfo = [[XAIObjectList alloc] init];
        
        _refreshDelegates = [[NSMutableArray alloc] init];
        _userService = [[XAIUserService alloc] init];
        _userService.userServiceDelegate = self;
        
        _devService = [[XAIDeviceService alloc] init];
        _devService.deviceServiceDelegate = self;
    }
    
    return self;
}

- (void) addRefreshDelegate:(id<XAIDataRefreshDelegate>)delegate{

    [_refreshDelegates addObject:delegate];
}
- (void) removeRefreshDelegate:(id<XAIDataRefreshDelegate>)delegate{

    [_refreshDelegates removeObject:delegate];
}

- (void)callBack{

    for (int i = 0 ; i < [_refreshDelegates count]; i++) {
    
        id<XAIDataRefreshDelegate> aDeg = [_refreshDelegates objectAtIndex:i];
        
        if ([aDeg conformsToProtocol:@protocol(XAIDataRefreshDelegate)]
            && [aDeg respondsToSelector:@selector(xaiDataRefresh:)]) {
            
            [aDeg xaiDataRefresh:self];
        }
        
    }
}

- (void) startRefresh{
    
    MQTT* curMQTT = [MQTT shareMQTT];

    NSString* uTopic =[MQTTCover serverStatusTopicWithAPNS:curMQTT.apsn
                                                      luid:MQTTCover_LUID_Server_03
                                                     other:MQTTCover_UserTable_Other];
    
    NSString* dTopic =[MQTTCover serverStatusTopicWithAPNS:curMQTT.apsn
                                                      luid:MQTTCover_LUID_Server_03
                                                     other:MQTTCover_DevTable_Other];
    
    [curMQTT.packetManager addPacketManager:self withKey:uTopic];
    [curMQTT.packetManager addPacketManager:self withKey:dTopic];
}


-(void)recivePacket:(void *)datas size:(int)size topic:(NSString *)topic{
    
    MQTT* curMQTT = [MQTT shareMQTT];
    
    NSString* uTopic =[MQTTCover serverStatusTopicWithAPNS:curMQTT.apsn
                                                      luid:MQTTCover_LUID_Server_03
                                                     other:MQTTCover_UserTable_Other];
    
    NSString* dTopic =[MQTTCover serverStatusTopicWithAPNS:curMQTT.apsn
                                                      luid:MQTTCover_LUID_Server_03
                                                     other:MQTTCover_DevTable_Other];
    
    if (topic != nil && [topic isEqualToString:uTopic]) {
        
        [_userService recivePacket:datas size:size topic:topic];
        
    }else if(topic != nil && [topic isEqualToString:dTopic]){
    
        [_devService _setFindOnline];
        [_devService recivePacket:datas size:size topic:topic];
    
    }

    
}

-(void)userService:(XAIUserService *)userService findedAllUser:(NSSet *)users status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (isSuccess) {
        
        [self setUserList:[users allObjects]];
        [self callBack];
        
    }

}

- (void) devService:(XAIDeviceService *)devService finddedAllOnlineDevices:(NSSet *)devs status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (isSuccess) {
        
        [self setObjList:[devs allObjects]];
        [self callBack];
    }
}



@end


@implementation XAIObjectList

- (void) readFromARY:(NSArray*)ary{
    
     NSMutableArray* objList = [[NSMutableArray alloc] init];
    
    for (int i =0; i < [ary count]; i++) {
        
        NSDictionary* dic = [ary objectAtIndex:i];
        
        /*也可以通过类名获取*/
        XAIObject* obj = [[XAIObject alloc] init];
        [obj readFromDIC:dic];
        
        [objList addObject:obj];
    }
    
    [_objs setArray:objList];

    
}
- (NSArray*) writeToARY{
    
  __autoreleasing  NSMutableArray* objList = [[NSMutableArray alloc] init];
    
    for (int i =0; i < [_objs count]; i++) {
        
        XAIObject* obj = [_objs objectAtIndex:i];
        
        NSDictionary* info =  [obj writeToDIC];
        
        [objList addObject:info];
    }

    return objList;
}

#define _key_file_path @"xai.plist"
- (BOOL)readObjects{

    BOOL isSuccess = false;
    
    do {
        
        NSString* localFile = [XAIData getSavePathFile:_key_file_path];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSArray* oprAry = [[NSArray alloc] initWithContentsOfFile:localFile];
        
        if (oprAry == nil || [oprAry count] == 0) break;
        
        
        [self readFromARY:oprAry];
        
        isSuccess = true;
        
    } while (0);
    
    
    return isSuccess;


}

- (void) save{

    do {
        
        NSString* localFile = [XAIData getSavePathFile:_key_file_path];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        
        NSArray* infoAry = [self writeToARY];
        
        if (infoAry == nil) break;
        
        [infoAry writeToFile:localFile atomically:YES];
        
    } while (0);


}

- (NSArray *)getObjects{


    return _objs;
}

- (void) addObjectInfo:(XAIObject*)obj{
    
    XAIObject* localobj = [self findLocalObjWithApsn:obj.apsn Luid:obj.luid type:obj.type];
    
    if (localobj != nil) {
        
        localobj.lastOpr = obj.lastOpr;
        
    }else{

        [_objs addObject:obj];
    }
}

- (XAIObject*) findLocalObjWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid type:(XAIObjectType)type{

    for (int i = 0; i < [_objs count]; i++) {
        
        XAIObject* obj = [_objs objectAtIndex:i];
        
        if (obj.apsn == apsn && obj.luid == luid && type == obj.type) {
            
            return obj;
        }
    }
    
    return nil;
    
}

-(id)init{

    if (self = [super init]) {
        
        _objs = [[NSMutableArray alloc] init];
        
        [self readObjects];
    }
    
    return self;

}



@end
