//
//  XAILinkageAddInfoVC.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIHasTableViewVC.h"
#import "XAIObject.h"
#import "XAILinkageAlert.h"
#import "XAILinkageTime.h"
#import "XAILinkageInfoVC.h"

typedef enum {
    
    XAILinkageOneType_yuanyin,
    XAILinkageOneType_jieguo,

}XAILinkageOneType;

@interface XAILinkageAddInfoVC : XAIHasTableViewVC
<UITableViewDataSource,UITableViewDelegate>{

    NSArray* _datas;
    
    
    XAILinkageAlert* _linkageAlert;
    XAILinkageTime* _linkageTime;
    XAIObject* _curObj;
    
    XAILinkageOneType _type;
    
}


@property (nonatomic,retain) XAILinkageInfoVC* infoVC;


+(XAILinkageAddInfoVC*)create;
- (void) setLinkageOneChoosetype:(XAILinkageOneType)type;

@end
