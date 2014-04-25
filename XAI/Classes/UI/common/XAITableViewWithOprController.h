//
//  XAITableViewWithOprViewController.h
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewController.h"

@interface XAITableViewWithOprController : XAITableViewController{


    UIBarButtonItem* _editItem;
    
    UISwipeGestureRecognizer* _recognizer;
    
    NSIndexPath* _curDelIndexPath;
}


- (void) addBtnClick:(id) sender;
- (void) delBtnClick:(NSIndexPath*) index;

@end
