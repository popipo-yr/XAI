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

#define XAIUSERADMIN   0x1

#define XAITYPEBOOL_TRUE 1
#define XAITYPEBOOL_FALSE 0
#define XAITYPEBOOL_UNKOWN 2

    
typedef  enum XAI_DATA_TYPE{
    
   
    XAI_DATA_TYPE_ASCII_TEXT = 0,//	字符串数据
    XAI_DATA_TYPE_BIN_ANGLE = 1,//	角度数据(0-360)
    XAI_DATA_TYPE_BIN_PERCENT = 2,//	百分比数据(0-100)
    XAI_DATA_TYPE_BIN_DATE = 3,//	时间数据(毫秒从1970.1.1)
    XAI_DATA_TYPE_BIN_DIGITAL_SIGN = 5, //	有符号数字
    
    XAI_DATA_TYPE_BIN_APSN = 0xd,	//设备编号  使用无符号表示
    XAI_DATA_TYPE_BIN_LUID = 0xd, //	本地唯一编号  使用无符号表示
    
    XAI_DATA_TYPE_BIN_BOOL = 0x0B,//	布尔数据
    XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN = 0Xd, //	无符号数字
        
        
}XAI_DATA_TYPE;


typedef enum  XAI_ERROR{
    
    XAI_ERROR_NONE = 0,
    XAI_ERROR_UNCHANGE = 1,
    XAI_ERROR_GENERAL = 2,
    XAI_ERROR_NO_PRIV = 3,  //权限冲突	不是admin或者不是本人
    XAI_ERROR_NAME_EXISTED = 4, //"1、注册、注销用户时，FromLuid 是不是Admin账户
    // 2、修改用户名、用户密码时，不是本人"
    
    XAI_ERROR_NAME_INVALID = 5, //"1、注册用户的用户名为空
    //2、注册设备的名字为空
    //3、修改用户的用户名为空"
    XAI_ERROR_NAME_NONE_EXISTED = 6, //用户名不存在
    
    XAI_ERROR_LUID_EXISTED = 7, //1、添加设备时LUID已经存在
    XAI_ERROR_LUID_INVALID = 8, //"1、发送给APSERVER模块的TO_LUID不是0x3
    //2、发送给RB模块的TO_LUID错误
    //3、注册设备时，LUID 不在范围 0x0000000100000000-0xFFFFFFFFFFFFFFFF"
    
    
    XAI_ERROR_LUID_NONE_EXISTED = 9,//	"1、修改用户密码时，LUID不存在
    //2、修改用户名字时，LUID不存在
    //3、删除用户时，LUDI不存在"
    
    XAI_ERROR__PWD_INCORRECT = 10,	//1、修改用户密码时，密码为空

    XAI_ERROR___DEVICE_NONE_EXISTED =11,//	"1、删除设备时，LUID不存在
    XAI_ERROR_DEVICE_OFFLINE = 12	, //设备离线	主要用于桥接模块检测设备是否在线
    
    //2、修改设备名字时，LUID不存在"
    XAI_ERROR_ARG_INCORRECT	 = 13 , //1、ID 和对应的datacount不匹配
    XAI_ERROR_LOW_POWER = 14, //电量低
    XAI_ERROR_MALLOC_ERROR	 = 15 ,//"1、APSERVERM模块申请内存失败
    //2、RB模块申请内存失败
    //3、Zigbee部分申请内存失败"
    
    XAI_ERROR_MSGID_NOT_LAST = 16,	// MSGID不是最新	 Apserver模块和RB模块内部使用
    XAI_ERROR_MSG_TYPE = 17,	 //消息类型错误 发给RB模块和Apserver模块的消息FLAG错误
    XAI_ERROR_MODLE_BRIDGE = 18,	//桥接模块内部错误 RB模块内部使用
    XAI_ERROR_MODLE_APSERVER = 19 ,//	APSERVER模块内部错误 Apserver模块内部使用
    XAI_ERROR_NULL_POINTER = 20, //空指针错误	Apserver模块和RB模块内部使用
    XAI_ERROR_APSN = 21,	// APSN错误 发送报文的中的APSN错误
    XAI_ERROR_ID  = 22,//	控制报文中的ID错误
    XAI_ERROR_LEN = 23, //	报文长度错误
    XAI_ERROR_DATA_TYPE = 24 ,//	数据单元中类型错误
    
    
    XAI_ERROR_UNKOWEN = 99,
    
    
}XAI_ERROR;






#endif
