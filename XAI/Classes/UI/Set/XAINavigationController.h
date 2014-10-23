//
//  XAINavigationController.h
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  XAINavigationControllerStatus
-(BOOL)statusDefault;
@end

@interface XAINavigationController : UINavigationController{

}

@property (nonatomic,assign) BOOL statusDefault;


@end
