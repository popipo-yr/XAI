//
//  XAIObject.m
//  XAI
//
//  Created by office on 14-4-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObject.h"

@implementation XAIObject

- (void) initDev{};

+ (NSString*) typeImageName:(XAIObjectType)type{
    
   __autoreleasing NSString* imgNameStr = nil;
    
    switch (type) {
        case XAIObjectType_door:{
        
            imgNameStr = @"obj_door";
        }
            break;
        case XAIObjectType_light:{
        
            imgNameStr = @"obj_light";
        
        } break;
            
        default:
            break;
    }
    
    return imgNameStr;
}
@end

@implementation XAIObjectOpr

@end

@implementation XAIObjectGroup

- (id)initWithID:(XAIGOURPID)curId members:(NSArray*)members{

    if (self = [super init]) {
        
        _curid = curId;
        _members = [[NSMutableArray alloc] initWithArray:members];
    }
    
    return self;
}

- (BOOL) hasMember:(NSString*) aMember{

    for (int i = 0; i < [_members count]; i++) {
        
        NSString* in_aMember = [_members objectAtIndex:i];
        
        if ([in_aMember isKindOfClass:[NSString class]] && [in_aMember isEqualToString:aMember]) {
            
            return true;
            
        }
    }
    
    return false;
}
- (BOOL) addMember:(NSString*) aMember{
    
    [_members addObject:aMember];
    return true;

}
- (BOOL) delMember:(NSString*) aMember{
    
    [_members removeObject:aMember];
    return true;

}
- (int) memberCount{

    return [_members count];
}


@end

XAIObjectGroupManager* _staic_XAIObjectGroupManager = Nil;



@implementation XAIObjectGroupManager


- (void) getGroupNameWithGroupId:(XAIGOURPID) ID{

}
- (XAIGOURPID) generateNewGroup{

    _lastusedID += 1;
    
    XAIObjectGroup* aGroup = [[XAIObjectGroup alloc] initWithID:_lastusedID members:nil];
    
    [_group_map setObject:aGroup forKey:[NSNumber numberWithInt:_lastusedID]];
    
    return _lastusedID;
}

- (BOOL) delGroup:(XAIGOURPID) ID{
    
    NSNumber* key = [NSNumber numberWithInt:ID];

    XAIObjectGroup* aGroupj =  [_group_map objectForKey:key];
    if (nil != aGroupj && [aGroupj isKindOfClass:[XAIObjectGroup class]]
        && [aGroupj memberCount] > 0) {
        
        return false;
    }
    
    [_group_map removeObjectForKey:key];
    
    return true;
}

- (XAIGOURPID) getGroupObjectIn:(NSString*)obj_guid{
    

    [_obj_group_map objectForKey:obj_guid];
    
    return _lastusedID;

}

#define last_key @"last"
#define maps_key @"maps"
#define group_key @"group"

- (void) save{
    
    NSMutableDictionary* group = [[NSMutableDictionary alloc] init];
    
    NSArray* mapkeys = [_group_map allKeys];
    for (int i = 0;  i < [mapkeys count]; i++ ) {
        
        XAIObjectGroup* aGroupj = [group objectForKey:[mapkeys objectAtIndex:i]];

        if (nil != aGroupj && [aGroupj isKindOfClass:[XAIObjectGroup class]]){
            
               [group setObject:aGroupj.members forKey:[mapkeys objectAtIndex:i]];
        }
        
    }
    

    NSDictionary* dataDic =[[NSDictionary alloc] initWithObjectsAndKeys:
                            _obj_group_map,maps_key,[NSNumber numberWithInt:_lastusedID],last_key,
                            group,group_key,nil];
    
    [dataDic writeToFile:[self getPath] atomically:YES];

}

- (void) read{
    
    NSDictionary* dataDic =[[NSDictionary alloc] initWithContentsOfFile:[self getPath]];
    
    

    [_obj_group_map  setDictionary:[dataDic objectForKey:maps_key]];
    
    _lastusedID = [[dataDic objectForKey:last_key] intValue];
    
    NSDictionary* group = [dataDic objectForKey:group_key];
    
    NSArray* mapkeys = [_group_map allKeys];
    for (int i = 0;  i < [mapkeys count]; i++ ) {
        
       NSArray* members = [group objectForKey:[mapkeys objectAtIndex:i]];
        
        if (nil != members && [members isKindOfClass:[NSArray class]]){
            
            XAIObjectGroup* aGroup = [[XAIObjectGroup alloc] initWithID:[[mapkeys objectAtIndex:i] intValue]
                                                                members:members];
            
            [_group_map setObject:aGroup forKey:[mapkeys objectAtIndex:i]];

        }
        
    }


}

- (NSString*) getPath{


    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *filePath = [NSString  stringWithFormat:@"%@/data.plist",docDir];

    return filePath;
    
    // [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (id) init{

    if (self = [super init]) {
        
        _obj_group_map = [[NSMutableDictionary alloc] init];
        _group_map = [[NSMutableDictionary alloc] init];
        
        _lastusedID = XAIGOURPID_DEFAULT;
        
        [self read];
        
        if (_lastusedID == 0) {
            
            _lastusedID = XAIGOURPID_DEFAULT;
        }
    }
    
    return self;

}

+ (XAIObjectGroupManager*) shareManager{

    if (_staic_XAIObjectGroupManager == nil) {
        
        _staic_XAIObjectGroupManager = [[XAIObjectGroupManager alloc] init];
    }
    
    return _staic_XAIObjectGroupManager;

}

@end
