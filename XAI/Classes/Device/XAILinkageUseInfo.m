//
//  XAILinkageUseInfo.m
//  XAI
//
//  Created by office on 14-6-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageUseInfo.h"

@implementation XAILinkageUseInfo

- (id)init{

    if (self = [super init]) {
        
        _datas = NULL;
    }
    
    return self;
}

- (void)dealloc{

    if (_datas != NULL) {
        
        purgePacketParamData(_datas);
        _datas = NULL;
    }
}

- (void) setApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid ID:(int)ID Datas:(_xai_packet_param_data *)datas{

    _dev_apsn = apsn;
    _dev_luid = luid;
    _some_id = ID;
    _cond = XAILinkageCondition_E;
    if (_datas != NULL) {
        
        purgePacketParamData(_datas);
    }
    
    _datas =  generateParamDataCopyOther(datas);
}

@end

@implementation XAILinkageUseInfoCtrl

@end

@implementation XAILinkageUseInfoStatus

@end

@implementation XAILinkageUseInfoStatusMutable

@end

@implementation XAILinkageUseInfoTime

-(void)change{

    _xai_packet_param_data* time_data = generatePacketParamData();
    xai_param_data_set(time_data, XAI_DATA_TYPE_DELAY, sizeof(XAITYPETime), &_time, NULL);
    
    [self setApsn:0 Luid:0 ID:0 Datas:time_data];
    
    purgePacketParamData(time_data);
}

- (void) setApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid ID:(int)ID Datas:(_xai_packet_param_data*)datas{

    [super setApsn:apsn Luid:luid ID:ID Datas:datas];
    
    if (datas != nil && datas->data_type == XAI_DATA_TYPE_DELAY) {
        
        XAITYPETime time = 0;
        byte_data_copy(&time, datas->data, sizeof(XAITYPETime), datas->data_len);

        _time = time;
    }

}

@end
