//
//  XAIUserServerListVC.m
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUserServerListVC.h"

#import "XAIUserServerListCell.h"
#import "XAIObjectGenerate.h"

#define _ST_USListVCID @"XAIUserServerListVCID"

@implementation XAIUserServerListVC

+(UIViewController*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_USListVCID];
    [vc changeIphoneStatus];
    return vc;
    
}


- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        // Custom initialization
        
        _userServiece = [[XAIUserService alloc] init];
        _userServiece.apsn = [MQTT shareMQTT].apsn;
        _userServiece.luid = MQTTCover_LUID_Server_03;
        _userServiece.userServiceDelegate = self;

        _userDatas = [[NSMutableArray alloc] init];
        _delInfo = [[NSMutableDictionary alloc] init];
        _cellInfos = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _curInputCell = nil;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self updateShowDatas];
    [self.tableView reloadData];
    [[XAIData shareData] addRefreshDelegate:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[XAIData shareData] removeRefreshDelegate:self];
    [super viewDidDisappear:animated];
}

- (void) dealloc{
    
    _userServiece.userServiceDelegate = nil;
    [_userServiece willRemove];
    _userServiece = nil;
    //_activityView = nil;
    
//    for (XAIObject * obj in _userDatas) {
//        if ([obj isKindOfClass:[XAIIR  class]]){
//            ((XAIIR*)obj).delegate = nil;
//        }
//    }
    
    _userDatas = nil;
    
}

-(void)xaiDataRefresh:(XAIData *)data{
    
    [self updateShowDatas];
    [self.tableView reloadData];
}



- (void) updateShowDatas{
    
    _curInputCell = nil;
    
    
    
    _userDatas =  [[NSMutableArray alloc] initWithArray:
                     [[XAIData shareData] getUserList]];
    
    
    
    //    [_deviceDatas addObject:[[XAIIR alloc] init]];
    //    [_deviceDatas addObject:[[XAIIR alloc] init]];
    //    [_deviceDatas addObject:[[XAIIR alloc] init]];
    //    [_deviceDatas addObject:[[XAIIR alloc] init]];
    //    [_deviceDatas addObject:[[XAIIR alloc] init]];
    //    [_deviceDatas addObject:[[XAIIR alloc] init]];
    
}


#pragma mark Table Data Source Methods





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    [self setSeparatorStyle:[_userDatas count]];
    
    return [_userDatas count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = XAIUserServerListCellID;
    
    XAIUserServerListCell *cell = [tableView
                            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XAIUserServerListCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    XAIUser* aUser = [_userDatas objectAtIndex:[indexPath row]];
    
    if (aUser != nil && [aUser isKindOfClass:[XAIUser class]]) {
        
        [cell setInfo:aUser];
    }
    
    [cell setDelBtn];
    cell.delegate = self;
    
    
    if (cell.hasMe != nil) {
        
        [_cellInfos removeObjectForKey:cell.hasMe];
    }
    
    NSNumber* unique = [NSNumber numberWithLongLong:aUser.luid];
    cell.hasMe = unique;
    [_cellInfos setObject:cell forKey:unique];
    
    
    return cell;
    
    
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    
    //NSLog(@"%d",state);
    return;
}



- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            do {
                NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
                if ([indexPath row] < 0 || [indexPath row] >= [_userDatas count]) break;
                
                XAIUser* aUser = [_userDatas objectAtIndex:[indexPath row]];
                if (![aUser isKindOfClass:[XAIUser class]]) break;
                
                
                [aUser startOpr];
                aUser.curOprtip = @"正在删除";
                [((XAIUserServerListCell*)cell) showOprStart:aUser.curOprtip];
                
                int delID = [_userServiece delUser:aUser.luid];
                [_delInfo setObject:aUser forKey:[NSNumber numberWithInt:delID]];
                
                [cell hideUtilityButtonsAnimated:true];
                
                
            } while (0);
            
            
            
            break;
        }
        default:
            break;
    }
}


static bool delShow = false;
static bool changeShow = false;
static SWTableViewCell* curSWCell;
-(void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell{
    
    curSWCell = cell;
    if ( cell.cellState == kCellStateLeft) {
        delShow = false;
        changeShow = true;
        
    }else if( cell.cellState == kCellStateRight){
        
        delShow = true;
        changeShow = false;
        
    }else{
        
        delShow = false;
        changeShow = false;
    }
    
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    
    
    if ([self hasInput] == true) {
        
        if (cell.cellState == state) {
            return true;
        }
        
        return false;
    }
    
    
    if (cell != curSWCell) {
        return true;
    }
    switch (state) {
        case kCellStateLeft:
            // set to NO to disable all left utility buttons appearing
            return delShow == false ? true : false;
            break;
        case kCellStateRight:
            // set to NO to disable all right utility buttons appearing
            return changeShow == false ? true : false;
            break;
        default:
            break;
    }
    
    return YES;
}


- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    [self hiddenOldInput];
    
    return YES;
}

-(void)swipeableTableViewCellCancelEdit:(SWTableViewCell *)cell{
    
    [self hiddenOldInput];
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 63.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void) changeInputCell:(SWTableViewCell*)cell input:(UITextField*)input{
    
    [self hiddenOldInput];
    _curInputCell = cell;
    _curInputTF = input;
    //_curInputCell.stop = false;
    [_curInputCell setEnable:false];
    
    [self.tableView setScrollEnabled:false];
    //[cell setEnable:false];
}


- (void) hiddenOldInput{
    
    if (_curInputCell != nil) {
        
        
        [_curInputCell hideUtilityButtonsAnimated:true];
        
        
        [_curInputCell setEditBtn];
    }
    
    if (_curInputTF != nil) {
        
        _curInputTF.enabled = false;
        _curInputTF.hidden = true;
        [_curInputTF resignFirstResponder];
    }
    
    //_curInputCell.stop = true;
    [_curInputCell setEnable:true];
    _curInputCell = nil;
    _curInputTF = nil;
}

- (BOOL) hasInput{
    
    return _curInputCell != nil;
}

- (BOOL) isSame:(SWTableViewCell*)cell{
    
    return _curInputCell == cell;
}

- (void) enableAllCtrl:(BOOL)status{
    
    [self.tableView setScrollEnabled:status];
    
    NSArray* cells = [self.tableView visibleCells];
    for (XAIUserServerListCell* aCell in cells) {
        if (![aCell isKindOfClass:[XAIUserServerListCell class]]) continue;
        
        [aCell setEnable:status];
        
    }
    
    
}

-(void)userService:(XAIUserService *)userService delUser:(BOOL)isSuccess errcode:(XAI_ERROR)errcode
otherID:(int)otherID{

    
    if (userService != _userServiece) return;
    
    
    XAIUser* auser = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (auser != nil && [auser isKindOfClass:[XAIUser class]]) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        if (isSuccess) {
            [auser endOpr];
        }else{
            [auser showMsg];
            auser.curOprtip = @"删除失败";
        }
        
        
        
        do {
            
            id obj = [_cellInfos objectForKey:[NSNumber numberWithLongLong:auser.luid]];
            
            XAIUserServerListCell* cell = (XAIUserServerListCell*)obj;
            
            if (cell == nil) break;
            if (![cell isKindOfClass:[XAIUserServerListCell class]])break;
            
            if (!isSuccess) {
                
                [cell showMsg:auser.curOprtip];
            }else{
                [cell showOprEnd];
                
                [_userDatas removeObject:auser];
                
                NSArray* ary = [NSArray arrayWithObject:[self.tableView indexPathForCell:cell]];
                
                [self.tableView  deleteRowsAtIndexPaths:ary
                                       withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
            
            
        } while (0);
        
    }
    
}


@end
