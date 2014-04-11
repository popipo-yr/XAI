//
//  AAViewController.h
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    
    /*----------ctrl----------------*/
    
#define _XPPS_C_OPRID     1
#define _XPPS_C_TIME   4
#define _XPPS_C_DATA_COUNT  1
//#define _XPPS_C_DATA_TYPE  1
//#define _XPPS_C_DATA_LEN    2
#define _XPPS_C_FIXED_ALL   (_XPPS_N_FIXED_ALL+1+4+1)
    
    
#define _XPP_C_OPRID_START  31
#define _XPP_C_OPRID_END    31
#define _XPP_C_TIME_START    32
#define _XPP_C_TIME_END    35
#define _XPP_C_DATA_COUNT_START   36
#define _XPP_C_DATA_COUNT_END 36
//#define _XPP_C_DATA_TYPE_START    37
//#define _XPP_C_DATA_TYPE_END    37
//#define _XPP_C_DATA_LEN_START 38
//#define _XPP_C_DATA_LEN_END   39
//#define  _XPP_C_DATA_START      40
#define  _XPP_C_DATA_START      37
#define  _XPP_C_DATA_END        _XPP_END_UNKOWN
    
    
#define _XPP_CD_TYPE_START    0
#define _XPP_CD_TYPE_END    0
#define _XPP_CD_LEN_START 1
#define _XPP_CD_LEN_END   2
#define  _XPP_CD_DATA_START      3
#define  _XPP_CD_DATA_END        _XPP_END_UNKOWN
    
    
#define _XPPS_CD_TYPE  1
#define _XPPS_CD_DATA_LEN    2
#define _XPPS_CD_FIXED_ALL   (1+2)
    
    
    typedef struct _xai_packet_param_ctrl_data{
    
        void*   data   //数据
        ;uint8_t  data_type
        ;uint16_t  data_len   //2byte
        ;struct _xai_packet_param_ctrl_data*  next
        ;
        
    }_xai_packet_param_ctrl_data;
    
    
    
    typedef struct _xai_packet_param_ctrl{
        
        
        _xai_packet_param_normal* normal_param
        ;uint8_t  oprId      //2byte
        ;uint32_t  time //4
        ;uint8_t  data_count //1byte
        
        //;void*  data    //.......
        //;uint8_t  data_type
        //;uint16_t  data_len   //2byte
        ;_xai_packet_param_ctrl_data*  data
        ;
        
    }_xai_packet_param_ctrl; //控制报文参数
    
    
    
    _xai_packet*   generatePacketCtrl(_xai_packet_param_ctrl* ctrl_param);  //依据参数生成一个控制的报文
    _xai_packet_param_ctrl*   generateParamCtrlFromPacket(const _xai_packet*  packet); //通过报文获控制参数
    _xai_packet_param_ctrl*   generateParamCtrlFromPacketData(void*  packet_data,int size);
    _xai_packet_param_ctrl*    generatePacketParamCtrl(); //生成一个报文参数
    void purgePacketParamCtrlAndData(_xai_packet_param_ctrl* ctrl_param); //释放一个控制报文参数包括data
    void purgePacketParamCtrlNoData(_xai_packet_param_ctrl* ctrl_param); //释放一个控制报文参数
    
    
    
    _xai_packet_param_ctrl_data*    generatePacketParamCtrlData(); //生成数据段
    void purgePacketParamCtrlData(_xai_packet_param_ctrl_data* ctrl_param_data); //释放一个数据段
    //生成所有的数据段
    _xai_packet_param_ctrl_data*   generateParamCtrlDataFromPacketData(void*  data,int data_size ,int count);
    //生成一个数据段
    _xai_packet_param_ctrl_data*    generateParamCtrlDataFromPacketDataOne(void*  packet_data,int size);
    //数据段转为data
    _xai_packet* generatePacketCtrlData(_xai_packet_param_ctrl_data* ctrl_param_data , int count);
    //一个数据段转为data
    _xai_packet* generatePacketCtrlDataOne(_xai_packet_param_ctrl_data* ctrl_param_data);
    

    _xai_packet_param_ctrl_data*  getCtrlDataFrom(_xai_packet_param_ctrl* ctrl_param, int index); //通过index获取data
    _xai_packet_param_ctrl_data*  getCtrlData(_xai_packet_param_ctrl_data* ctrl_param_data, int index); //通过index获取data
    
    void xai_param_ctrl_data_set(_xai_packet_param_ctrl_data* ctrlData ,XAI_DATA_TYPE type , size_t len ,void* data , _xai_packet_param_ctrl_data* next);
    
    void xai_param_ctrl_set(_xai_packet_param_ctrl* param_ctrl,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                            XAITYPEAPSN to_apsn,XAITYPELUID to_luid,
                            uint8_t flag , uint16_t msgid , uint16_t magic_number ,uint8_t oprId, uint32_t time, uint8_t data_count , _xai_packet_param_ctrl_data* data);

    
    
#ifdef __cplusplus
}
#endif
