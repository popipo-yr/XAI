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


//typedef uint8_t XAILinkageStatus;

typedef enum : uint8_t{

    XAILinkageStatus_DisActive = 1,
    XAILinkageStatus_Active = 2,
    XAILinkageStatus_UNKown = 3

}XAILinkageStatus;



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
