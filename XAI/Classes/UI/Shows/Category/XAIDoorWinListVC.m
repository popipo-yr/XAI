//
//  XAIDoorWinListVC.m
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDoorWinListVC.h"
#import "XAIObjectGenerate.h"
#import "XAIDoorWinCell.h"
#import "XAIDevHistoryVC.h"

#define _M_CellWidth  35

@interface XAIDoorWinListVC ()

@end

@implementation XAIDoorWinListVC


+(UIViewController*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_DoorWinListVCID];
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
        
        _types = @[@(XAIObjectType_door),@(XAIObjectType_window)];
        _deviceDatas = [[NSMutableArray alloc] init];
        _delInfo = [[NSMutableDictionary alloc] init];
        _delAnimalIDs = [[NSMutableArray alloc] init];
        _cell2Infos = [[NSMutableDictionary alloc] init];
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
    
//    if (![[MQTT shareMQTT].curUser isAdmin]) {
//        _gEditBtn.hidden = true;
//        _gEditBtn.enabled = false;
//    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
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
        if ([obj isKindOfClass:[XAIWindow class]]){
            ((XAIWindow*)obj).delegate = nil;
        }
        if ([obj isKindOfClass:[XAIDoor class]]){
            ((XAIDoor*)obj).delegate = nil;
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
    

    
    //[_deviceDatasNoManage addObject:[[XAIDoor alloc] init]];
    //[_deviceDatasNoManage addObject:[[XAIDoor alloc] init]];

    
    [self manageShowDatas];
    
    self.tipImgView.hidden = [_deviceDatas count] == 0 ? false : true;
    
}



-(void)manageShowDatas{
    
    
    
    NSMutableArray* newDatas =  [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < (int)[_deviceDatasNoManage count] - 1; i = i+2) {
        
        XAIObject* one = [_deviceDatasNoManage objectAtIndex:i];
        XAIObject* two =     [_deviceDatasNoManage objectAtIndex:i+1];
        XAIDCCellData* cellData = [[XAIDCCellData alloc] init];
        [cellData setOne:one two:two];
        
        [newDatas addObject:cellData];

    }
    

    if ([_deviceDatasNoManage count] % 2 == 1) {
        XAIObject* one = [_deviceDatasNoManage objectAtIndex:[_deviceDatasNoManage count] - 1];
        XAIDCCellData* cellData = [[XAIDCCellData alloc] init];
        [cellData setOne:one two:nil];
        [newDatas addObject:cellData];
    }
    
    _deviceDatas = [[NSMutableArray alloc] initWithArray:newDatas];
    
    [self fireCount];
}

-(void) fireCount{
    
    int count = 0;
    
    for (XAIObject* aObj in _deviceDatasNoManage) {
        
        if (aObj.isOnline && aObj.curDevStatus == XAIDoorStatus_Open) {
            
            count += 1;
            break;
        }
    }
    
    if (count > 0) {
        
        
        _gStatusImgView.image = [UIImage imageWithFile:@"dc_tbg_open.png"];
        
    }else{
        
        _gStatusImgView.image = [UIImage imageWithFile:@"dc_tbg.png"];
        
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
    
    for (XAIDCListVCCellNew* aCell in cells) {
        if (![aCell isKindOfClass:[XAIDCListVCCellNew class]]) continue;
        [aCell isEdit:_gEditing];
    }
}

-(void)bgGetClick:(id)sender{
    
    [self endEditOne:_curEditBtn];
    
}


-(void)endEditOne:(XAIDCBtn*)btn{
    
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

    
    static NSString *CellIdentifier = @"XAIDoorWinCellID";
    
    XAIDCListVCCellNew *cell = [tableView
                                dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [XAIDCListVCCellNew create:CellIdentifier];
    }
    
    XAIDCCellData* cellData = [_deviceDatas objectAtIndex:[indexPath row]];
    
    if ([cellData isKindOfClass:[XAIDCCellData class]]) {
        
        [cell setInfoOne:cellData.oneObj two:cellData.twoObj];
        
        [cell isEdit:_gEditing];
        cell.delegate = self;
        
        if (cell.hasMe != nil) {
            
            [_cell2Infos removeObjectForKey:cell.hasMe];
        }
        
        cell.hasMe = cellData;
        [_cell2Infos setObject:cell forKey:indexPath];
        
        
        if ([_deviceDatas count] == 1) {
            [cell setOnlyNeedCenter:YES];
        }else{
            [cell setOnlyNeedCenter:false];
        }
    }
    
    
    
    
    cell.delegate = self;
    
    return cell;    
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 160.0;
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
    XAIDCListDelInfo* info = [_cell2Purge objectForKey:key];

    
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
            
            XAIDCBtn* btn =  nil;
            if ([obj isKindOfClass:[XAIDoor class]]) {
                
                btn =  (XAIDCBtn*)((XAIDoor*)obj).delegate;
            }else if([obj isKindOfClass:[XAIWindow class]]) {
                
                btn = (XAIDCBtn*)((XAIWindow*)obj).delegate;
            }
            
            
            if ((btn != nil)
                && [btn isKindOfClass:[XAIDCBtn class]]) {
                
                [btn showOprEnd];
            }
            
        }
        
    }

    
}

-(void)linkageServiceHelp:(XAILinkageServiceHelp *)service purgeDev:(XAIDevice *)aDev beHas:(BOOL)bHas err:(XAI_ERROR)errcode{
    
    NSNumber* key = [NSNumber numberWithUnsignedLong:aDev.luid];
    
    XAIDCListDelInfo* info = [_cell2Purge objectForKey:key];

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
            
            XAIDCBtn* btn =  nil;
            
            if ([obj isKindOfClass:[XAIDoor class]]) {
                
                btn =  (XAIDCBtn*)((XAIDoor*)obj).delegate;
            }else if([obj isKindOfClass:[XAIWindow class]]) {
                
                btn = (XAIDCBtn*)((XAIWindow*)obj).delegate;
            }
            
            
            if ((btn != nil)
                && [btn isKindOfClass:[XAIDCBtn class]]) {
                
                [btn showOprEnd];
            }
            
        }
    }

    
    [_linkageHelps removeObject:service];
}


-(void)dcCell:(XAIDCListVCCellNew *)cell btnDelClick:(XAIDCBtn *)btn{
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if ([indexPath row] < 0 || [indexPath row] >= [_deviceDatas count]) return;
    
    XAIDCCellData* cellData = [_deviceDatas objectAtIndex:[indexPath row]];
    if (![cellData isKindOfClass:[XAIDCCellData class]]) return;
    
    
    
    XAIObject* obj = btn.weakObj;
    [obj startOpr];
    obj.curOprtip = @"正在删除";
    [btn showOprStart];
    
    XAILinkageServiceHelp* aHelp = [[XAILinkageServiceHelp alloc] init];
    aHelp.delegate = self;
    
    XAIDCListDelInfo* delInfo = [[XAIDCListDelInfo alloc] init];
    delInfo.corObjs = [NSArray arrayWithObject:obj];
    delInfo.cellData = cellData;
    
    [_cell2Purge setObject:delInfo
                    forKey:[NSNumber numberWithUnsignedLong:obj.curDevice.luid]];
    
    [_linkageHelps addObject:aHelp];
    [aHelp  purgeHasDev:obj.curDevice];
    
    
//    int delID = [_deviceService delDev:obj.luid];
//    
//    
//    XAIDCListDelInfo* delInfo = [[XAIDCListDelInfo alloc] init];
//    delInfo.corObjs = [NSArray arrayWithObject:obj];
//    delInfo.cellData = cellData;
//    [_delInfo setObject:delInfo
//                 forKey:[NSNumber numberWithInt:delID]];
}


NSInteger  prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY;
-(void)dcCell:(XAIDCListVCCellNew *)cell btnEditClick:(XAIDCBtn *)btn{
    
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

-(void)dcCell:(XAIDCListVCCellNew *)cell btnEditEnd:(XAIDCBtn *)btn{
    
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


-(void)dcCell:(XAIDCListVCCellNew *)cell btnBgClick:(XAIDCBtn *)btn{

    XAIDevHistoryVC* hisVC = [XAIDevHistoryVC create];
    hisVC.retVC = self;
    hisVC.corObj = btn.weakObj;

    [self  animalVC_R2L:hisVC];

}

-(void)dcCell:(XAIDCListVCCellNew *)cell btnStatusChange:(XAIDCBtn *)btn{
    [self fireCount];
}


-(void)devService:(XAIDeviceService *)devService delDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode otherID:(int)otherID{
  
    if (devService != _deviceService) return;
    
    if (isSuccess) {
        
        [_delAnimalIDs addObject:[NSNumber numberWithInt:otherID]];
        
        [self realMove];
        return;
        
    }
    
    
    XAIDCListDelInfo* delInfo = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (delInfo != nil ) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        for (XAIObject* obj in delInfo.corObjs) {
            
            
            [obj showMsg];
            obj.curOprtip = @"删除失败";
            
            
            XAIDCBtn* btn =  nil;
            
            if ([obj isKindOfClass:[XAIDoor class]]) {
                
                btn =  (XAIDCBtn*)((XAIDoor*)obj).delegate;
            }else if([obj isKindOfClass:[XAIWindow class]]) {
                
                btn = (XAIDCBtn*)((XAIWindow*)obj).delegate;
            }
            
            
            if ((btn != nil)
                && [btn isKindOfClass:[XAIDCBtn class]]) {
                
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
    
    XAIDCListDelInfo* delInfo = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (delInfo != nil && [delInfo isKindOfClass:[XAIDCListDelInfo class]]) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        do {
            
            for (XAIObject* oneObj in delInfo.corObjs) {
                
                [oneObj endOpr];
                
                XAIDCBtn* btn =  nil;
                
                if ([oneObj isKindOfClass:[XAIDoor class]]) {
                    
                    btn =  (XAIDCBtn*)((XAIDoor*)oneObj).delegate;
                }else if([oneObj isKindOfClass:[XAIWindow class]]) {
                    
                    btn = (XAIDCBtn*)((XAIWindow*)oneObj).delegate;
                }
                
               
                
                if ((btn != nil)
                    && [btn isKindOfClass:[XAIDCBtn class]]) {
                    
                    [btn showOprEnd];
                }
            }
            
            
            NSUInteger row = [_deviceDatas indexOfObject:delInfo.cellData];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row
                                                        inSection:0];
            ;
            XAIDCListVCCellNew* cell = (XAIDCListVCCellNew*)[_cell2Infos objectForKey:indexPath];
            
            if (cell == nil) break;
            if (![cell isKindOfClass:[XAIDCListVCCellNew class]])break;
            
            
            
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


@implementation XAIDCCellData
-(void)setOne:(XAIObject *)one two:(XAIObject *)two{
    
    _oneObj = one;
    _twoObj = two;

}

@end

@implementation XAIDCListDelInfo

@end

