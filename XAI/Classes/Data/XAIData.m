//
//  XAIData.m
//  XAI
//
//  Created by office on 14-4-28.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIData.h"

#import "XAIObject.h"
#import "XAIDevice.h"

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
        
        
        XAIObject*  aObj = [[NSClassFromString([XAIObject typeClassName:aDev.type]) alloc] init];
        if (aObj == nil) continue;
        
        [aObj setDevInfo:aDev];
        
        /*本地数据*/
        
        XAIObject* aLocalObj = [_localObjInfo findLocalObjWithApsn:aObj.apsn Luid:aObj.luid];
        
        if (aLocalObj != nil) {
            
            
            aObj.nickName = aLocalObj.nickName;
            aObj.lastOpr = aLocalObj.lastOpr;
            
        }else{
        
        
            aObj.nickName = aObj.name;
        }
        

        
        [objs addObject:aObj];
    }
    
    [_objList  setArray:objs];
    
}
- (NSArray*) getObjList{


    return [NSArray arrayWithArray:_objList];
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
    }
    
    return self;
}


@end


@implementation XAIObjectList

#define _key_file_path @"xai.plist"
- (BOOL)readObjects{

    BOOL isSuccess = false;
    
    do {
        
        NSMutableArray* objList = [[NSMutableArray alloc] init];
        
        NSString* localFile = [XAIData getSavePathFile:_key_file_path];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSArray* oprAry = [[NSArray alloc] initWithContentsOfFile:localFile];
        
        if (oprAry == nil || [oprAry count] == 0) break;
        
        
        for (int i =0; i < [oprAry count]; i++) {
            
            NSDictionary* dic = [oprAry objectAtIndex:i];
            
            /*也可以通过类名获取*/
            XAIObject* obj = [[XAIObject alloc] init];
            [obj readFromDIC:dic];
            
            [objList addObject:obj];
        }
        
        isSuccess = true;
        
        [_objs setArray:objList];
        
    } while (0);
    
    
    return isSuccess;


}

- (NSArray *)getObjects{


    return _objs;
}

- (void) addObject:(XAIObject*)obj{

    [_objs addObject:obj];
}

- (XAIObject*) findLocalObjWithApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid{

    for (int i = 0; i < [_objs count]; i++) {
        
        XAIObject* obj = [_objs objectAtIndex:i];
        
        if (obj.apsn == apsn && obj.luid == luid) {
            
            return obj;
        }
    }
    
    return nil;
    
}

-(id)init{

    if (self = [super init]) {
        
        _objs = [[NSMutableArray alloc] init];
    }
    
    return self;

}



@end
