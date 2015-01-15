//
//  XAIObjOpr.h
//  XAI
//
//  Created by office on 14-7-28.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIRWProtocol.h"

#import "XAIMQTTDEF.h"


#define _Key_OprTime_ @"OprTime"
#define _Key_OprName_ @"OprName"
#define _Key_OprID_ @"OprOrder"
#define _Key_OprOtherID_ @"OprOtherID"
#define _Key_OprLuid @"OprLuid"


@interface XAIObjectOpr : NSObject <XAIDataInfo_DIC>{
    
    int _opr;
    NSDate* _time;
    NSString* _name;
    
    uint16_t _otherID; /*比较使用,报文的msgid*/
    
    XAITYPELUID _oprLuid; /*记录操作的luid*/
    
}

@property (nonatomic, assign) int opr;
@property (nonatomic, assign) uint16_t otherID;
@property (nonatomic, strong) NSDate* time;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) XAITYPELUID oprLuid;

- (NSString*) oprOnlyStr; /*开了灯  子类必须实现*/

- (NSString*) timeStr;   /*8:50  04/12/1*/
- (NSString*) oprWithNameStr;  /*小明开了灯*/

- (NSString*) allStr;  /*小明在8点50分开了灯*/

/*对操作数据进行排序*/
+ (NSArray*) sort:(NSArray*)oprs;

-(BOOL) isWorn;

@end

