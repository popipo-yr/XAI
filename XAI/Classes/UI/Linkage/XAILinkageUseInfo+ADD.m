//
//  XAILinkageDescript.m
//  XAI
//
//  Created by office on 14/11/5.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageUseInfo+ADD.h"
#import "XAIData.h"
#import "XAILight.h"

@implementation XAILinkageUseInfo (add)

-(NSString*)toStrIsCond:(BOOL)isCond{

    return [self toStrIsCond:isCond nameRange:nil];
}

-(NSString*)toStrIsCond:(BOOL)isCond  nameRange:(NSRange*)nameRange{

    if (self.dev_apsn == 0x0 && self.dev_luid == 0x0) {
        //时间
        XAITYPETime time = 0;
        XAILinkageUseInfoTime* timeUseInfo = (XAILinkageUseInfoTime*)self;
        if (![timeUseInfo isKindOfClass:[XAILinkageUseInfoTime class]]) {
            
            
            timeUseInfo = [[XAILinkageUseInfoTime alloc] init];
            [timeUseInfo setApsn:0 Luid:0 ID:0 Datas:self.datas];
        }
        
        time = timeUseInfo.time;
        int hour = time/(60*60);
        int minu = (time - (hour*60*60))/60;
        
        if (isCond) {//条件 定时
            return [NSString stringWithFormat:@"当%d点%d分时",hour,minu];
            
        }else{
            
            return [NSString stringWithFormat:@"延时%d小时%d分",hour,minu];
            
        }
        
        
        
    }else{
        
        XAIObject* obj = [[XAIData shareData] findListenObj:self.dev_apsn luid:self.dev_luid];
        
        if ([obj isKindOfClass:[XAILight class]]) {
            
            if (self.some_id == 2) { /*通道二*/
                obj = [[XAIData shareData] findListenObj:self.dev_apsn
                                                    luid:self.dev_luid
                                                    type:XAIObjectType_light2_2];
            }
//            else{
//                obj = [[XAIData shareData] findListenObj:self.dev_apsn
//                                                    luid:self.dev_luid
//                                                    type:XAIObjectType_light2_1];
//            }
        }
        
        if (obj == nil) {
            
            if (isCond) {//条件 定时
                return  @"未知信息";
                
            }else{
                
                return @"未知控制";
                
            }
        }else{
            
            NSString* miaoshu =  [obj linkageInfoMiaoShu:self];
            
            NSString* name = obj.name;
            
            if (obj.nickName != nil && ![obj.nickName isEqualToString:@""]) {
                name = obj.nickName;
            }
            
            NSString* tip = nil;
            
            if (isCond) {
                // tiaojian
                if (miaoshu == nil || ![obj  hasLinkageTiaojian]) {
                    tip = [NSString stringWithFormat:@"%@未知条件",name];
                    if (nameRange != nil) {
                        (*nameRange).location = 0;
                        (*nameRange).length = name.length;
                    }
                }else{
                    tip = [NSString stringWithFormat:@"当%@%@时",name,miaoshu];
                    if (nameRange != nil) {
                        (*nameRange).location = 1;
                        (*nameRange).length = name.length;
                    }
                }
                
                return tip;
                
                
            }else{
                //结果
                if (miaoshu == nil || ![obj hasLinkageJieGuo]) {
                    tip = [NSString stringWithFormat:@"%@未知控制",name];
                    if (nameRange != nil) {
                        (*nameRange).location = 1;
                        (*nameRange).length = name.length;
                    }
                }else{
                    tip = [NSString stringWithFormat:@"%@%@",miaoshu,name];
                    if (nameRange != nil) {
                        (*nameRange).location = 1;
                        (*nameRange).length = name.length;
                    }
                }
                
                return tip;
            }
            
            
        }

    }
}

@end
