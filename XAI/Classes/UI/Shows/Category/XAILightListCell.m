//
//  XAILightListCellID.m
//  XAI
//
//  Created by office on 14-8-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILightListCell.h"
#import "XAIObjectGenerate.h"
#import "XAILightListVC.h"

@implementation XAILightListVCCell

@end

@implementation XAILightListVCChildCell

@end

@implementation XAILightListVCCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cTableView.dataSource = self;
        self.cTableView.delegate = self;
    }
    return self;
}

- (void) setDatas:(NSArray*)datas{
    
    [self.cTableView setScrollEnabled:false];
    _curInputCell = nil;
    
    _datas = [[NSArray alloc] initWithArray:datas];
    [self.cTableView reloadData];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    _cells = [[NSMutableArray alloc] init];
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_datas count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier2 = XAILightListCellChildID;
    
    
    XAILightListVCChildCell *cell = [tableView
                                dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell == nil) {
        cell = [[XAILightListVCChildCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier2];
    }
    
    XAIObject* aObj = [_datas objectAtIndex:[indexPath row]];
    
    if (aObj != nil && [aObj isKindOfClass:[XAIObject class]]) {
        
        [cell.headImageView setBackgroundColor:[UIColor clearColor]];
        [cell.headImageView setImage:[UIImage imageNamed:[XAIObjectGenerate typeImageName:aObj.type]]];
        
        if (aObj.nickName != NULL && ![aObj.nickName isEqualToString:@""]) {
            
            [cell.nameLable setText:aObj.nickName];
        }else{
            
            [cell.nameLable setText:aObj.name];
        }
        
        [cell.contextLable setText:[aObj.lastOpr allStr]];
        
        
    }
    
    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                               title:@"修改备注"];
    
    
    cell.leftUtilityButtons = leftUtilityButtons;
    cell.delegate = self;
    
    //[cell setBackgroundColor:[UIColor greenColor]];
    [_cells addObject:cell];
    return cell;
    
    
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    
    NSLog(@"%d",state);
    return;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            XAILightListVCChildCell* listCell = (XAILightListVCChildCell*)cell;
            if ([listCell isKindOfClass:[XAILightListVCChildCell class]]) {
                
                [self.topVC changeInputCell:listCell input:listCell.input];
//                if (_curInputCell != nil) {
//                    
//                    _curInputCell.input.enabled = false;
//                    _curInputCell.input.hidden = true;
//                    [_curInputCell.input resignFirstResponder];
//                    [_curInputCell hideUtilityButtonsAnimated:true];
//                    
//                    // Add utility buttons
//                    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
//                    
//                    
//                    [leftUtilityButtons sw_addUtilityButtonWithColor:
//                     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
//                                                               title:@"修改备注"];
//                    
//                    
//                    _curInputCell.leftUtilityButtons = leftUtilityButtons;
//                }
                
                listCell.input.enabled = true;
                listCell.input.hidden = false;
                [listCell.input becomeFirstResponder];
                
                // Add utility buttons
                NSMutableArray *leftUtilityButtons = [NSMutableArray new];
                
                
                [leftUtilityButtons sw_addUtilityButtonWithColor:
                 [UIColor colorWithRed:1.0f green:1.0f blue:0.75f alpha:0.7]
                                                           title:@"保存保存"];
                
                
                listCell.leftUtilityButtons = leftUtilityButtons;
                
                _curInputCell = listCell;
            }

            break;
        }
        default:
            break;
    }
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
                 }
        case 1:
        {
       
        }
        default:
            break;
    }
}


static bool _delShow = false;
static bool _changeShow = false;
static SWTableViewCell* _curSWCell;
-(void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell{
    
    _curSWCell = cell;
    if ( cell.cellState == kCellStateLeft) {
        _delShow = false;
        _changeShow = true;
    }else if( cell.cellState == kCellStateRight){
        
        _delShow = true;
        _changeShow = false;
        
    }else{
        
        _delShow = false;
        _changeShow = false;
    }
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    if ([self.topVC hasInput] == true) {
        return false;
    }
    
    if (self.cellState != kCellStateCenter) {
        return false;
    }
    
    if (cell != _curSWCell) {
        return true;
    }
    switch (state) {
        case kCellStateLeft:
            // set to NO to disable all left utility buttons appearing
            return _delShow == false ? true : false;
            break;
        case kCellStateRight:
            // set to NO to disable all right utility buttons appearing
            return false;
            break;
        default:
            break;
    }
    
    return YES;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    if (self.topVC) {
        [self.topVC willShowLeft:self];
    }
    
    return YES;
}


- (BOOL) isallInCenter{

    for (XAILightListVCChildCell* cell in _cells){
        if ([cell isUtilityButtonsHidden] == false) {
            return false;
        }
    }
    
    return true;
}

- (void) hidenAll{

    for (XAILightListVCChildCell* cell in _cells){
        [cell hideUtilityButtonsAnimated:true];
    }
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 63.0;
}


@end

