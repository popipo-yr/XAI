//
//  XAILinkageDescript.h
//  XAI
//
//  Created by office on 14/11/5.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageUseInfo.h"

@interface XAILinkageUseInfo (add)

-(NSString*)toStrIsCond:(BOOL)isCond;
-(NSString*)toStrIsCond:(BOOL)isCond  nameRange:(NSRange*)nameRange;

@end
