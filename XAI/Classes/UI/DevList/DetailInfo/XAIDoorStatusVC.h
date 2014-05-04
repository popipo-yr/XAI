//
//  XAIDoorStatusVC.h
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevShowStatusVC.h"
#import "XAIDoor.h"

@interface XAIDoorStatusVC : XAIDevShowStatusVC <XAIDoorDelegate>{
    
    XAIDoor* _door;
    
}

@property (nonatomic,strong) XAIDoor* door;

@end
