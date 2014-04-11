//
//  XAIMQTTDEF.h
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIMQTTDEF_h
#define XAI_XAIMQTTDEF_h

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

typedef enum XAI_PKT_TYPE{
    
    
    XAI_PKT_TYPE_HELLO	 = 0,	//Hello报文
    XAI_PKT_TYPE_CONTROL =	1,	//向设备发送控制命令,命令格式从控制描述表获取
    XAI_PKT_TYPE_DEV_INFO_REQUEST = 2,	//请求设备表
    XAI_PKT_TYPE_DEV_INFO_REPLY = 3,	//设备表答复报文
    XAI_PKT_TYPE_STATUS_REQUEST = 4,	//请求状态表
    XAI_PKT_TYPE_STATUS = 5,	//状态表答复报文
    XAI_PKT_FLAG_ACK = 0x80,  //	FLAG最高位为1表示此报文是一个ACK报文
    
}XAI_PKT_TYPE;


typedef  uint64_t  XAITYPELUID;
typedef  uint32_t  XAITYPEAPSN;
    
typedef  enum XAI_DATA_TYPE{
    
   
    XAI_DATA_TYPE_ASCII_TEXT = 0,//	字符串数据
    XAI_DATA_TYPE_BIN_ANGLE = 1,//	角度数据(0-360)
    XAI_DATA_TYPE_BIN_PERCENT = 2,//	百分比数据(0-100)
    XAI_DATA_TYPE_BIN_DATE = 3,//	时间数据(毫秒从1970.1.1)
    XAI_DATA_TYPE_BIN_BOOL = 4,//	布尔数据
    XAI_DATA_TYPE_BIN_DIGITAL_SIGN = 5, //	有符号数字
    XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN = 6, //	无符号数字
    XAI_DATA_TYPE_BIN_APSN = 7,	//设备编号
    XAI_DATA_TYPE_BIN_LUID = 8, //	本地唯一编号
        
        
}XAI_DATA_TYPE;

/*----------------------normal-------------*/
    
    //大小
#define  _XPPS_N_FROM_GUID  12
#define  _XPPS_N_TO_GUID    12
#define  _XPPS_N_FLAG    1
#define  _XPPS_N_MSGID   2
#define  _XPPS_N_MAGIC_NUMBER  2
#define  _XPPS_N_LENGTH       2
#define  _XPPS_N_FIXED_ALL  (12+12+1+2+2+2)
    
    //开始与结束位置  0 表示第一位
#define  _XPP_END_UNKOWN   -1  //表示位置

#define  _XPP_N_FROM_GUID_START  0
#define  _XPP_N_FROM_GUID_END  11
#define  _XPP_N_TO_GUID_START   12
#define  _XPP_N_TO_GUID_END    23
#define  _XPP_N_FLAG_START    24
#define  _XPP_N_FLAG_END      24
#define  _XPP_N_MSGID_START   25
#define  _XPP_N_MSGID_END   26
#define  _XPP_N_MAGIC_NUMBER_START  27
#define  _XPP_N_MAGIC_NUMBER_END  28
#define  _XPP_N_LENGTH_START        29
#define  _XPP_N_LENGTH_END        30
#define  _XPP_N_DATA_START      31
#define  _XPP_N_DATA_END        _XPP_END_UNKOWN





#endif
