//
//  XAILightListVC.m
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILightListVC.h"
#import "XAISwitchBtn.h"

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
        _deviceDatasNoManage = [[NSMutableArray alloc] init];
        
        _delInfo = [[NSMutableDictionary alloc] init];
        _cell2Infos = [[NSMutableDictionary alloc] init];
        _delAnimalIDs = [[NSMutableArray alloc] init];
        _canDel = true;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _curInputCell = nil;
    // Do any additional setup after loading the view.
    
    _gEditing = false;
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
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
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

    
    NSMutableArray* allLights =  [[NSMutableArray alloc] initWithArray:
                           [[XAIData shareData] listenObjsWithType:_types]];
    
//    for (int i = 0; i < 10; i++) {
//        XAILight2_CirculeOne* one1 = [[XAILight2_CirculeOne alloc] init];
//    
//        one1.name  = [NSString stringWithFormat:@"name%d",i];
//
//        [allLights addObject:one1];
//    }
    

    

    
    [_deviceDatasNoManage removeAllObjects];
    [_deviceDatasNoManage addObjectsFromArray:allLights];
    

    [self manageShowDatas];
    
    self.tipImgView.hidden = [_deviceDatas count] == 0 ? false : true;

}

-(void)manageShowDatas{

    NSMutableArray* newDatas = [[NSMutableArray alloc] init];
    
    NSMutableArray* circleOnes = [[NSMutableArray alloc] init];
    NSMutableArray* circleTwos = [[NSMutableArray alloc] init];
    
    
    NSMutableArray* allLights =  [[NSMutableArray alloc] initWithArray:
                                  _deviceDatasNoManage];
    
    
    
    NSMutableArray* onlyOne = [[NSMutableArray alloc] init];
    //分类并添加单控开关
    for (XAIObject* obj in allLights) {
        
        if (![obj isKindOfClass:[XAILight class]]) continue;
        
        if ([obj isKindOfClass:[XAILight2_CirculeOne class]]) {
            
            [circleOnes addObject:obj];
            
            
        }else if ([obj isKindOfClass:[XAILight2_CirculeTwo class]]){
            
            [circleTwos addObject:obj];
            
        }else{
            
            [onlyOne addObject:obj];
        }
    }
    
    NSMutableArray* noMatchOne = [[NSMutableArray alloc] init];
    //找到配皮的双控加入,并找出未匹配的单控一
    for (XAILight2_CirculeOne* aOne in circleOnes) {
        
        BOOL hasTogether = false;
        
        for (XAILight2_CirculeTwo* aTwo in circleTwos) {
            if (aOne.luid == aTwo.luid) {
                
                XAILightCellData* cellData = [[XAILightCellData alloc] init];
                [cellData setOne:aOne two:aTwo hasCon:true];
                [newDatas addObject:cellData];
                
                [circleTwos removeObject:aTwo];
                hasTogether = true;
                break;
            }
        }
        
        if (hasTogether == false) {//加入未匹配的单控一
            [noMatchOne addObject:aOne];
        }
    }
    
    //所有单控和未匹配的添加在一起
    NSMutableArray*  allOnlyOne = [[NSMutableArray alloc] init];
    [allOnlyOne addObjectsFromArray:onlyOne];
    [allOnlyOne addObjectsFromArray:noMatchOne];
    [allOnlyOne addObjectsFromArray:circleTwos];
    
    for (int i = 0; i < (int)[allOnlyOne count] - 1; i = i+2) {
        
        XAILight* one = [allOnlyOne objectAtIndex:i];
        XAILight* two = [allOnlyOne objectAtIndex:i+1];
        XAILightCellData* cellData = [[XAILightCellData alloc] init];
        [cellData setOne:one two:two hasCon:false];
        
        [newDatas addObject:cellData];
    }
    
    if ([allOnlyOne count] % 2 == 1) {
        XAILight* one = [allOnlyOne objectAtIndex:[allOnlyOne count] - 1];
        XAILightCellData* cellData = [[XAILightCellData alloc] init];
        [cellData setOne:one two:nil hasCon:false];
        [newDatas addObject:cellData];
    }
    
    _deviceDatas = [[NSMutableArray alloc] initWithArray:newDatas];

}

#pragma mark - actions
-(IBAction)globalEditClick:(id)sender{

    _gEditing = !_gEditing;
    
    if (_gEditing == false) {
    
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_nor.png"]
                   forState:UIControlStateNormal];
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_sel.png"]
                   forState:UIControlStateHighlighted];
    }else{
    
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_close_nor.png"]
                   forState:UIControlStateNormal];
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_close_sel.png"]
                   forState:UIControlStateHighlighted];
    }
    
    NSArray*  cells = [self.tableView visibleCells];
    
    for (XAILightListVCCellNew* aCell in cells) {
        if (![aCell isKindOfClass:[XAILightListVCCellNew class]]) continue;
        [aCell isEdit:_gEditing];
    }
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
    
    static NSString *CellIdentifier1 = XAILightListCellID;
    
    XAILightListVCCellNew* cell = [tableView
                                   dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    if (cell == nil) {
        cell = [XAILightListVCCellNew create:CellIdentifier1];
    }
    
    XAILightCellData* cellData = [_deviceDatas objectAtIndex:[indexPath row]];
    
    if ([cellData isKindOfClass:[XAILightCellData class]]) {
        
        [cell setInfoOne:cellData.oneLight two:cellData.twoLight hasCon:cellData.hasCon];
        
        [cell isEdit:_gEditing];
        cell.delegate = self;
        
        if (cell.hasMe != nil) {
            
            [_cell2Infos removeObjectForKey:cell.hasMe];
        }
        
        cell.hasMe = cellData;
        [_cell2Infos setObject:cell forKey:indexPath];
    }
    
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
                
                float least = self.view.frame.size.height - (self.tableView.frame.origin.y + cell.frame.origin.y - self.tableView.contentOffset.y + 60);
                float keyboardHeight =  250;
                float move = keyboardHeight - least;
                if (move > 0) {
        
                    
                    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                      self.tableView.frame.origin.y - move,
                                                      self.tableView.frame.size.width,
                                                      self.tableView.frame.size.height);
                }
                

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
    
    XSLog(@"end");
    
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
    
    XSLog(@"TOP...");
    
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
    
//    if ([[_deviceDatas objectAtIndex:[indexPath row]] isKindOfClass:[NSArray class]]) {
//        return  63.0*2;
//    };

    return 160.0;
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


#pragma mark  swith btn delegate
-(void)lightCell:(XAILightListVCCellNew *)cell lightBtnDelClick:(XAISwitchBtn *)btn{

    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if ([indexPath row] < 0 || [indexPath row] >= [_deviceDatas count]) return;
    
    XAILightCellData* cellData = [_deviceDatas objectAtIndex:[indexPath row]];
    if (![cellData isKindOfClass:[XAILightCellData class]]) return;
    
    if (cellData.hasCon == false) {//没有关联的
       
        XAIObject* obj = btn.weakLight;
        [obj startOpr];
        obj.curOprtip = @"正在删除";
        [btn showOprStart];
        
        int delID = [_deviceService delDev:obj.luid];
        
        
        XAILightListDelInfo* delInfo = [[XAILightListDelInfo alloc] init];
        delInfo.corObjs = [NSArray arrayWithObject:obj];
        delInfo.cellData = cellData;
        [_delInfo setObject:delInfo
                     forKey:[NSNumber numberWithInt:delID]];
        
    }else{
    
        

        [cellData.oneLight startOpr];
        cellData.oneLight.curOprtip = @"正在删除";
        [cellData.twoLight startOpr];
        cellData.twoLight.curOprtip = @"正在删除";
        
        [cell.oneBtn showOprStart];
        [cell.twoBtn showOprStart];
        
        
        int delID = [_deviceService delDev:cellData.oneLight.luid];
        XAILightListDelInfo* delInfo = [[XAILightListDelInfo alloc] init];
        delInfo.corObjs = [NSArray arrayWithObjects:cellData.oneLight,cellData.twoLight,nil];
        delInfo.cellData = cellData;
        [_delInfo setObject:delInfo
                     forKey:[NSNumber numberWithInt:delID]];
    }
    
    
    

}

-(void)lightCell:(XAILightListVCCellNew *)cell lightBtnEditClick:(XAISwitchBtn *)btn{

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
    
    [self moveTableViewToOld];
    [self.tableView setScrollEnabled:true];
}

- (BOOL) hasInput{

    return _curInputCell != nil;
}

- (BOOL) isSame:(SWTableViewCell*)cell{

    return _curInputCell == cell;
}



-(void)devService:(XAIDeviceService *)devService delDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode otherID:(int)otherID{
    
    if (devService != _deviceService) return;
    
    if (isSuccess) {
        
        [_delAnimalIDs addObject:[NSNumber numberWithInt:otherID]];
        
        [self realMove];
        return;
        
    }
    
    
    XAILightListDelInfo* delInfo = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (delInfo != nil ) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        for (XAIObject* obj in delInfo.corObjs) {
            
            if (![obj isKindOfClass:[XAILight class]]) continue;
            
            [obj showMsg];
            obj.curOprtip = @"删除失败";
            
            XAISwitchBtn* btn = (XAISwitchBtn*)((XAILight*)obj).delegate;
            
            if ((btn != nil)
                && [btn isKindOfClass:[XAISwitchBtn class]]) {
                
                [btn showMsg];
            }
        }
        
    }
    
}


- (void) realMove{
    
    if (_canDel == false) {
        return;
    }
    
    _canDel = false;
    
    int otherID = [[_delAnimalIDs objectAtIndex:0] intValue];
    
    [_delAnimalIDs removeObjectAtIndex:0];
    
    XAILightListDelInfo* delInfo = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (delInfo != nil && [delInfo isKindOfClass:[XAILightListDelInfo class]]) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        do {
            
            for (XAIObject* oneObj in delInfo.corObjs) {
                
                [oneObj endOpr];
            
                XAISwitchBtn* btn = (XAISwitchBtn*)((XAILight*)oneObj).delegate;
                
                if ((btn != nil)
                    && [btn isKindOfClass:[XAISwitchBtn class]]) {
                    
                    [btn showOprEnd];
                }
            }
            
            
            NSUInteger row = [_deviceDatas indexOfObject:delInfo.cellData];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row
                                                        inSection:0];
           ;
            XAILightListVCCellNew* cell = (XAILightListVCCellNew*)[_cell2Infos objectForKey:indexPath];
            
            if (cell == nil) break;
            if (![cell isKindOfClass:[XAILightListVCCellNew class]])break;
            
            
            if (delInfo.cellData.hasCon) { 
              
                [_deviceDatas  removeObject:delInfo.cellData];
                [_deviceDatasNoManage removeObject:delInfo.cellData.oneLight];
                [_deviceDatasNoManage removeObject:delInfo.cellData.twoLight];
                
                if (indexPath != nil) {
                    
                    NSArray* ary = [NSArray arrayWithObject:indexPath];
                    
                    [self.tableView  deleteRowsAtIndexPaths:ary
                                           withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                

            }else{

                [_deviceDatasNoManage removeObjectsInArray:delInfo.corObjs];
                [self manageShowDatas];
                [self.tableView reloadData];

            }
            
            
            
            
        } while (0);
        
        
    }
    
    [self performSelector:@selector(changeCanMove) withObject:nil afterDelay:1.5f];
    
}

- (void) changeCanMove{
    
    _canDel = true;
    
    if ([_delAnimalIDs count] > 0 ) {
        
        [self realMove];
    }
}



@end


@implementation XAILightCellData
-(void)setOne:(XAILight *)oneLight two:(XAILight*)twoLight hasCon:(BOOL)hasCon{

    _oneLight = oneLight;
    _twoLight = twoLight;
    _hasCon = hasCon;
}

@end

@implementation XAILightListDelInfo

@end
