//
//  SWTableViewCellAdd.m
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SWTableViewCellAdd.h"

#define  _M_CellWidth 30

@implementation SWTableViewCell (ADD)

- (void) setDelBtn{
    
    // Add utility buttons
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    

    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f]
                                           normalIcon:[UIImage imageWithFile:@"del_nor.png"]
                                         selectedIcon:[UIImage imageWithFile:@"del_sel.png"]];
    
    [self setRightUtilityButtons:rightUtilityButtons WithButtonWidth:40];
}
- (void) setEditBtn{
    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f]
                                          normalIcon:[UIImage imageWithFile:@"edit_nor.png"]
                                        selectedIcon:[UIImage imageWithFile:@"edit_sel.png"]];
    
    
    [self setLeftUtilityButtons:leftUtilityButtons WithButtonWidth:_M_CellWidth];
}
- (void) setSaveBtn{
    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f]
                                          normalIcon:[UIImage imageWithFile:@"save_nor.png"]
                                        selectedIcon:[UIImage imageWithFile:@"save_sel.png"]];
    
    [self setLeftUtilityButtons:leftUtilityButtons WithButtonWidth:_M_CellWidth];
}

@end


