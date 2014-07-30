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

#import "XAIObjectGenerate.h"

#define _Key_NickName_ @"NickName"
#define _Key_APSN_ @"apsn"
#define _Key_LUID_ @"luid"
#define _Key_Type_ @"type"

//#define _Key_Flag_ @"flag"

@implementation XAIObject

- (id) init{

    if (self = [super init]) {
        
        _objOprList = [[NSMutableArray alloc] init];
        
        _lastOpr = [[XAIObjectOpr alloc] init];
        
        _tmpOprs = [[NSMutableArray alloc] init];
        
        //_flag = XAIObjectFlagNormal;
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    XAIObject* obj = [[XAIObject allocWithZone:zone]init];
    obj.apsn = _apsn;
    obj.luid = _luid;
    obj.name = _name;
    obj.vender = _vender; /*生产商*/
    obj.model = _model; /*型号*/
    obj.type = _type;
    
    return obj;
    
}

- (id) initWithDevice:(XAIDevice*)dev{

    if (self = [super init]) {
        
        _objOprList = [[NSMutableArray alloc] init];
        
        _lastOpr = [[XAIObjectOpr alloc] init];
        
        //_flag = XAIObjectFlagNormal;

        [self setInfoFromDevice:dev];
    }
    
    return self;
}

- (void) startControl{}
- (void) endControl{}

- (void) setInfoFromDevice:(XAIDevice*)dev{

    _apsn = dev.apsn;
    _luid = dev.luid;
    _model = dev.model;
    _vender = dev.vender;
    _type = dev.corObjType;
    
    _name = dev.name;
    
    if (dev.devStatus == XAIDeviceStatus_UNKOWN || dev.devStatus == XAIDeviceStatus_OFFLINE) {
        _isOnline = false;
    }else{
        _isOnline = true;
    }
    


}


-(NSDictionary *)writeToDIC{

    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (_nickName != nil) {
        
        [dic setObject:_nickName forKey:_Key_NickName_];
    }
    
    [dic setObject:[NSNumber numberWithLong:_apsn] forKey:_Key_APSN_];
    [dic setObject:[NSNumber numberWithLongLong:_luid] forKey:_Key_LUID_];
    [dic setObject:[NSNumber numberWithInt:_type] forKey:_Key_Type_];
    //[dic setObject:[NSNumber numberWithInt:_flag] forKey:_Key_Flag_];
    
    if (_lastOpr.name != nil && _lastOpr.time != nil) {
        
        [dic setObject:[NSNumber numberWithInt:_lastOpr.opr] forKey:_Key_OprID_];
        [dic setObject:_lastOpr.time forKey:_Key_OprTime_];
        [dic setObject:_lastOpr.name forKey:_Key_OprName_];
        [dic setObject:[NSNumber numberWithInteger:_lastOpr.otherID] forKey:_Key_OprOtherID_];
    }
    
    return dic;
    
}

- (void)readFromDIC:(NSDictionary *)dic{

    _nickName = [dic objectForKey:_Key_NickName_];
    
    _apsn = [[dic objectForKey:_Key_APSN_] longValue];
    _luid = [[dic objectForKey:_Key_LUID_] longLongValue];
    _type = [[dic objectForKey:_Key_Type_] intValue];
    //_flag = [[dic objectForKey:_Key_Flag_] intValue];
    
    /*必须根据类型创建数据*/
    _lastOpr = [[NSClassFromString([XAIObjectGenerate typeOprClassName:_type])  alloc] init];
    
    _lastOpr.opr = [[dic objectForKey:_Key_OprID_] intValue];
    _lastOpr.time = [dic objectForKey:_Key_OprTime_];
    _lastOpr.name = [dic objectForKey:_Key_OprName_];
    _lastOpr.otherID = [[dic objectForKey:_Key_OprOtherID_] intValue];
}

/*获取操作记录集,读取本地的信息*/
- (BOOL) readOprList{

    BOOL isSuccess = false;
    
    do {
        
        NSMutableArray* oprList = [[NSMutableArray alloc] init];
        
        NSString* localFile = [XAIData getSavePathFile:
                               [NSString stringWithFormat:@"%u-%llu-%d.plist",_apsn,_luid,_type]];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSArray* oprAry = [[NSArray alloc] initWithContentsOfFile:localFile];
        
        if (oprAry == nil || [oprAry count] == 0) break;
        
        
        for (int i =0; i < [oprAry count]; i++) {
            
            NSDictionary* dic = [oprAry objectAtIndex:i];
            
            /*也可以通过类名获取*/
            XAIObjectOpr* aOpr = [[NSClassFromString([XAIObjectGenerate typeOprClassName:_type]) alloc] init];
            [aOpr readFromDIC:dic];
            
            [oprList addObject:aOpr];
        }
        
        isSuccess = true;
        
        [_objOprList setArray:oprList];
        
    } while (0);
    
    
    return isSuccess;
    
}


/*获取操作记录集,写入文件*/
- (BOOL) writeOprList{
    
    BOOL isSuccess = false;
    
    do {
        
        NSString* localFile = [XAIData getSavePathFile:
                               [NSString stringWithFormat:@"%u-%llu-%d.plist",_apsn,_luid,_type]];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSMutableArray* oprAry = [[NSMutableArray alloc] init];
        
        
        for (int i =0; i < [_objOprList count]; i++) {
            
            XAIObjectOpr* aOpr = [_objOprList objectAtIndex:i];
            
            if (aOpr == nil && ![aOpr isKindOfClass:[XAIObjectOpr class]]) continue;
            
            
            NSDictionary* dic = [aOpr writeToDIC];
            
            [oprAry addObject:dic];
        }
        
        
        [oprAry writeToFile:localFile atomically:YES];
        
    } while (0);
    
    
    return isSuccess;
    
}


/*添加一个操作记录 更新最后一次操作和操作列表*/
- (BOOL) addOpr:(XAIObjectOpr*)aOpr{

    if (![aOpr isKindOfClass:[_lastOpr class]]) {
       
        return false;
    }
    
    /*与最后一次记录一样,不储存*/
    XAIObjectOpr* saveLast = [_objOprList lastObject];
    if (saveLast != nil && saveLast.otherID == aOpr.otherID && saveLast.opr == aOpr.opr) {
        return false;
    }
    
    _lastOpr = aOpr;
    
    [_objOprList addObject:aOpr];
    [[XAIData shareData] upDateObj:self];
    [self writeOprList];
    
    
    return true;
}

- (NSArray *)getOprList{


    return _objOprList;
}


- (NSArray*) getLinkageUseInfos{

    return NULL;
}


- (void) updateFinish:(XAIObjectOpr*)opr{}

- (void) timeout{
    
    NSArray* newAry = [XAIObjectOpr sort:_tmpOprs];
    [_tmpOprs removeAllObjects];
    
    XAIObjectOpr* last = [newAry lastObject];
    
    //写入状态
    for (XAIObjectOpr* opr in newAry) {
        [self addOpr:opr];
    }
    
    
    //如果需要通知结果
    if (last != nil) {
        [self updateFinish:last];
    }
    
}



@end

