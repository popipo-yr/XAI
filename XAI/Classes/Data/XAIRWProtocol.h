//
//  XAIRWProf.h
//  XAI
//
//  Created by office on 14-4-30.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//


/*读写协议*/
@protocol XAIDataInfo_DIC  <NSObject>

- (void) readFromDIC:(NSDictionary*)dic;
- (NSDictionary*) writeToDIC;

@end


@protocol XAIDataInfo_ARY <NSObject>

- (void) readFromARY:(NSArray*)ary;
- (NSArray*) writeToARY;

@end
