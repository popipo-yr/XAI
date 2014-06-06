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
