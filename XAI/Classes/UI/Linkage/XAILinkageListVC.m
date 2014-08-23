//
//  LinkageListVC.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageListVC.h"
#import "XAILinkageListCell.h"
#import "XAILinkageAddNameVC.h"
#import "XAILinkageInfoVC.h"

#import "XAIShowVC.h"

#define  XAILinkageListVCID @"XAILinkageListVCID"
#define  _ST_show_linkage @"show_linkage"
@implementation XAILinkageListVC

+(UIViewController*)create{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:XAILinkageListVCID];
    //[vc changeIphoneStatusClear];
    return vc;

}



-(BOOL)prefersStatusBarHidden{
    
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self setNeedsStatusBarAppearanceUpdate];
        
    }
}



- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        // Custom initialization
        
        _linkageService = [[XAILinkageService alloc] init];
        _linkageService.apsn = [MQTT shareMQTT].apsn;
        _linkageService.luid = MQTTCover_LUID_Server_03;
        _linkageService.linkageServiceDelegate = self;
        
        _Datas = [[NSMutableArray alloc] init];
        _delInfo = [[NSMutableDictionary alloc] init];
        _changeInfo = [[NSMutableDictionary alloc] init];
        _cellInfos = [[NSMutableDictionary alloc] init];
        _delAnimalIDs = [[NSMutableArray alloc] init];
        _canDel = true;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_linkageService findAllLinkages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _swipes = [[NSArray alloc] initWithArray:[self openSwipe]];
   
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self stopSwipte:_swipes];
    
    [super viewDidDisappear:animated];
}

- (void) dealloc{
    
    _linkageService.linkageServiceDelegate = nil;
    [_linkageService willRemove];
    _linkageService = nil;
    
}




- (void) updateShowDatas{
    
    
    
    
    _Datas=  [[NSMutableArray alloc] init];
    

    
}

- (NSArray*) openSwipe{
    
    UISwipeGestureRecognizer* _recognizer;    
    
    _recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handleSwipeLeft:)];
    
    [_recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_retView addGestureRecognizer:_recognizer];
    
    
    
    return [NSArray arrayWithObjects:_recognizer,nil];
    
}


- (void) stopSwipte:(NSArray*) swipes{
    for ( UISwipeGestureRecognizer* recognizer in swipes) {
        if ([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
            [_retView removeGestureRecognizer:recognizer];
        }
    }
}




-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    [self animalVC_R2L:[XAIShowVC create]];
}

#pragma mark Table Data Source Methods





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    [self setSeparatorStyle:[_Datas count]];
    
    return [_Datas count] + 1;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = XAILinkageListCellID;
    
    XAILinkageListCell *cell = [tableView
                            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XAILinkageListCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    if ([indexPath row ] < [_Datas count]) {
        
        XAILinkage * aLinkage = [_Datas objectAtIndex:[indexPath row]];
        
        if (aLinkage != nil && [aLinkage isKindOfClass:[XAILinkage class]]) {
            
            [cell setInfo:aLinkage];
        }
        
        
        [cell setDelBtn];
        [cell setEditBtn];
        cell.delegate = self;
        
        
        if (cell.hasMe != nil) {
            
            [_cellInfos removeObjectForKey:cell.hasMe];
        }
        
        NSNumber* unique = [NSNumber numberWithInt:aLinkage.num];
        cell.hasMe = unique;
        [_cellInfos setObject:cell forKey:unique];
        

    }else{
    

        
        cell.leftUtilityButtons = nil;
        cell.rightUtilityButtons = nil;
        [cell setAdd];
        
    
    }
    
    
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
                if ([indexPath row] < 0 || [indexPath row] >= [_Datas count]) break;
                
                XAILinkage* aLinkage = [_Datas objectAtIndex:[indexPath row]];
                if (![aLinkage isKindOfClass:[XAILinkage class]]) break;
                
                
                [aLinkage startOpr];
                aLinkage.curOprtip = @"正在删除";
                [((XAILinkageListCell*)cell) showOprStart:aLinkage.curOprtip];
                
                int delID = [_linkageService delLinkage:aLinkage.num];
                
                [_delInfo setObject:aLinkage forKey:[NSNumber numberWithInt:delID]];
                
                [cell hideUtilityButtonsAnimated:true];
                
                
            } while (0);
            
            
            
            break;
        }
        default:
            break;
    }
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            do {
                
                XAILinkage* linkage = [_Datas objectAtIndex:
                                       [[self.tableView indexPathForCell:cell] row]];
                
                self.view.window.rootViewController = [XAILinkageInfoVC create:linkage.name linkage:linkage];
                
                
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
    
    if ([indexPath row] >= [_Datas count]) {
    /*添加联动*/
        
        self.view.window.rootViewController = [XAILinkageAddNameVC create];
        
    }else{
    /*更改联动状态*/
    
        
        do {

            
            XAILinkage * aLinkage= [_Datas objectAtIndex:[indexPath row]];
            if (![aLinkage isKindOfClass:[XAILinkage class]]) break;
            
            XAILinkageListCell* cell = (XAILinkageListCell*)[tableView cellForRowAtIndexPath:indexPath];
            if (![cell isKindOfClass:[XAILinkageListCell class]]) break;
            
            int unique = 0;
            
            if(aLinkage.status == XAILinkageStatus_Active){
                
                unique = [_linkageService setLinkage:aLinkage.num status:XAILinkageStatus_DisActive];
                
                aLinkage.curOprtip = @"正在修改为失效";
                [aLinkage startOpr];
                [cell showOprStart:aLinkage.curOprtip];
                
                
            }else if(aLinkage.status == XAILinkageStatus_DisActive){
                
                unique = [_linkageService setLinkage:aLinkage.num status:XAILinkageStatus_Active];
                
                aLinkage.curOprtip = @"正在修改为生效";
                [aLinkage startOpr];
                [cell showOprStart:aLinkage.curOprtip];
            }
            
            [_changeInfo setObject:aLinkage forKey:[NSNumber numberWithInt:unique]];
            
            
            
        } while (0);

    
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void) changeInputCell:(SWTableViewCell*)cell input:(UITextField*)input{
    
    [self hiddenOldInput];

}


- (void) hiddenOldInput{
    
}

- (BOOL) hasInput{
    
    return false;
}

- (BOOL) isSame:(SWTableViewCell*)cell{
    
    return false;
}

- (void) enableAllCtrl:(BOOL)status{
    
    [self.tableView setScrollEnabled:status];
    
    NSArray* cells = [self.tableView visibleCells];
    for (XAILinkageListCell* aCell in cells) {
        if (![aCell isKindOfClass:[XAILinkageListCell class]]) continue;
        
        [aCell setEnable:status];
        
    }
    
    
}

-(void)linkageService:(XAILinkageService *)service changeStatusStatusCode:(XAI_ERROR)errcode otherID:(int)otherID{

    if (service != _linkageService) return;
    
    
    XAILinkage * aLinkage = [_changeInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (aLinkage != nil && [aLinkage isKindOfClass:[XAILinkage class]]) {
        
        [_changeInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        if (errcode == XAI_ERROR_NONE) {
            [aLinkage endOpr];
        }else{
            [aLinkage showMsg];
            aLinkage.curOprtip = @"设置状态失败";
        }
        
        
        
        do {
            
            id obj = [_cellInfos objectForKey:[NSNumber numberWithInt:aLinkage.num]];
            
            XAILinkageListCell* cell = (XAILinkageListCell*)obj;
            
            if (cell == nil) break;
            if (![cell isKindOfClass:[XAILinkageListCell class]])break;
            
            if (errcode != XAI_ERROR_NONE) {
                
                [cell showMsg:aLinkage.curOprtip];
            }else{
                [cell showOprEnd];
                
            }
            
            
        } while (0);
        
    }


}


-(void)linkageService:(XAILinkageService *)service delStatusCode:(XAI_ERROR)errcode
              otherID:(int)otherID{
    
    if (service != _linkageService) return;
    
    
    if (errcode == XAI_ERROR_NONE) {
        
        [_delAnimalIDs addObject:[NSNumber numberWithInt:otherID]];
        
        [self realMove];
        return;
        
    }
    
    
    XAILinkage * aLinkage = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (aLinkage != nil && [aLinkage isKindOfClass:[XAILinkage class]]) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        if (errcode == XAI_ERROR_NONE) {
            [aLinkage endOpr];
        }else{
            [aLinkage showMsg];
            aLinkage.curOprtip = @"删除失败";
        }
        
            
            
            do {
                
                id obj = [_cellInfos objectForKey:[NSNumber numberWithInt:aLinkage.num]];
                
                XAILinkageListCell* cell = (XAILinkageListCell*)obj;
                
                if (cell == nil) break;
                if (![cell isKindOfClass:[XAILinkageListCell class]])break;
                
                if (errcode != XAI_ERROR_NONE) {
                    
                    [cell showMsg:aLinkage.curOprtip];
                }else{
                    [cell showOprEnd];
                    
                    [_Datas removeObject:aLinkage];
                    
                    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
                    
                    if (indexPath != nil) {
                        
                        NSArray* ary = [NSArray arrayWithObject:indexPath];
                        
                        [self.tableView  deleteRowsAtIndexPaths:ary
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
                    }else{
                    
                        NSLog(@"cell");
                    
                    }
                    
                }
                
                
            } while (0);
            

        
        
    }
    
}

-(void)linkageService:(XAILinkageService *)service findedAllLinkage:(NSArray *)linkageAry errcode:(XAI_ERROR)errcode{
    
    if ([_delInfo count] > 0) { //还有删除的不进行炒作
        return;
    }

    if (errcode == XAI_ERROR_NONE) {
        _Datas = [[NSMutableArray alloc] initWithArray:linkageAry];
        [self.tableView reloadData];
    }
    
    

}

- (void) realMove{
    
    if (_canDel == false) {
        return;
    }
    
    _canDel = false;
    
    int otherID = [[_delAnimalIDs objectAtIndex:0] intValue];
    XAI_ERROR  errcode = XAI_ERROR_NONE;
    
    [_delAnimalIDs removeObjectAtIndex:0];
    
    XAILinkage * aLinkage = [_delInfo objectForKey:[NSNumber numberWithInt:otherID]];
    if (aLinkage != nil && [aLinkage isKindOfClass:[XAILinkage class]]) {
        
        [_delInfo removeObjectForKey:[NSNumber numberWithInt:otherID]];
        
        if (errcode == XAI_ERROR_NONE) {
            [aLinkage endOpr];
        }else{
            [aLinkage showMsg];
            aLinkage.curOprtip = @"删除失败";
        }
        
        
        
        do {
            
            id obj = [_cellInfos objectForKey:[NSNumber numberWithInt:aLinkage.num]];
            
            XAILinkageListCell* cell = (XAILinkageListCell*)obj;
            
            if (cell == nil) break;
            if (![cell isKindOfClass:[XAILinkageListCell class]])break;
            
            if (errcode != XAI_ERROR_NONE) {
                
                [cell showMsg:aLinkage.curOprtip];
            }else{
                [cell showOprEnd];
                
                [_Datas removeObject:aLinkage];
                
                NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
                
                if (indexPath != nil) {
                    
                    NSArray* ary = [NSArray arrayWithObject:indexPath];
                    
                    [self.tableView  deleteRowsAtIndexPaths:ary
                                           withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    
                    NSLog(@"cell");
                    
                }
                
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
