//
//  XAILinkageAddInfoVC.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIObject.h"
#import "XAILinkageAlert.h"

typedef enum {
    
    XAILinkageOneType_yuanyin,
    XAILinkageOneType_jieguo,

}XAILinkageOneType;

@interface XAILinkageAddInfoVC : UITableViewController
<UITableViewDataSource,UITableViewDelegate>{

    NSArray* _datas;
    
    
    XAILinkageAlert* _linkageAlert;
    XAIObject* _curObj;
    
    XAILinkageOneType _type;
    
}


+(XAILinkageAddInfoVC*)create;
- (void) setLinkageOneChoosetype:(XAILinkageOneType)type;

@end
