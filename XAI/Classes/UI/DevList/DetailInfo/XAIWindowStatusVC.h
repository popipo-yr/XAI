//
//  XAIWindowStatusVC.h
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevShowStatusVC.h"
#import "XAIWindow.h"

@interface XAIWindowStatusVC : XAIDevShowStatusVC<XAIWindownDelegate>{
    
    XAIWindow* _window;
    
}

@property (nonatomic,strong) XAIWindow* window;

@end

