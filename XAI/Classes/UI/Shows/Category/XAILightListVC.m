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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    _deviceDatas = nil;
    
}

-(void)xaiDataRefresh:(XAIData *)data{
    
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


    [newDatas removeAllObjects];
    [newDatas addObject:[[XAILight alloc] init]];
    
    NSArray* ary = [[NSArray alloc] initWithObjects:[[XAILight2_CirculeOne alloc]init],
                    [[XAILight2_CirculeTwo alloc] init],nil];
    [newDatas addObject:ary];

    [newDatas addObject:[[XAILight alloc] init]];
    
    
    NSArray* ary2 = [[NSArray alloc] initWithObjects:[[XAILight2_CirculeOne alloc]init],
                    [[XAILight2_CirculeTwo alloc] init],nil];
    [newDatas addObject:ary2];
    
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
    
    static NSString *CellIdentifier1 = @"XAILightListCell2ID";
    static NSString *CellIdentifier2 = @"XAILightListCellID";
    
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
        
      
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                    title:@"删除"];
        
        cell.rightUtilityButtons = rightUtilityButtons;
        cell.delegate = self;
        
        cell.topVC = self;
        
        return cell;
        
    }
    
    XAILightListVCCell *cell = [tableView
                                dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell == nil) {
        cell = [[XAILightListVCCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier2];
    }
    
    XAIObject* aObj = [_deviceDatas objectAtIndex:[indexPath row]];
    
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
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                               title:@"修改备注"];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    cell.leftUtilityButtons = leftUtilityButtons;
    cell.rightUtilityButtons = rightUtilityButtons;
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
                
                
                [self changeInputCell:listCell input:listCell.input];
                
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

            break;
        }
        case 1:
        {

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



#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[_deviceDatas objectAtIndex:[indexPath row]] isKindOfClass:[NSArray class]]) {
        return  63.0*2;
    };

    return 63.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    if ([indexPath row] < [_deviceDatas count]) {
//        
//        XAIObject* obj = [_deviceDatas objectAtIndex:[indexPath row]];
//        
//        [self.navigationController pushViewController:
//         [XAIDevShowStatusVCGenerate statusWithObject:obj storyboard:self.storyboard] animated:YES];
//        
//    }
    
    
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
    
    [self.tableView setScrollEnabled:false];
    //[cell setEnable:false];
}


- (void) hiddenOldInput{

    if (_curInputCell != nil) {
        
        
        [_curInputCell hideUtilityButtonsAnimated:true];
        
        // Add utility buttons
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        
        
        [leftUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                   title:@"修改备注"];
        
        _curInputCell.leftUtilityButtons = leftUtilityButtons;
    }
    
    if (_curInputTF != nil) {
        
        _curInputTF.enabled = false;
        _curInputTF.hidden = true;
        [_curInputTF resignFirstResponder];
    }

    _curInputCell = nil;
    _curInputTF = nil;
}

- (BOOL) hasInput{

    return _curInputCell != nil;
}

@end


