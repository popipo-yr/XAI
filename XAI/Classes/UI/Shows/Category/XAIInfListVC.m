//
//  XAIInfListVC.m
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIInfListVC.h"

#import "XAIInfListCell.h"
#import "XAIObjectGenerate.h"

#define _ST_InfListVCID @"XAIInfListVCID"

@implementation XAIInfListVC

+(UIViewController*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_InfListVCID];
    [vc changeIphoneStatus];
    return vc;
    
}


- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        // Custom initialization
        
        _deviceService = [[XAIDeviceService alloc] init];
        _deviceService.apsn = [MQTT shareMQTT].apsn;
        _deviceService.luid = MQTTCover_LUID_Server_03;
        _deviceService.deviceServiceDelegate = self;
        
        _types = @[@(XAIObjectType_IR)];
        _deviceDatas = [[NSMutableArray alloc] init];
        _delInfo = [[NSMutableDictionary alloc] init];
        
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
    
    _deviceService.deviceServiceDelegate = nil;
    [_deviceService willRemove];
    _deviceService = nil;
    //_activityView = nil;
    
    for (XAIObject * obj in _deviceDatas) {
        if ([obj isKindOfClass:[XAIIR  class]]){
            ((XAIIR*)obj).delegate = nil;
        }
    }
    
    _deviceDatas = nil;
    
}

-(void)xaiDataRefresh:(XAIData *)data{
    
     if ([_delInfo count] > 0) return;
    
    [self updateShowDatas];
    [self.tableView reloadData];
}

-(void)reloginRefresh{

    if ([_delInfo count] > 0) return;
    
    [self updateShowDatas];
    [self.tableView reloadData];

}


- (void) updateShowDatas{
    
    _curInputCell = nil;
    
    
    
    _deviceDatas =  [[NSMutableArray alloc] initWithArray:
                     [[XAIData shareData] listenObjsWithType:_types]];
    
    
    
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
    
    
    [self setSeparatorStyle:[_deviceDatas count]];
    
    return [_deviceDatas count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = XAIInfListCellID;
    
    XAIInfListCell *cell = [tableView
                            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XAIInfListCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    XAIObject* aObj = [_deviceDatas objectAtIndex:[indexPath row]];
    
    if (aObj != nil &&
        [aObj isKindOfClass:[XAIIR class]] &&
        [[MQTT shareMQTT].curUser isAdmin]) {
        
        [cell setInfo:aObj];
    }
    
    
    [cell setEditBtn];
    [cell setDelBtn];
    cell.delegate = self;
    
    return cell;
    
    
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    
    //NSLog(@"%d",state);
    return;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            
            XAIInfListCell* listCell = (XAIInfListCell*)cell;
            if ([listCell isKindOfClass:[XAIInfListCell class]]) {
                
                
                if ([self isSame:listCell]) {
                    if (_curInputTF.text == nil || [_curInputTF.text isEqualToString:@""]) {
                        
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:NSLocalizedString(@"DevNickNameNull", nil)
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                                              otherButtonTitles:nil];
                        
                        
                        [alert show];
                        return;
                        
                    }
                    
                    int index = [[self.tableView indexPathForCell:cell] row];
                    if (index >= [_deviceDatas count]) {
                        return;
                    }
                    XAIObject* obj = [_deviceDatas objectAtIndex:index];
                    
                    obj.nickName = _curInputTF.text;
                    
                    [[XAIData shareData] upDateObj:obj];
                    
                    listCell.nameLable.text = _curInputTF.text;
                    
                    
                    [self hiddenOldInput];
                    return;
                }
                
                
                
                [self changeInputCell:listCell input:listCell.input];
                
                listCell.input.enabled = true;
                listCell.input.hidden = false;
                [listCell.input becomeFirstResponder];
                
                
                [listCell setSaveBtn];
                
                _curInputCell = listCell;
                _curInputTF = listCell.input;
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
            do {
                NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
                if ([indexPath row] < 0 || [indexPath row] >= [_deviceDatas count]) break;
                
                XAIObject* obj = [_deviceDatas objectAtIndex:[indexPath row]];
                if (![obj isKindOfClass:[XAIObject class]]) break;
                
                
                [obj startOpr];
                obj.curOprtip = @"正在删除";
                [((XAIInfListCell*)cell) showOprStart:obj.curOprtip];
                
                int delID = [_deviceService delDev:obj.luid];
                [_delInfo setObject:obj forKey:[NSNumber numberWithInt:delID]];
                
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
    
    if ([[_deviceDatas objectAtIndex:[indexPath row]] isKindOfClass:[NSArray class]]) {
        return  63.0*2;
    };
    
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
    for (XAIInfListCell* aCell in cells) {
        if (![aCell isKindOfClass:[XAIInfListCell class]]) continue;
        
        [aCell setEnable:status];
        
    }
    
    
}


-(void)devService:(XAIDeviceService *)devService delDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode otherID:(int)otherID{
    
    if (devService != _deviceService) return;
    
    
    XAIObject* obj = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (obj != nil && [obj isKindOfClass:[XAIObject class]]) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        if (isSuccess) {
            [obj endOpr];
        }else{
            [obj showMsg];
            obj.curOprtip = @"删除失败";
        }
        
        if ([obj isKindOfClass:[XAIIR class]]) {
            
            
            do {
                
                XAIInfListCell* cell = (XAIInfListCell*)((XAIIR*)obj).delegate;
                
                if (cell == nil) break;
                if (![cell isKindOfClass:[XAIInfListCell class]])break;
                
                if (!isSuccess) {
                    
                    [cell showMsg:obj.curOprtip];
                }else{
                    [cell showOprEnd];
                    
                    [_deviceDatas removeObject:obj];
                    
                    NSArray* ary = [NSArray arrayWithObject:[self.tableView indexPathForCell:cell]];
                    
                    [self.tableView  deleteRowsAtIndexPaths:ary
                                           withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
                
                
            } while (0);
            
        }
        
        
    }
    
}


@end
