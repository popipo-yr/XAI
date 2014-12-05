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
        _gEditing = false;
        _bFade = false;
        
        _cell2Purge = [[NSMutableDictionary alloc] init];
        _linkageHelps = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[MQTT shareMQTT].curUser isAdmin]) {
        _gEditBtn.hidden = true;
        _gEditBtn.enabled = false;
    }
    
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

    
    NSMutableArray* allLights =  [[NSMutableArray alloc] initWithArray:
                           [[XAIData shareData] listenObjsWithType:_types]];
    
//    for (int i = 0; i < 10; i++) {
//        XAILight2_CirculeOne* one1 = [[XAILight2_CirculeOne alloc] init];
//    
//        one1.name  = [NSString stringWithFormat:@"name%d",i];
//
//        [allLights addObject:one1];
//    }
//    
//    for (int i = 0; i < 2; i++) {
//        XAILight2_CirculeOne* one1 = [[XAILight2_CirculeOne alloc] init];
//        XAILight2_CirculeTwo* one2 = [[XAILight2_CirculeTwo alloc] init];
//        
//        one1.name  = [NSString stringWithFormat:@"name%d",i];
//        one2.name  = [NSString stringWithFormat:@"name%d",i];
//        
//        one1.luid = i+3;
//        one2.luid = i+3;
//        
//        [allLights addObject:one1];
//        [allLights addObject:one2];
//    }


    [_deviceDatasNoManage removeAllObjects];
    [_deviceDatasNoManage addObjectsFromArray:allLights];
    

    [self manageShowDatas];
    
    self.tipImgView.hidden = [_deviceDatas count] == 0 ? false : true;
    
    [self lightFireCount];

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
    
//    for (int i = 0; i < (int)[allOnlyOne count] - 1; i = i+2) {
//        
//        XAILight* one = [allOnlyOne objectAtIndex:i];
//        XAILight* two = [allOnlyOne objectAtIndex:i+1];
//        XAILightCellData* cellData = [[XAILightCellData alloc] init];
//        [cellData setOne:one two:two hasCon:false];
//        
//        [newDatas addObject:cellData];
//    }
//    
//    if ([allOnlyOne count] % 2 == 1) {
//        XAILight* one = [allOnlyOne objectAtIndex:[allOnlyOne count] - 1];
//        XAILightCellData* cellData = [[XAILightCellData alloc] init];
//        [cellData setOne:one two:nil hasCon:false];
//        [newDatas addObject:cellData];
//    }

    
    for (int i = 0; i < [allOnlyOne count]; i++) {
        
        XAILight* one = [allOnlyOne objectAtIndex:i];
        XAILightCellData* cellData = [[XAILightCellData alloc] init];
        [cellData setOne:one two:nil hasCon:false];
        
        [newDatas addObject:cellData];
    }

    _deviceDatas = [[NSMutableArray alloc] initWithArray:newDatas];

}

-(void) lightFireCount{

    int count = 0;
    
    for (XAILight* aLight in _deviceDatasNoManage) {
    
        if (aLight.isOnline && aLight.curDevStatus == XAILightStatus_Open) {
            
            count += 1;
            break;
        }
    }
   
    if (count > 0) {
        
        
        _gStatusImgView.image = [UIImage imageWithFile:@"switch_tbg_open.png"];

    }else{
        
        _gStatusImgView.image = [UIImage imageWithFile:@"switch_tbg.png"];

    }
    
}

#pragma mark - actions
-(IBAction)globalEditClick:(id)sender{

    _gEditing = !_gEditing;
    
    if (_gEditing == false) {
    
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_nor.png"]
                   forState:UIControlStateNormal];
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_sel.png"]
                   forState:UIControlStateHighlighted];
        
        [self bgGetClick:nil]; //如果有 关闭不需要的
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

-(void)bgGetClick:(id)sender{

    [self endEditOne:_curEditBtn];
    
}


-(void)endEditOne:(XAISwitchBtn*)btn{

    [_curEditBtn.nameTF resignFirstResponder];
    _curEditBtn = nil;
}


#pragma mark  light 

-(void) startFadeAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endFadeAnimation)];
    self.gStatusImgView.alpha = _fade;
    [UIView commitAnimations];
}

-(void)endFadeAnimation{
    
    if (_bFade) {
        
        if (_fade < 0) {
            _fade  = 0;
            _bDelFade = false;
        }else if(_fade > 1){
            _fade = 1;
            _bDelFade = true;
        }
        
        if (_bDelFade) {
            _fade -= 0.1;
        }else{
            _fade += 0.2;
        }
        
        [self startFadeAnimation];
        
    }else{
        
        _fade = 1;
        _bDelFade = true;
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
    
    static NSString *CellIdentifier1 = @"XAILightListCellID";
    
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
        

        [cell setOnlyNeedCenter:cellData.twoLight == nil];
    }
    
    return cell;
    
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 140.0;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark  swith btn delegate


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSNumber* key = [NSNumber numberWithUnsignedLong:alertView.tag];
    
    XAILightListDelInfo* info = [_cell2Purge objectForKey:key];

    if (info == nil) return;
    
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        
        if ([info.corObjs count] > 0) {
            
            XAIObject* obj = [info.corObjs objectAtIndex:0];
            int delID = [_deviceService delDev:obj.luid];
            
            [_delInfo setObject:info
                         forKey:[NSNumber numberWithInt:delID]];
            
            [_cell2Purge removeObjectForKey:key];
        }
        
    }else{
        
        
        for (XAIObject* obj in info.corObjs) {
            
            [obj endOpr];
            
            XAISwitchBtn* btn = (XAISwitchBtn*)((XAILight*)obj).delegate;
            if ((btn != nil)
                && [btn isKindOfClass:[XAISwitchBtn class]]) {
                
                [btn showOprEnd];
            }

        }
       
    }
    
}

-(void)linkageServiceHelp:(XAILinkageServiceHelp *)service purgeDev:(XAIDevice *)aDev beHas:(BOOL)bHas err:(XAI_ERROR)errcode{
    
    NSNumber* key = [NSNumber numberWithUnsignedLong:aDev.luid];
    XAILightListDelInfo* info = [_cell2Purge objectForKey:key];
    
    if (errcode == XAI_ERROR_NONE) {
        
        if (bHas == false) {
            
            if (info != nil && [info.corObjs count] > 0) {
                
                XAIObject* obj = [info.corObjs objectAtIndex:0];
                int delID = [_deviceService delDev:obj.luid];
                
                [_delInfo setObject:info
                             forKey:[NSNumber numberWithInt:delID]];
                
                [_cell2Purge removeObjectForKey:key];
            }
        }else{
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"设备关联了联动信息,如果删除联动会失效"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消删除"
                                                  otherButtonTitles:@"确认删除", nil];
            alert.tag = aDev.luid;
            
            [alert show];
        }
        
        
    }else{
    
        for (XAIObject* obj in info.corObjs) {
            
            [obj endOpr];
            
            XAISwitchBtn* btn = (XAISwitchBtn*)((XAILight*)obj).delegate;
            if ((btn != nil)
                && [btn isKindOfClass:[XAISwitchBtn class]]) {
                
                [btn showOprEnd];
            }
            
        }
    }
    
    [_linkageHelps removeObject:service];
}



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
        
//        int delID = [_deviceService delDev:obj.luid];
//        
//        
//        XAILightListDelInfo* delInfo = [[XAILightListDelInfo alloc] init];
//        delInfo.corObjs = [NSArray arrayWithObject:obj];
//        delInfo.cellData = cellData;
//        [_delInfo setObject:delInfo
//                     forKey:[NSNumber numberWithInt:delID]];
        
        XAILinkageServiceHelp* aHelp = [[XAILinkageServiceHelp alloc] init];
        aHelp.delegate = self;
        
        XAILightListDelInfo* delInfo = [[XAILightListDelInfo alloc] init];
        delInfo.corObjs = [NSArray arrayWithObject:obj];
        delInfo.cellData = cellData;
        
        [_cell2Purge setObject:delInfo
                        forKey:[NSNumber numberWithUnsignedLong:obj.curDevice.luid]];
        
        [_linkageHelps addObject:aHelp];
        [aHelp  purgeHasDev:obj.curDevice];

        
    }else{
    
        

        [cellData.oneLight startOpr];
        cellData.oneLight.curOprtip = @"正在删除";
        [cellData.twoLight startOpr];
        cellData.twoLight.curOprtip = @"正在删除";
        
        [cell.oneBtn showOprStart];
        [cell.twoBtn showOprStart];
        
        
//        int delID = [_deviceService delDev:cellData.oneLight.luid];
//        XAILightListDelInfo* delInfo = [[XAILightListDelInfo alloc] init];
//        delInfo.corObjs = [NSArray arrayWithObjects:cellData.oneLight,cellData.twoLight,nil];
//        delInfo.cellData = cellData;
//        [_delInfo setObject:delInfo
//                     forKey:[NSNumber numberWithInt:delID]];
        
        
        XAILinkageServiceHelp* aHelp = [[XAILinkageServiceHelp alloc] init];
        aHelp.delegate = self;
        
        XAILightListDelInfo* delInfo = [[XAILightListDelInfo alloc] init];
        delInfo.corObjs = [NSArray arrayWithObjects:cellData.oneLight,cellData.twoLight,nil];
        delInfo.cellData = cellData;
        
        [_cell2Purge setObject:delInfo
                        forKey:[NSNumber numberWithUnsignedLong:cellData.oneLight.curDevice.luid]];
        
        [_linkageHelps addObject:aHelp];
        [aHelp  purgeHasDev:cellData.oneLight.curDevice];

    }
    
    
    

}


NSInteger  prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY;
-(void)lightCell:(XAILightListVCCellNew *)cell lightBtnEditClick:(XAISwitchBtn *)btn{

    self.tableView.userInteractionEnabled = false;
    _curEditBtn = btn;
    
    
    CGPoint Point =  [btn convertPoint:btn.nameTF.frame.origin toView:self.view];
    
    float textY = Point.y;
    float bottomY = self.view.frame.size.height-textY;
    float keyboardHeight = 240 + 64;
    if(bottomY>=keyboardHeight)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
    {

        return;
    }
    prewTag = btn.tag;
    float moveY = keyboardHeight-bottomY;
    prewMoveY = moveY + prewMoveY;
    
    NSTimeInterval animationDuration = 1.0f;
    CGRect frame = self.tableView.frame;
    frame.origin.y -=moveY;//view的Y轴上移
    self.tableView.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.tableView.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果

}

-(void)lightCell:(XAILightListVCCellNew *)cell lightBtnEditEnd:(XAISwitchBtn *)btn{

    self.tableView.userInteractionEnabled = true;
    _curEditBtn = nil;
    
    
    if(prewTag == -1) //当编辑的View不是需要移动的View
    {
        return;
    }
    float moveY ;
    NSTimeInterval animationDuration = 1.0f;
    CGRect frame = self.tableView.frame;
    if(prewTag == btn.tag) //当结束编辑的View的TAG是上次的就移动
    {   //还原界面
        moveY =  prewMoveY;
        frame.origin.y +=moveY;
        self.tableView.frame = frame;
        
        prewMoveY = 0;
    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.tableView.frame = frame;
    [UIView commitAnimations];
}

-(void)lightCell:(XAILightListVCCellNew *)cell lightBtnStatusChange:(XAISwitchBtn *)btn{

    [self lightFireCount];
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
