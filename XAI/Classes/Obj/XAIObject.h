//
//  XAIObject.h
//  XAI
//
//  Created by office on 14-4-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"
#import "XAIRWProtocol.h"
#import "XAILinkageUseInfo.h"

#import "XAIObjectGroup.h"
#import "XAIObjectOpr.h"

#import "XAIDebug.h"
#import "XAITimeOut.h"


typedef enum XAIObjectType{
    
    XAIObjectType_door = 0,
    XAIObjectType_light = 2,
    XAIObjectType_light2_1 = 3,
    XAIObjectType_light2_2 = 4,
    XAIObjectType_IR = 5,
    XAIObjectType_DWC_C = 7, //推拉窗帘
    XAIObjectType_DWC_D = 8,  //推拉门
    XAIObjectType_DWC_W = 9,  //推拉窗
    XAIObjectType_UnKown = -1,
    
}XAIObjectType;

#define XAIObjectTypeCount 9

#define XAIObjectFlagNormal 0


#define XAIObjStatusUnkown 9




@class XAIObjectOpr;
@class XAIDevice;

@interface XAIObject : XAITimeOut <XAIDataInfo_DIC>{
    
    NSString* _name;
    XAIObjectType _type; /*类别,门，窗，灯?*/
    XAIGOURPID _groupId; /*分组使用*/
    XAITYPEAPSN _apsn;
    XAITYPELUID _luid;
    //NSString* _lastOpr; /*最后一次操作*/
    NSString* _nickName;
    
    XAIObjectOpr* _lastOpr; /*最后一次操作*/
    
    NSMutableArray* _objOprList; //操作列表
    
    NSString* _model; /*型号*/
    NSString* _vender; /*生产商*/
    
    BOOL _isOnline;
    
    //int _flag; /*多控*/
    
    NSMutableArray* _tmpOprs;
    
    
}


@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) XAIObjectType type; /*类别,门，窗，灯?*/
@property (nonatomic, assign) XAIGOURPID groupId; /*分组使用*/
@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, assign) XAITYPELUID luid;
@property (nonatomic, strong) XAIObjectOpr* lastOpr; /*最后一次操作*/
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, assign) BOOL isOnline ;

@property (nonatomic, assign) int  curDevStatus;

@property (nonatomic, assign) float power;
@property (nonatomic, strong) NSString* vender; /*生产商*/
@property (nonatomic, strong) NSString* model; /*型号*/

//@property (nonatomic, assign) int flag;
/*初始化*/
- (void) step;
/*获取内部设备*/
- (XAIDevice*) curDevice;

- (void) startControl;
- (void) endControl;
- (id) initWithDevice:(XAIDevice*)dev;
- (void) setInfoFromDevice:(XAIDevice*)dev;

- (BOOL) readOprList; /*获取操作记录集,读取本地的信息*/
- (BOOL) addOpr:(XAIObjectOpr*)aOpr; /*添加一个操作记录 更新最后一次操作和操作列表*/
- (NSArray*) getOprList;
- (void) clearOpr;



- (void) timeout;
- (void) updateFinish:(XAIObjectOpr*)opr;


- (BOOL) hasLinkageTiaojian;
- (BOOL) hasLinkageJieGuo;
- (NSArray*) getLinkageTiaojian; /*获取联动使用信息*/
- (NSArray*) getLinkageJieGuo;
- (NSString*) linkageInfoMiaoShu:(XAILinkageUseInfo*)useInfo;
- (BOOL) linkageInfoIsEqual:(XAILinkageUseInfo*)useInfo index:(int)index;

@end







