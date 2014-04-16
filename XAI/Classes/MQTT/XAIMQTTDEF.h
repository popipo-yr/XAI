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
    XAI_PKT_FLAG_ACK_CONTROL = 0x81,  //
    
}XAI_PKT_TYPE;


typedef  uint64_t  XAITYPELUID;
typedef  uint32_t  XAITYPEAPSN;
typedef  uint64_t  XAITYPEUNSIGN;
typedef  uint8_t   XAITYPEBOOL;

#define XAITYPEBOOL_TRUE 1
#define XAITYPEBOOL_FALSE 0
#define XAITYPEBOOL_UNKOWN 2

    
typedef  enum XAI_DATA_TYPE{
    
   
    XAI_DATA_TYPE_ASCII_TEXT = 0,//	字符串数据
    XAI_DATA_TYPE_BIN_ANGLE = 1,//	角度数据(0-360)
    XAI_DATA_TYPE_BIN_PERCENT = 2,//	百分比数据(0-100)
    XAI_DATA_TYPE_BIN_DATE = 3,//	时间数据(毫秒从1970.1.1)
    XAI_DATA_TYPE_BIN_BOOL = 4,//	布尔数据
    XAI_DATA_TYPE_BIN_DIGITAL_SIGN = 5, //	有符号数字
    XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN = 0Xd, //	无符号数字
    XAI_DATA_TYPE_BIN_APSN = 7,	//设备编号
    XAI_DATA_TYPE_BIN_LUID = 0xd, //	本地唯一编号
        
        
}XAI_DATA_TYPE;






#endif
