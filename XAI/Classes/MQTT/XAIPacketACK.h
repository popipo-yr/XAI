//
//  XAIPacketACK.h
//  XAI
//
//  Created by office on 14-4-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketCtrl.h"


#ifdef __cplusplus
extern "C" {
#endif
    
    
    /*----------ctrl----------------*/
    
#define _XPPS_A_SCID     1
#define _XPPS_A_ERRNO   1
#define _XPPS_A_DATA_COUNT  1
#define _XPPS_A_FIXED_ALL   (_XPPS_N_FIXED_ALL+1+1+1)
    
    
#define _XPP_A_SCID_START  31
#define _XPP_A_SCID_END    31
#define _XPP_A_ERRNO_START    32
#define _XPP_A_ERRNO_END    32
#define _XPP_A_DATA_COUNT_START   33
#define _XPP_A_DATA_COUNT_END 33
#define _XPP_A_DATA_START      34
#define _XPP_A_DATA_END        _XPP_END_UNKOWN
    
    
    
    
    
    typedef struct _xai_packet_param_ack{
        
        
        _xai_packet_param_normal* normal_param
        ;uint8_t  scid
        ;uint8_t  err_no
        ;uint8_t  data_count //1byte
        
        ;_xai_packet_param_ctrl_data*  data
        ;
        
    }_xai_packet_param_ack; //控制报文参数
    
    
    
    _xai_packet*   generatePacketACK(_xai_packet_param_ack* ack_param);  //依据参数生成一个控制的报文
    _xai_packet_param_ack*   generateParamACKFromPacket(const _xai_packet*  packet); //通过报文获控制参数
    _xai_packet_param_ack*   generateParamACKFromPacketData(void*  packet_data,int size);
    _xai_packet_param_ack*    generatePacketParamACK(); //生成一个报文参数
    void purgePacketParamACKAndData(_xai_packet_param_ack* ctrl_param); //释放一个控制报文参数包括data
    void purgePacketParamACKNoData(_xai_packet_param_ack* ctrl_param); //释放一个控制报文参数
    
    
    
    
    
    _xai_packet_param_ctrl_data*  getACKDataFrom(_xai_packet_param_ack* ctrl_param, int index); //通过index获取data
    _xai_packet_param_ctrl_data*  getACKData(_xai_packet_param_ctrl_data* ctrl_param_data, int index); //通过index获取data
    
    
    void xai_param_ack_set(_xai_packet_param_ack* param_ack,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                           XAITYPEAPSN to_apsn,XAITYPELUID to_luid,
                           uint8_t flag , uint16_t msgid , uint16_t magic_number ,uint8_t scid, uint8_t err_no, uint8_t data_count , _xai_packet_param_ctrl_data* data);
    
    
    
#ifdef __cplusplus
}
#endif
