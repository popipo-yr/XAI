//
//  XAIChangeNameVC.h
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAIChangeNameVC : UITableViewController <UITableViewDataSource,UITabBarDelegate,UIAlertViewDelegate>{

    UITextField* _newNameTextField;
    id _okTarget;
    SEL _okSelector;
    

    NSString* _oneLabName;
    NSString* _oneTexName;
    NSString* _twoLabName;
    
    NSString* _barItemTitle;


}


- (void) setOKClickTarget:(id)target Selector:(SEL)selector;
- (void) setOneLabName:(NSString*)oneLabName OneTexName:(NSString*)oneTexName
            TwoLabName:(NSString*)twoLabName ;

- (void) endOkEvent;

- (void) endFailEvent:(NSString*)str;

- (void) setBarTitle:(NSString*)title;

@end
