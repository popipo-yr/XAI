//
//  XAILightListVC.m
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILightListVC.h"

#import "XAIObjectGenerate.h"

@interface XAILightListVC ()

@end

@implementation XAILightListVC

+(UIViewController*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_LightListVCID];
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
        
        _types = @[@(XAIObjectType_light),@(XAIObjectType_light2_1),@(XAIObjectType_light2_2)];
        _deviceDatas = [[NSMutableArray alloc] init];
        
        _delInfo = [[NSMutableDictionary alloc] init];
        _cell2Infos = [[NSMutableDictionary alloc] init];
        
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
    
    for (XAILight* light in _deviceDatas) {
        if (![light isKindOfClass:[XAILight class]]) continue;
        light.delegate = nil;
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
    
    NSMutableArray* newDatas = [[NSMutableArray alloc] init];
    
    NSMutableArray* circleOnes = [[NSMutableArray alloc] init];
    NSMutableArray* circleTwos = [[NSMutableArray alloc] init];
    
    
    NSArray* allLights =  [[NSArray alloc] initWithArray:
                           [[XAIData shareData] listenObjsWithType:_types]];
    
    //分类并添加单控开关
    for (XAIObject* obj in allLights) {

        if (![obj isKindOfClass:[XAILight class]]) continue;
        
        if ([obj isKindOfClass:[XAILight2_CirculeOne class]]) {
            
            [circleOnes addObject:obj];
            
            
        }else if ([obj isKindOfClass:[XAILight2_CirculeTwo class]]){
        
            [circleTwos addObject:obj];
        
        }else{
        
            [newDatas addObject:obj];
        }
    }
    
    //找到配皮的双控加入,并加入未匹配的单控一
    for (XAILight2_CirculeOne* aOne in circleOnes) {
        
        BOOL hasTogether = false;
        
        for (XAILight2_CirculeTwo* aTwo in circleTwos) {
            if (aOne.luid == aTwo.luid) {
                
                NSArray* together = [[NSArray alloc] initWithObjects:aOne,aTwo,nil];
                [newDatas addObject:together];
                
                [circleTwos removeObject:aTwo];
                hasTogether = true;
                break;
            }
        }
        
        if (hasTogether == false) {
            [newDatas addObject:aOne];
        }
    }
    
    //加入未匹配的单控二
    [newDatas addObjectsFromArray:circleTwos];


    ////////////////
//    [newDatas addObject:[[XAILight alloc] init]];
//    
//    NSArray* ary = [[NSArray alloc] initWithObjects:[[XAILight2_CirculeOne alloc]init],
//                    [[XAILight2_CirculeTwo alloc] init],nil];
//    [newDatas addObject:ary];
//
//    [newDatas addObject:[[XAILight alloc] init]];
//    
//    
//    NSArray* ary2 = [[NSArray alloc] initWithObjects:[[XAILight2_CirculeOne alloc]init],
//                    [[XAILight2_CirculeTwo alloc] init],nil];
//    [newDatas addObject:ary2];
//    [newDatas addObject:[[XAILight alloc] init]];
//    [newDatas addObject:[[XAILight alloc] init]];
//    [newDatas addObject:[[XAILight alloc] init]];
    
    _deviceDatas = [[NSMutableArray alloc] initWithArray:newDatas];

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
    
    static NSString *CellIdentifier1 = XAILightListCell2ID;
    static NSString *CellIdentifier2 = XAILightListCellID;
    
    NSArray* objs = [_deviceDatas objectAtIndex:[indexPath row]];
    
    if ([objs isKindOfClass:[NSArray class]]) {
        
        XAILightListVCCell2 *cell = [tableView
                                    dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[XAILightListVCCell2 alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier1];
        }
        
        
        [cell setDatas:objs];
        
        [cell setDelBtn];
        
        cell.delegate = self;
        
        cell.topVC = self;
        
        if (cell.hasMe != nil) {
            
            [_cell2Infos removeObjectForKey:cell.hasMe];
        }
        
        cell.hasMe = objs;
        [_cell2Infos setObject:cell forKey:objs];
        
        return cell;
        
    }
    
    XAILightListVCCell *cell = [tableView
                                dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell == nil) {
        cell = [[XAILightListVCCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier2];
    }
    
    XAILight* aObj = [_deviceDatas objectAtIndex:[indexPath row]];
    
    if (aObj != nil && [aObj isKindOfClass:[XAILight class]]) {
        
        [cell setInfo:aObj];
    
    }
    
    
    [cell setDelBtn];
    [cell setEditBtn];
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
            
            XAILightListVCCell* listCell = (XAILightListVCCell*)cell;
            if ([listCell isKindOfClass:[XAILightListVCCell class]]) {
                
                
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
                if ([obj isKindOfClass:[XAIObject class]]){
                
                    
                    [obj startOpr];
                    obj.curOprtip = @"正在删除";
                    [((XAILightListVCCell*)cell) showOprStart:obj.curOprtip];
                    
                    int delID = [_deviceService delDev:obj.luid];
                    [_delInfo setObject:obj forKey:[NSNumber numberWithInt:delID]];
                
                }else if([obj isKindOfClass:[NSArray class]]){
                
                    XAITYPELUID luid = 0;
                    
                    NSArray* objs = (NSArray*)obj;
                    for (XAIObject* oneObj in objs) {
                        
                        [oneObj startOpr];
                        oneObj.curOprtip = @"正在删除";
                        
                        [((XAILightListVCCell2*)cell) refreshOpr];
                        
                        luid = oneObj.luid;
                        
                    }
                
                
                    int delID = [_deviceService delDev:luid];
                    [_delInfo setObject:objs forKey:[NSNumber numberWithInt:delID]];
                }
                

                
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
    
    NSLog(@"end");
    
    curSWCell = cell;
    if ( cell.cellState == kCellStateLeft) {
        delShow = false;
        changeShow = true;
        
    }else if( cell.cellState == kCellStateRight){
        
        delShow = true;
        changeShow = false;
        
        if ([cell isKindOfClass:[XAILightListVCCell2 class]]) {
            [(XAILightListVCCell2*)cell enableChild:false];
        }
        
    }else{
        
        delShow = false;
        changeShow = false;
        
        if ([cell isKindOfClass:[XAILightListVCCell2 class]]) {
            [(XAILightListVCCell2*)cell enableChild:true];
        }
    }
    
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    
    NSLog(@"TOP...");
    
    if ([self hasInput] == true) {
        
        if (cell.cellState == state) {
            return true;
        }

        return false;
    }
    
    if ([cell isKindOfClass:[XAILightListVCCell2 class]]) {
        
        if ([((XAILightListVCCell2*)cell) isallInCenter] == false) {
            return false;
        }
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
    
    NSArray* cells = [self.tableView visibleCells];
    for (XAILightListVCCell2* aCell in cells) {
        if (![aCell isKindOfClass:[XAILightListVCCell2 class]]) continue;
        if (aCell == cell) continue;
        
        [aCell hidenAll];
        
    }

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
    
    do {
        
        if ([indexPath row] >= [_deviceDatas count]) break;
        
        XAILight* aLight = [_deviceDatas objectAtIndex:[indexPath row]];
        if (![aLight isKindOfClass:[XAILight class]]) break;
        
        XAILightListVCCell* cell = (XAILightListVCCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (![cell isKindOfClass:[XAILightListVCCell class]]) break;
        
        
        if(aLight.curDevStatus == XAILightStatus_Open){
        
            [aLight closeLight];
            [cell showOprStart:aLight.curOprtip];

            
       }else if(aLight.curDevStatus == XAILightStatus_Close){
            
            [aLight openLight];
            [cell showOprStart:aLight.curOprtip];
        }
    
//        [aLight closeLight];
//        [cell showOprStart:aLight.curOprtip];
        
    } while (0);
    
    
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void) willShowLeft:(UITableViewCell*)cell{
    
    [self hiddenOldInput];
    
    NSArray* cells = [self.tableView visibleCells];
    for (SWTableViewCell* aCell in cells) {
        if (![aCell isKindOfClass:[SWTableViewCell class]]) continue;
        if (aCell == cell) continue;
        
        if ([aCell isUtilityButtonsHidden] == false) {
            
            [aCell hideUtilityButtonsAnimated:YES];

        }
        
        if ([aCell isKindOfClass:[XAILightListVCCell2 class]]) {
            [((XAILightListVCCell2*)aCell) hidenAll];
        }
        
        
    }


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



-(void)devService:(XAIDeviceService *)devService delDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode otherID:(int)otherID{
    
    if (devService != _deviceService) return;
    
    
    XAIObject* obj = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (obj != nil ) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        
        if ([obj isKindOfClass:[XAILight class]]) {
            
            
            if (isSuccess) {
                [obj endOpr];
            }else{
                [obj showMsg];
                obj.curOprtip = @"删除失败";
            }

            
            do {
                
                XAILightListVCCell* cell = (XAILightListVCCell*)((XAILight*)obj).delegate;
                
                if (cell == nil) break;
                if (![cell isKindOfClass:[XAILightListVCCell class]])break;
                
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
            
        }else if([obj isKindOfClass:[NSArray class]]){
            
            do {
                
                NSArray* objs = (NSArray*)obj;
                
                if (isSuccess) {
                    
                    for (XAIObject* oneObj in objs) {
                        
                        [oneObj endOpr];
                    }

                }else{
                    
                    
                    for (XAIObject* oneObj in objs) {
                        
                        [oneObj showMsg];
                        oneObj.curOprtip = @"删除失败";
                        
                    }
                }

                
                XAILightListVCCell2* cell = (XAILightListVCCell2*)[_cell2Infos objectForKey:objs];
                
                if (cell == nil) break;
                if (![cell isKindOfClass:[XAILightListVCCell2 class]])break;
                
                
                
                if (!isSuccess) {
                    
                    [cell refreshOpr];
                }else{
                    [cell refreshOpr];
                    
                    [_deviceDatas removeObject:objs];
                    
                    NSArray* ary = [NSArray arrayWithObject:[self.tableView indexPathForCell:cell]];
                    
                    [self.tableView  deleteRowsAtIndexPaths:ary
                                           withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
                
                
            } while (0);

        }
        
        
    }
    
}




@end


