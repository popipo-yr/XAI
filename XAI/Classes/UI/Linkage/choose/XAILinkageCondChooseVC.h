//
//  XAILinkageCondChooseVC.h
//  XAI
//
//  Created by office on 14/11/6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageChooseVC.h"

@interface XAILinkageCondChooseVC : XAILinkageChooseVC{

    int _selLeftType;
    UITableViewCell* _curCell;
    
    UIFont* _oldFont;
    CGRect  _oldRect;
}

@end

