//
//  XAIObjOpr.m
//  XAI
//
//  Created by office on 14-7-28.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectOpr.h"

@implementation XAIObjectOpr

- (id)init{
    
    if (self = [super init]) {
        
        _name = @"";
        _oprLuid = 0;
    }
    
    return self;
}


-(NSDictionary *)writeToDIC{
    
    __autoreleasing NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:_opr] forKey:_Key_OprID_];
    [dic setObject:_time forKey:_Key_OprTime_];
    [dic setObject:_name forKey:_Key_OprName_];
    [dic setObject:[NSNumber numberWithInteger:_otherID] forKey:_Key_OprOtherID_];
    [dic setObject:[NSNumber numberWithLongLong:_oprLuid] forKey:_Key_OprLuid];
    
    return dic;
    
}

- (void)readFromDIC:(NSDictionary *)dic{
    
    _opr = [[dic objectForKey:_Key_OprID_] intValue];
    _time = [dic objectForKey:_Key_OprTime_];
    _name = [dic objectForKey:_Key_OprName_];
    
    _otherID = [[dic objectForKey:_Key_OprOtherID_] intValue];
    _oprLuid = [[dic objectForKey:_Key_OprLuid] longLongValue];
    
}

- (NSString*) timeStr{
    
    if (_time == nil) {
        
        return @"";
    }
    
    NSDateFormatter *format =[[NSDateFormatter alloc] init];
    
    [format setTimeZone:[NSTimeZone localTimeZone]];
    
    [format setDateFormat:@"HH:mm  MM-dd-yyyy"];
    
    
    return [format stringFromDate:_time];
    
}

- (NSString*) oprWithNameStr{
    
    return [NSString stringWithFormat:@"%@%@",_name,[self oprOnlyStr]];
    
}

- (NSString*) allStr{
    
    if (_time == nil) {
        
        return @"";
    }
    
    NSDateFormatter *format =[[NSDateFormatter alloc] init];
    
    [format setTimeZone:[NSTimeZone localTimeZone]];
    
    [format setDateFormat:@"HH:mm"];
    
//    return [NSString stringWithFormat:@"%@%@ %@",_name,[self oprOnlyStr],[format stringFromDate:_time]];
    
    return [NSString stringWithFormat:@"%llx-%@%@ %@",_oprLuid,_name,[self oprOnlyStr],[format stringFromDate:_time]];
}

- (NSString*) oprOnlyStr{
    
    return @"";
}

-(NSComparisonResult)compare:(XAIObjectOpr *)otherOpr{
    
    //半圆
    uint16_t max = 0xFFFF;
    if (_otherID >= 1 && _otherID <= max / 4
        && otherOpr.otherID >= max/4 * 3 && otherOpr.otherID <= max) {
        
        return NSOrderedAscending;
    }
    
    if (_otherID >= max/4 * 3 && _otherID <= max
        && otherOpr.otherID >= 1 && otherOpr.otherID <= max / 4) {
        
        return NSOrderedDescending;
    }
    

    if (_otherID <= otherOpr.otherID) {
        
        return NSOrderedAscending;
    }
    
    return NSOrderedDescending;
}

/*对操作数据进行排序*/
+(NSArray*) sort:(NSArray*)oprs{

    return [oprs sortedArrayUsingSelector:@selector(compare:)];
}


@end


