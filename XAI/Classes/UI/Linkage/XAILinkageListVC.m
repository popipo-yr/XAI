//
//  LinkageListVC.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageListVC.h"
#import "XAILinkageListCell.h"
#import "XAILinkageEditVC.h"
#import "XAILinkageEditSmallVC.h"

#import "XAIShowVC.h"

#define  XAILinkageListVCID @"XAILinkageListVCID"
#define  _ST_show_linkage @"show_linkage"

#define _ST_XAILinkageListVCNavID @"XAILinkageListVCNavID"
@implementation XAILinkageListVC

+(UIViewController*)create{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:XAILinkageListVCID];
    //[vc changeIphoneStatusClear];
    return vc;

}

+(UINavigationController*)createWithNav{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    UINavigationController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_XAILinkageListVCNavID];
    //[vc changeIphoneStatusClear];
    [vc changeIphoneStatus];
    if (![vc isKindOfClass:[UINavigationController class]]) {
        return nil;
    }
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
    
    UIImage* backImg = [UIImage imageWithFile:@"back_nor.png"] ;
    
    if ([backImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
        
        backImg = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithImage:backImg
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(returnClick:)];
    
    [backItem ios6cleanBackgroud];
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    //if ([[MQTT shareMQTT].curUser isAdmin]) {
        
        UIImage* addImg = [UIImage imageWithFile:@"add_nor.png"] ;
        
        if ([addImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
            
            addImg = [addImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        
        UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithImage:addImg
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(addOneLink:)];
        
        [addItem ios6cleanBackgroud];
        
        [self.navigationItem setRightBarButtonItem:addItem];
    //}
    
    _activityView = [[UIActivityIndicatorView alloc] init];
    
    CGRect rx = [ UIScreen mainScreen ].bounds;
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activityView.color = [UIColor redColor];
    _activityView.frame = CGRectMake(rx.size.width * 0.5f, rx.size.height * 0.5f, 0, 0);
    _activityView.hidesWhenStopped = YES;
    
    [_activityView startAnimating];

    [self.view addSubview:_activityView];
    
    [_linkageService findAllLinkages];
    
//    if (![[MQTT shareMQTT].curUser isAdmin]) {
//        _gEditBtn.hidden = true;
//        _gEditBtn.enabled = false;
//    }
    
    _gEditBtn.hidden = true;
    
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


-(void)returnClick:(id)sender{

    [self animalVC_R2L:[XAIShowVC create]];
}

-(void)addOneLink:(id)sender{

    UIViewController* vc = nil;
    if ([UIScreen is_35_Size]) {
        vc = [XAILinkageEditSmallVC create];
    }else{
        vc = [XAILinkageEditSmallVC create];
    }
    [self.navigationController pushViewController:vc animated:YES];
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
    
    for (XAILinkageListCell* aCell in cells) {
        if (![aCell isKindOfClass:[XAILinkageListCell class]]) continue;
        [aCell isEidt:_gEditing];
    }
}

#pragma mark Table Data Source Methods





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    [self setSeparatorStyle:[_Datas count]];
    
    return [_Datas count];
    
    
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
            [cell isEidt:_gEditing];
        }
        
        
        cell.delegate = self;
        
        
        if (cell.hasMe != nil) {
            
            [_cellInfos removeObjectForKey:cell.hasMe];
        }
        
        NSNumber* unique = [NSNumber numberWithInt:aLinkage.num];
        cell.hasMe = unique;
        [_cellInfos setObject:cell forKey:unique];
        

    }
    
    cell.selectedBackgroundView = [UIView new];
    
    return cell;
    
    
}



#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _C_LinkageListCellHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    XAILinkage* linkage = [_Datas objectAtIndex:[indexPath row]];
    
    UIViewController* vc = nil;
    if ([UIScreen is_35_Size]) {
        vc = [XAILinkageEditSmallVC create:linkage];
    }else{
        vc = [XAILinkageEditSmallVC create:linkage];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -  cell Delegate
-(void)linkListCellClickStatusClick:(XAILinkageListCell *)cell{
    
    
    do {
        
        
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
         if ([indexPath row] < 0 || [indexPath row] >= [_Datas count]) break;
        
        XAILinkage * aLinkage= [_Datas objectAtIndex:[indexPath row]];
        if (![aLinkage isKindOfClass:[XAILinkage class]]) break;
        
        
        int unique = 0;
        
        if(aLinkage.status == XAILinkageStatus_Active){
            
            unique = [_linkageService setLinkage:aLinkage.num status:XAILinkageStatus_DisActive];
            
            aLinkage.curOprtip = @"正在修改为失效";
            [aLinkage startOpr];
            [cell showOprStart];
            
            
        }else if(aLinkage.status == XAILinkageStatus_DisActive){
            
            unique = [_linkageService setLinkage:aLinkage.num status:XAILinkageStatus_Active];
            
            aLinkage.curOprtip = @"正在修改为生效";
            [aLinkage startOpr];
            [cell showOprStart];
        }
        
        [_changeInfo setObject:aLinkage forKey:[NSNumber numberWithInt:unique]];
        
    } while (0);
    
    //[_activityView startAnimating];
    
}

-(void)linkListCellClickDel:(XAILinkageListCell *)cell{

    do {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
        if ([indexPath row] < 0 || [indexPath row] >= [_Datas count]) break;
        
        XAILinkage* aLinkage = [_Datas objectAtIndex:[indexPath row]];
        if (![aLinkage isKindOfClass:[XAILinkage class]]) break;
        
        
        [aLinkage startOpr];
        aLinkage.curOprtip = @"正在删除";
        [cell showOprStart];
        
        int delID = [_linkageService delLinkage:aLinkage.num];
        
        [_delInfo setObject:aLinkage forKey:[NSNumber numberWithInt:delID]];
        
    } while (0);
    
    //[_activityView startAnimating];
        
}



-(void)linkageService:(XAILinkageService *)service changeStatusStatusCode:(XAI_ERROR)errcode otherID:(int)otherID{

    if (service != _linkageService) return;
    
    //[_activityView stopAnimating];
    
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
                
                [cell showMsg];
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
                    
                    [cell showMsg];
                }else{
                    //[cell showOprEnd]; //直接移除了
                    
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
    
    
    [_activityView stopAnimating];
    
    if ([_delInfo count] > 0) { //还有删除的不进行炒作
        return;
    }

    if (errcode == XAI_ERROR_NONE) {
        _Datas = [[NSMutableArray alloc] initWithArray:linkageAry];
        [self.tableView reloadData];
        
        self.tipImgView.hidden = [_Datas count] == 0 ? false : true;
        _gEditBtn.hidden = [_Datas count] == 0 ? true : false;
    }else{
    
        self.tipImgView.hidden = false;
        _gEditBtn.hidden = true;
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
                
                //[cell showMsg:aLinkage.curOprtip];
            }else{
                //[cell showOprEnd];
                
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
    }else{
    
        [_activityView stopAnimating];
    }
}




@end
