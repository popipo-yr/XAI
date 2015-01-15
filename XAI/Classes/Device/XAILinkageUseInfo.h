//
//  XAILinkageUseInfo.h
//  XAI
//
//  Created by office on 14-6-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIMQTTDEF.h"
#import "XAIPacket.h"






typedef enum : uint8_t{

    XAILinkageCondition_E = 1,
    XAILinkageCondition_NE = 2,
    XAILinkageCondition_G  = 3,
    XAILinkageCondition_NL  = 4,
    XAILinkageCondition_L = 5,
    XAILinkageCondition_NG = 6
    

}XAILinkageCondition;


@interface XAILinkageUseInfo : NSObject{

    XAITYPEAPSN _dev_apsn;
    XAITYPELUID _dev_luid;
    int  _some_id;
    XAILinkageCondition _cond;
    
    _xai_packet_param_data* _datas;
    
    void* _other_data; /*任何类型*/
}


@property (assign,readonly) XAITYPEAPSN dev_apsn;
@property (assign,readonly) XAITYPELUID dev_luid;
@property (assign,readonly) int some_id;
@property (assign,readonly) _xai_packet_param_data* datas;
@property (assign,readonly) XAILinkageCondition cond;

- (void) setApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid ID:(int)ID Datas:(_xai_packet_param_data*)datas;

@end

/*控制信息作为联动条件 开灯(一个操作)*/
@interface XAILinkageUseInfoCtrl : XAILinkageUseInfo

@end

/*状态信息作为联动条件 门打开时(固定状态)*/
@interface XAILinkageUseInfoStatus : XAILinkageUseInfo{
    
    float _otherValue;
}

@end

/*可变的状态信息作为联动条件  温度大于多少度(可变状态)*/
@interface XAILinkageUseInfoStatusMutable : XAILinkageUseInfoStatus

@end


/*时间*/
@class XAILinkageTimeStruct;
@interface XAILinkageUseInfoTime : XAILinkageUseInfoStatus

@property (nonatomic,assign) XAITYPETime time;
@property (nonatomic,strong) XAILinkageTimeStruct* timeStruct;


- (void)change;


@end

typedef NS_ENUM(NSUInteger, Linkage_Time_Dimension) {
    Linkage_Time_Dimension_Day,
    Linkage_Time_Dimension_Mouth,
    Linkage_Time_Dimension_Year,
    Linkage_Time_Dimension_All, /*表示整个时间长度*/
};
//gmt 时间
@interface XAILinkageTimeStruct : NSObject{

    
    uint8_t _sec;
    uint8_t _min;
    uint8_t _hour;
    uint8_t _mday;
    uint8_t _mouth;
    uint8_t _year;  /*从2000年开始计数*/
    uint8_t _wday;
    
    
    Linkage_Time_Dimension  _dimension;


}


-(void)setDate:(NSDate*)date dimension:(Linkage_Time_Dimension)dimension;
-(NSData*)getBinary;
-(void)setDateFromBData:(NSData*)bData;

-(NSString*)toStr;

@end


