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
#import "XAIDevHistoryVC.h"

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
        _delAnimalIDs = [[NSMutableArray alloc] init];
        _canDel = true;
        _gEditBtn = false;
        
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
    
    
    _deviceDatasNoManage =  [[NSMutableArray alloc] initWithArray:
                     [[XAIData shareData] listenObjsWithType:_types]];
    
    
    
    
//    [_deviceDatas addObject:[[XAIIR alloc] init]];
//    [_deviceDatas addObject:[[XAIIR alloc] init]];
//    [_deviceDatas addObject:[[XAIIR alloc] init]];
//    [_deviceDatas addObject:[[XAIIR alloc] init]];
//    [_deviceDatas addObject:[[XAIIR alloc] init]];
//    [_deviceDatas addObject:[[XAIIR alloc] init]];
    
    
    [self manageShowDatas];
    self.tipImgView.hidden = [_deviceDatas count] == 0 ? false : true;
    
}

-(void)manageShowDatas{
    
    NSMutableArray* newDatas = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_deviceDatasNoManage count]; i++) {
        XAILight* one = [_deviceDatasNoManage objectAtIndex:i];
        XAIInfListCellData* cellData = [[XAIInfListCellData alloc] init];
        [cellData setOne:one];
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
        
        [self bgGetClick:nil]; //如果有 关闭不需要的
    }else{
        
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_close_nor.png"]
                   forState:UIControlStateNormal];
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_close_sel.png"]
                   forState:UIControlStateHighlighted];
    }
    
    NSArray*  cells = [self.tableView visibleCells];
    
    for (XAIInfListCell* aCell in cells) {
        if (![aCell isKindOfClass:[XAIInfListCell class]]) continue;
        [aCell isEdit:_gEditing];
    }
}

-(void)bgGetClick:(id)sender{
    
    [self endEditOne:_curEditBtn];
    
}


-(void)endEditOne:(XAIInfBtn*)btn{
    
    [_curEditBtn.nameTF resignFirstResponder];
    _curEditBtn = nil;
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
        cell = [XAIInfListCell create:CellIdentifier];
    }
    
    XAIInfListCellData* cellData = [_deviceDatas objectAtIndex:[indexPath row]];
    
    if ([cellData isKindOfClass:[XAIInfListCellData class]]) {
        
        [cell setInfo:cellData.oneObj];
        
        [cell isEdit:_gEditing];
        cell.delegate = self;
        
        if (cell.hasMe != nil) {
            
            [_cell2Infos removeObjectForKey:cell.hasMe];
        }
        
        cell.hasMe = cellData;
        [_cell2Infos setObject:cell forKey:indexPath];
    }

    
    cell.delegate = self;
    
    
    return cell;
    
}



#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 163.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




#pragma mark  swith btn delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSNumber* key = [NSNumber numberWithUnsignedLong:alertView.tag];
    XAIInfoListDelInfo* info = [_cell2Purge objectForKey:key];
    
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        
        if (info != nil && [info.corObjs count] > 0) {
            
            XAIObject* obj = [info.corObjs objectAtIndex:0];
            int delID = [_deviceService delDev:obj.luid];
            
            [_delInfo setObject:info
                         forKey:[NSNumber numberWithInt:delID]];
            
            [_cell2Purge removeObjectForKey:key];
        }
        
    }else{
        
        
        for (XAIObject* obj in info.corObjs) {
            
            [obj endOpr];
            
            
            XAIInfBtn* btn =  nil;
            
            if ([obj isKindOfClass:[XAIIR class]]) {
                
                btn =  (XAIInfBtn*)((XAIIR*)obj).delegate;
            }
            
            if ((btn != nil)
                && [btn isKindOfClass:[XAIInfBtn class]]) {
                
                [btn showOprEnd];
            }
            
        }
        
    }
    
    
}

-(void)linkageServiceHelp:(XAILinkageServiceHelp *)service purgeDev:(XAIDevice *)aDev beHas:(BOOL)bHas err:(XAI_ERROR)errcode{
    
    NSNumber* key = [NSNumber numberWithUnsignedLong:aDev.luid];
    
    XAIInfoListDelInfo* info = [_cell2Purge objectForKey:key];
    
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
            
            XAIInfBtn* btn =  nil;
            
            if ([obj isKindOfClass:[XAIIR class]]) {
                
                btn =  (XAIInfBtn*)((XAIIR*)obj).delegate;
            }
            
            if ((btn != nil)
                && [btn isKindOfClass:[XAIInfBtn class]]) {
                
                [btn showOprEnd];
            }
            
        }
    }
    
    
    [_linkageHelps removeObject:service];
}

-(void)infCell:(XAIInfListCell *)cell btnDelClick:(XAIInfBtn *)btn{
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if ([indexPath row] < 0 || [indexPath row] >= [_deviceDatas count]) return;
    
    XAIInfListCellData* cellData = [_deviceDatas objectAtIndex:[indexPath row]];
    if (![cellData isKindOfClass:[XAIInfListCellData class]]) return;
    
    
    
    XAIObject* obj = btn.weakObj;
    [obj startOpr];
    obj.curOprtip = @"正在删除";
    [btn showOprStart];
    
//    int delID = [_deviceService delDev:obj.luid];
//    
//    
//    XAIInfoListDelInfo* delInfo = [[XAIInfoListDelInfo alloc] init];
//    delInfo.corObjs = [NSArray arrayWithObject:obj];
//    delInfo.cellData = cellData;
//    [_delInfo setObject:delInfo
//                 forKey:[NSNumber numberWithInt:delID]];
    
    
    
    XAIInfoListDelInfo* delInfo = [[XAIInfoListDelInfo alloc] init];
    delInfo.corObjs = [NSArray arrayWithObject:obj];
    delInfo.cellData = cellData;
   
    XAILinkageServiceHelp* aHelp = [[XAILinkageServiceHelp alloc] init];
    aHelp.delegate = self;
    
    [_cell2Purge setObject:delInfo
                    forKey:[NSNumber numberWithUnsignedLong:obj.curDevice.luid]];
    
    [_linkageHelps addObject:aHelp];
    [aHelp  purgeHasDev:obj.curDevice];

    
}


NSInteger  prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY;
-(void)infCell:(XAIInfListCell *)cell btnEditClick:(XAIInfBtn *)btn{
    
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

-(void)infCell:(XAIInfListCell *)cell btnEditEnd:(XAIInfBtn *)btn{
    
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


-(void)infCell:(XAIInfListCell *)cell btnBgClick:(XAIInfBtn *)btn{
    
    XAIDevHistoryVC* hisVC = [XAIDevHistoryVC create];
    hisVC.retVC = self;
    hisVC.corObj = btn.weakObj;
    
    [self  animalVC_R2L:hisVC];
    
}


-(void)devService:(XAIDeviceService *)devService delDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode otherID:(int)otherID{
    
    if (devService != _deviceService) return;
    
    if (isSuccess) {
        
        [_delAnimalIDs addObject:[NSNumber numberWithInt:otherID]];
        
        [self realMove];
        return;
        
    }
    
    
    XAIInfoListDelInfo* delInfo = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (delInfo != nil ) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        for (XAIObject* obj in delInfo.corObjs) {
            
            
            [obj showMsg];
            obj.curOprtip = @"删除失败";
            
            
            XAIInfBtn* btn =  nil;
            
            if ([obj isKindOfClass:[XAIIR class]]) {
                
                btn =  (XAIInfBtn*)((XAIIR*)obj).delegate;
            }
            
            if ((btn != nil)
                && [btn isKindOfClass:[XAIInfBtn class]]) {
                
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
    
    XAIInfoListDelInfo* delInfo = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (delInfo != nil && [delInfo isKindOfClass:[XAIInfoListDelInfo class]]) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        do {
            
            for (XAIObject* oneObj in delInfo.corObjs) {
                
                [oneObj endOpr];
                
                XAIInfBtn* btn =  nil;
                
                if ([oneObj isKindOfClass:[XAIIR class]]) {
                    
                    btn =  (XAIInfBtn*)((XAIIR*)oneObj).delegate;
                }

                
                if ((btn != nil)
                    && [btn isKindOfClass:[XAIInfBtn class]]) {
                    
                    [btn showOprEnd];
                }
            }
            
            
            NSUInteger row = [_deviceDatas indexOfObject:delInfo.cellData];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row
                                                        inSection:0];
            ;
            XAIInfListCell* cell = (XAIInfListCell*)[_cell2Infos objectForKey:indexPath];
            
            if (cell == nil) break;
            if (![cell isKindOfClass:[XAIInfListCell class]])break;
            
            
            
            [_deviceDatasNoManage removeObjectsInArray:delInfo.corObjs];
            [self manageShowDatas];
            [self.tableView reloadData];
            
            
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


@implementation XAIInfListCellData
-(void)setOne:(XAIObject *)one{
    
    _oneObj = one;
    
}

@end

@implementation XAIInfoListDelInfo

@end


