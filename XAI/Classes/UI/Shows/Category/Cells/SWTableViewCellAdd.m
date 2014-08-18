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
                                           normalIcon:[UIImage imageNamed:@"del_nor.png"]
                                         selectedIcon:[UIImage imageNamed:@"del_sel.png"]];
    
    [self setRightUtilityButtons:rightUtilityButtons WithButtonWidth:_M_CellWidth];
}
- (void) setEditBtn{
    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
                                          normalIcon:[UIImage imageNamed:@"edit_nor.png"]
                                        selectedIcon:[UIImage imageNamed:@"edit_sel.png"]];
    
    
    [self setLeftUtilityButtons:leftUtilityButtons WithButtonWidth:_M_CellWidth];
}
- (void) setSaveBtn{
    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.1f green:0.0f blue:1.0f alpha:1.0f]
                                               title:@"保存"];
    
    [self setLeftUtilityButtons:leftUtilityButtons WithButtonWidth:_M_CellWidth];
}

@end


