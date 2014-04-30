//
//  XAIObject.m
//  XAI
//
//  Created by office on 14-4-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObject.h"
#import "XAIDevice.h"

#import "XAIData.h"

#define _Key_NickName_ @"NickName"
#define _Key_OprTime_ @"OprTime"
#define _Key_OprName_ @"OprName"
#define _Key_OprID_ @"OprOrder"

@implementation XAIObject

- (id) init{

    if (self = [super init]) {
        
        _objOprList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id) initWithDevice:(XAIDevice*)dev{

    if (self = [super init]) {
        
        _objOprList = [[NSMutableArray alloc] init];

        [self setDevInfo:dev];
    }
    
    return self;
}

- (void) startControl{}

- (void) setDevInfo:(XAIDevice*)dev{

    _apsn = dev.apsn;
    _luid = dev.luid;
    _model = dev.model;
    _vender = dev.vender;
    _type = dev.type;
    
    _name = dev.name;
}

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

+ (NSArray*)  typeCanUse{

   __autoreleasing NSArray* types = @[[NSNumber numberWithInt:XAIObjectType_door],
                       [NSNumber numberWithInt:XAIObjectType_light]];
    
    return types;
}

+ (NSString*) typeOprClassName:(XAIObjectType)type{

    NSString* className = nil;
    
    switch (type) {
        case XAIObjectType_door:{
            
           // className = @"XAILightOpr";
        }
            break;
        case XAIObjectType_light:{
            
            className = @"XAILightOpr";
            
        } break;
            
        default:
            break;
    }
    

    return className;

}

+ (NSString*) typeClassName:(XAIObjectType)type{

    NSString* className = nil;
    
    switch (type) {
        case XAIObjectType_door:{
            
            // className = @"XAILight";
        }
            break;
        case XAIObjectType_light:{
            
            className = @"XAILight";
            
        } break;
            
        default:
            break;
    }
    
    
    return className;


}


-(NSDictionary *)writeToDIC{

    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (_nickName != nil) {
        
        [dic setObject:_nickName forKey:_Key_NickName_];
    }
    
    if (_lastOpr.name != nil && _lastOpr.time != nil) {
        
        [dic setObject:[NSNumber numberWithInt:_lastOpr.opr] forKey:_Key_OprID_];
        [dic setObject:_lastOpr.time forKey:_Key_OprTime_];
        [dic setObject:_lastOpr.name forKey:_Key_OprName_];
    }
    
    return dic;
    
}

- (void)readFromDIC:(NSDictionary *)dic{

    _nickName = [dic objectForKey:_Key_NickName_];

    _lastOpr.opr = [[dic objectForKey:_Key_OprID_] intValue];
    _lastOpr.time = [dic objectForKey:_Key_OprTime_];
    _lastOpr.name = [dic objectForKey:_Key_OprName_];
}

/*获取操作记录集,读取本地的信息*/
- (BOOL) readOprList{

    BOOL isSuccess = false;
    
    do {
        
        NSMutableArray* oprList = [[NSMutableArray alloc] init];
        
        NSString* localFile = [XAIData getSavePathFile:
                               [NSString stringWithFormat:@"%u-%llu.plist",_apsn,_luid]];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSArray* oprAry = [[NSArray alloc] initWithContentsOfFile:localFile];
        
        if (oprAry == nil || [oprAry count] == 0) break;
        
        
        for (int i =0; i < [oprAry count]; i++) {
            
            NSDictionary* dic = [oprAry objectAtIndex:i];
            
            /*也可以通过类名获取*/
            XAIObjectOpr* aOpr = [_lastOpr copy];
            [aOpr readFromDIC:dic];
            
            [oprList addObject:aOpr];
        }
        
        isSuccess = true;
        
        [_objOprList setArray:oprList];
        
    } while (0);
    
    
    return isSuccess;
    
}

/*添加一个操作记录 更新最后一次操作和操作列表*/
- (BOOL) addOpr:(XAIObjectOpr*)aOpr{

    if ([aOpr class] != [_lastOpr class]) {
       
        return false;
    }
    
    [_objOprList addObject:aOpr];
    
    return true;
}

- (NSArray *)getOprList{


    return _objOprList;
}


@end

@implementation XAIObjectOpr


-(NSDictionary *)writeToDIC{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:_opr] forKey:_Key_OprID_];
    [dic setObject:_time forKey:_Key_OprTime_];
    [dic setObject:_name forKey:_Key_OprName_];
    
    return dic;
    
}

- (void)readFromDIC:(NSDictionary *)dic{
    
    _opr = [[dic objectForKey:_Key_OprID_] intValue];
    _time = [dic objectForKey:_Key_OprTime_];
    _name = [dic objectForKey:_Key_OprName_];
    
}

- (NSString*) timeStr{
    
    
    NSString* format = @"HH:MM  YYYY-MM-DD";
    return [_time descriptionWithLocale:format];

}

- (NSString*) oprWithNameStr{

    return [NSString stringWithFormat:@"%@%@",_name,[self oprOnlyStr]];

}

- (NSString*) allStr{

    NSString* format = @"HH:MM";

    return [NSString stringWithFormat:@"%@%@ %@",_name,[self oprOnlyStr],[_time descriptionWithLocale:format]];
}

- (NSString*) oprOnlyStr{

    return nil;
}
@end

