//
//  XAIData.h
//  XAI
//
//  Created by office on 14-4-28.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XAIUser.h"

@interface XAIData : NSObject{

    NSMutableArray*  _userList; //xaiuser list
    NSMutableArray*  _devList;  //xaiobject list

}

+ (XAIData*) shareData;

@end


/*读写协议*/
@protocol XAIDataInfo_DIC  <NSObject>

- (void) readFromDIC:(NSDictionary*)dic;
- (NSDictionary*) writeToDIC;

@end


@protocol XAIDataInfo_ARY <NSObject>

- (void) readFromARY:(NSArray*)ary;
- (NSArray*) writeToARY;

@end