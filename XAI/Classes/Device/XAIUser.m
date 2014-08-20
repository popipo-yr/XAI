//
//  XAIUser.m
//  XAI
//
//  Created by office on 14-4-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUser.h"
#import "XAIMQTTDEF.h"
#import "XAIData.h"


@implementation XAIUser

- (BOOL) isAdmin{

   return  _luid == XAIUSERADMIN;
}

#define _k_type 99

+ (NSArray*) readIM:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn{
    
    
    
    NSMutableArray* msgs = [[NSMutableArray alloc] init];
    
    do {
        
        
        
        NSString* localFile = [XAIData getSavePathFile:
                               [NSString stringWithFormat:@"%u-%llu-%d.plist",apsn,luid,_k_type]];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSArray* oprAry = [[NSArray alloc] initWithContentsOfFile:localFile];
        
        if (oprAry == nil || [oprAry count] == 0) break;
        
        
        for (int i =0; i < [oprAry count]; i++) {
            
            NSDictionary* dic = [oprAry objectAtIndex:i];
            
            /*也可以通过类名获取*/
            
            XAIMeg* amsg = [[XAIMeg alloc] init];
            
            
            [amsg readFromDIC:dic];
            
            [msgs addObject:amsg];
        }
        
    } while (0);
    
    
    return msgs;

}

+ (BOOL) saveIM:(NSArray*)ary luid:(XAITYPELUID)luid apsn:(XAITYPEAPSN)apsn{

    BOOL isSuccess = false;
    
    do {
        
        NSString* localFile = [XAIData getSavePathFile:
                               [NSString stringWithFormat:@"%u-%llu-%d.plist",apsn,luid,_k_type]];
        
        if (localFile == nil || [localFile isEqualToString:@""]) break;
        
        NSMutableArray* msgs = [[NSMutableArray alloc] init];

        for (int i =0; i < [ary count]; i++) {
            
            XAIMeg* aMsg = [ary objectAtIndex:i];
            
            if (aMsg == nil && ![aMsg isKindOfClass:[XAIMeg class]]) continue;
            
            
            NSDictionary* dic = [aMsg writeToDIC];
            
            [msgs addObject:dic];
        }
        
        
        [msgs writeToFile:localFile atomically:YES];
        
        isSuccess = true;
        
    } while (0);
    
    
    return isSuccess;

}

@end


#define _K_FromApsn @"_K_FromApsn"
#define _K_FromLuid @"_K_FromLuid"
#define _K_ToApsn @"_K_ToApsn"
#define _K_ToLuid @"_K_ToApsn"
#define _K_Date @"_K_Date"
#define _K_Context @"_K_Context"

@implementation XAIMeg

-(NSDictionary *)writeToDIC{

    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (_context != nil) {
        
        [dic setObject:_context forKey:_K_Context];
    }
    
    if (_date != nil) {
        [dic setObject:_date forKey:_K_Date];
    }
    
    [dic setObject:[NSNumber numberWithLong:_fromAPSN] forKey:_K_FromApsn];
    [dic setObject:[NSNumber numberWithLongLong:_fromLuid] forKey:_K_FromLuid];
    [dic setObject:[NSNumber numberWithLong:_toAPSN] forKey:_K_ToApsn];
    [dic setObject:[NSNumber numberWithLongLong:_toLuid] forKey:_K_ToLuid];


    return dic;
}

-(void)readFromDIC:(NSDictionary *)dic{
    
    if (dic == nil) return;
    
    _context = [dic objectForKey:_K_Context];
    _date = [dic objectForKey:_K_Date];
    _fromAPSN = [[dic objectForKey:_K_FromApsn] longValue];
    _fromLuid = [[dic objectForKey:_K_FromLuid] longLongValue];
    _toAPSN = [[dic objectForKey:_K_ToApsn] longValue];
    _toLuid = [[dic objectForKey:_K_ToLuid] longLongValue];
    

}

@end
