//
//  XAIIPHelper.h
//  XAI
//
//  Created by office on 14-6-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIMQTTDEF.h"



#define _Macro_Host  @"www.xai.so"

typedef enum _XAIIPHelper_GetStep{
    
    _XAIIPHelper_GetStep_Start = 0,
    _XAIIPHelper_GetStep_FromRoute,
    _XAIIPHelper_GetStep_FromCloud,

}_XAIIPHelper_GetStep;


typedef enum _err{
    
    _err_none = 0,
    _err_unkown,
    _err_connect_fail,
    _err_get_data_fail,
    _err_get_host_ip_fail,
    _err_timeout,
    
    
}_err;

typedef struct Helper{
    
    void*  who;  /*obj  XAIHelper*/
    
    char* host;
    char* ip_char;
    _err  err;
    BOOL isGetSuc;
    
    BOOL isFinish;
    
    int sock;
    
    XAITYPEAPSN  apsn;
    
    void (*getApserverIpResult)(struct Helper* p_helper, _err rc);
    
}Helper;



@protocol XAIIPHelperDelegate;
@interface XAIIPHelper : NSObject{

    _XAIIPHelper_GetStep  _getStep;
    NSString* _host;
    NSString* _ipStr;
    
    Helper* _p_helper;
    BOOL _create_p;
    
    NSTimer* _timer;
    
    XAITYPEAPSN  _apsn;

}

@property (nonatomic,weak) id <XAIIPHelperDelegate> delegate;
@property (nonatomic,readonly) _XAIIPHelper_GetStep  getStep;

- (void)getApserverIpWithApsn:(XAITYPEAPSN)apsn fromRoute:(NSString*)host;


- (void) _res_getApserverIp:(const char*)ip err:(_err) rc;

@end


@protocol XAIIPHelperDelegate <NSObject>

-(void)xaiIPHelper:(XAIIPHelper*)helper getIp:(NSString*)ip errcode:(_err)rc;


@end

