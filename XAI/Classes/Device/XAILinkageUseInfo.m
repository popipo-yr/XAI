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
    
    if (_timeStruct != nil) {
        NSData* bData = [_timeStruct getBinary];
        xai_param_data_set(time_data, XAI_DATA_TYPE_Time, bData.length, (void*)bData.bytes, NULL);
        
    }else{
        xai_param_data_set(time_data, XAI_DATA_TYPE_DELAY, sizeof(XAITYPETime), &_time, NULL);
    }

    
    [self setApsn:0 Luid:0 ID:0 Datas:time_data needChange:false];
    
    purgePacketParamData(time_data);
}

- (void) setApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid ID:(int)ID Datas:(_xai_packet_param_data*)datas{

    [self setApsn:apsn Luid:luid ID:ID Datas:datas needChange:true];

}

//needchange  是否需要更新内部数据
- (void) setApsn:(XAITYPEAPSN)apsn Luid:(XAITYPELUID)luid ID:(int)ID Datas:(_xai_packet_param_data*)datas needChange:(BOOL)needChange{
    
    [super setApsn:apsn Luid:luid ID:ID Datas:datas];
    
    if (needChange == false) return;
    
    if (datas != nil && datas->data_type == XAI_DATA_TYPE_DELAY) {
        
        XAITYPETime time = 0;
        byte_data_copy(&time, datas->data, sizeof(XAITYPETime), datas->data_len);
        
        _time = time;
        
    }else if(datas != nil && datas->data_type == XAI_DATA_TYPE_Time){
        
        XAILinkageTimeStruct* timeStruct = [[XAILinkageTimeStruct alloc] init];
        
        NSData* bData = [NSData dataWithBytes:datas->data length:datas->data_len];
        [timeStruct setDateFromBData:bData];
        
        _timeStruct = timeStruct;
    }
    
}

@end

@implementation XAILinkageTimeStruct

-(void)setDate:(NSDate *)date dimension:(Linkage_Time_Dimension)dimension{
    
    
    
    _dimension = dimension;

    
    NSDateFormatter* hourFormat = [[NSDateFormatter alloc] init];
    hourFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [hourFormat setDateFormat:@"HH"];
    
    NSDateFormatter* minuFormat = [[NSDateFormatter alloc] init];
    minuFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [minuFormat setDateFormat:@"mm"];
    
    NSDateFormatter* secFormat = [[NSDateFormatter alloc] init];
    secFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [secFormat setDateFormat:@"ss"];
    
    NSDateFormatter* yearFormat = [[NSDateFormatter alloc] init];
    yearFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [yearFormat setDateFormat:@"yyyy"];
    
    NSDateFormatter* mouthFormat = [[NSDateFormatter alloc] init];
    mouthFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [mouthFormat setDateFormat:@"MM"];
    
    NSDateFormatter* dayFormat = [[NSDateFormatter alloc] init];
    dayFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dayFormat setDateFormat:@"dd"];
    

    _hour =[[hourFormat stringFromDate:date] intValue];
    _min = [[minuFormat stringFromDate:date] intValue];
    _sec = [[secFormat stringFromDate:date] intValue];
    _year = [[yearFormat stringFromDate:date] intValue] - 2000; //从2千年开始计算
    _mouth = [[mouthFormat stringFromDate:date] intValue];
    _mday = [[dayFormat stringFromDate:date] intValue];
    
    if (dimension == Linkage_Time_Dimension_Day) {
        _year = _mouth = _mday = _sec =0;
    }else if (dimension == Linkage_Time_Dimension_Mouth){
        _year = _mouth = 0;
    }else if (dimension == Linkage_Time_Dimension_Year){
        _year = 0;
    }
    
    
    _wday = 0; //星期
    
}

-(NSData*)getBinary{

    NSMutableData* bData = [[NSMutableData alloc] init];
    [bData appendBytes:&_sec length:1];
    [bData appendBytes:&_min length:1];
    [bData appendBytes:&_hour length:1];
    [bData appendBytes:&_mday length:1];
    [bData appendBytes:&_mouth length:1];
    [bData appendBytes:&_year length:1];
    [bData appendBytes:&_wday length:1];
    
    return bData;
}

-(void)setDateFromBData:(NSData *)bData{

    if (bData.length != 7) return;
    
    NSRange range ;
    range.length = 1;
    
    range.location = 0;
    [bData getBytes:&_sec range:range];
    range.location = 1;
    [bData getBytes:&_min range:range];
    range.location = 2;
    [bData getBytes:&_hour range:range];
    range.location = 3;
    [bData getBytes:&_mday range:range];
    range.location = 4;
    [bData getBytes:&_mouth range:range];
    range.location = 5;
    [bData getBytes:&_year range:range];
    range.location = 6;
    [bData getBytes:&_wday range:range];
    
    if (_year != 0) {
        _dimension = Linkage_Time_Dimension_All;
    }else if(_year == 0 && _mouth != 0){
        _dimension = Linkage_Time_Dimension_Year;
    }else if(_year == 0 && _mouth == 0 && _mday != 0){
        _dimension = Linkage_Time_Dimension_Mouth;
    }else{
        _dimension = Linkage_Time_Dimension_Day;
    }
}

-(NSString*)toStr{
    
    
    int mouth = _mouth == 0 ? 1 : _mouth;
    int mday = _mday == 0 ? 1 : _mday;
    
    NSString* gmtStr = [NSString stringWithFormat:@"%d/%.2d/%.2d %.2d:%.2d"
                        ,_year+2000,mouth,mday,_hour,_min];

    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy/MM/dd HH:mm";
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDate* dateGMT  = [format dateFromString:gmtStr];
    
    format.timeZone = [NSTimeZone localTimeZone];
    
    NSString* str = nil;

    if (_dimension == Linkage_Time_Dimension_Day) {
        format.dateFormat = @"每天hh:mm";
        str = [format stringFromDate:dateGMT];
    }else if (_dimension == Linkage_Time_Dimension_Mouth){
        format.dateFormat = @"每月dd hh:mm";
        str = [format stringFromDate:dateGMT];
    }else if (_dimension == Linkage_Time_Dimension_Year){
        format.dateFormat = @"每年MM/dd hh:mm";
        str = [format stringFromDate:dateGMT];
    }else{
        format.dateFormat = @"yy/MM/dd hh:mm";
        str = [format stringFromDate:dateGMT];
    }
    
    return str;
}

@end
