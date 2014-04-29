//
//  XAIObject.h
//  XAI
//
//  Created by office on 14-4-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"
#import "XAIData.h"

#import "XAIObjectGroup.h"

#import "XAIDebug.h"

typedef enum XAIObjectType{
    
    XAIObjectType_door = 0,
    XAIObjectType_light = 1,
    
    
}XAIObjectType;

#define XAIObjectTypeCount 2


@class XAIObjectOpr;
@class XAIDevice;

@interface XAIObject : NSObject<XAIDataInfo_DIC>{
    
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
    
}

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) XAIObjectType type; /*类别,门，窗，灯?*/
@property (nonatomic, assign) XAIGOURPID groupId; /*分组使用*/
@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, assign) XAITYPELUID luid;
@property (nonatomic, strong) XAIObjectOpr* lastOpr; /*最后一次操作*/
@property (nonatomic, strong) NSString* nickName;

@property (nonatomic, strong) NSString* vender; /*生产商*/
@property (nonatomic, strong) NSString* model; /*型号*/

- (void) startControl;
- (id) initWithDevice:(XAIDevice*)dev;
- (void) setDevInfo:(XAIDevice*)dev;

- (BOOL) readOprList; /*获取操作记录集,读取本地的信息*/
- (BOOL) addOpr:(XAIObjectOpr*)aOpr; /*添加一个操作记录 更新最后一次操作和操作列表*/
- (NSArray*) getOprList;


+ (NSString*) typeImageName:(XAIObjectType)type; /*类型对应的图片*/
+ (NSArray*)  typeCanUse;
+ (NSString*) typeOprClassName:(XAIObjectType)type; /*对应操作的类名*/
+ (NSString*) typeClassName:(XAIObjectType)type; /*对应的类名*/

@end


@interface XAIObjectOpr : NSObject <XAIDataInfo_DIC>{

    int _opr;
    NSDate* _time;
    NSString* _name;

}

@property (nonatomic, assign) int opr;
@property (nonatomic, strong) NSDate* time;
@property (nonatomic, strong) NSString* name;

- (NSString*) oprOnlyStr; /*开了灯  子类必须实现*/

- (NSString*) timeStr;   /*8:50  04/12/1*/
- (NSString*) oprWithNameStr;  /*小明开了灯*/

- (NSString*) allStr;  /*小明在8点50分开了灯*/

@end





