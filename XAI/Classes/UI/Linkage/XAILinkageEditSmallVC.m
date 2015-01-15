//
//  XAILinkageInfoVC.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageEditSmallVC.h"
#import "XAILinkage.h"
#import "XAILinkageEditCell.h"
#import "XAILinkageChooseVCTool.h"
#import "XAILinkageListVC.h"
#import "XAILinkageUseInfo+ADD.h"

#import "XAIData.h"
#import "XAIObjectGenerate.h"

#define _ST_XAILinkageEditSmallVCID @"XAILinkageEditSmallVCID"
@implementation XAILinkageEditSmallVC

+ (XAILinkageEditSmallVC*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    XAILinkageEditSmallVC* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_XAILinkageEditSmallVCID];
    
    if (![vc isKindOfClass:[XAILinkageEditSmallVC class]]) return nil;
    
     [vc changeIphoneStatus];
    
    return vc;
    
}

+ (XAILinkageEditSmallVC*)create:(XAILinkage *)linkage{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    XAILinkageEditSmallVC* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_XAILinkageEditSmallVCID];
    
    [vc changeIphoneStatus];
    
    if (![vc isKindOfClass:[XAILinkageEditSmallVC class]]) return nil;
    
    [vc setLinkage:linkage];
    
    return vc;


}


- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        // Custom initialization
        
        _linkageService = [[XAILinkageService alloc] init];
        _linkageService.apsn = [MQTT shareMQTT].apsn;
        _linkageService.luid = MQTTCover_LUID_Server_03;
        _linkageService.linkageServiceDelegate = self;
        
        
        UIImage* backImg = [UIImage imageWithFile:@"back_nor.png"] ;
        
        if ([backImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
            
            backImg = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithImage:backImg
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(backClick:)];
        
        [backItem ios6cleanBackgroud];
        
        
        [self.navigationItem setLeftBarButtonItem:backItem];
        
    }
    return self;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    _activityView = [[UIActivityIndicatorView alloc] init];
    
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activityView.color = [UIColor redColor];
    _activityView.frame = CGRectMake(rx.size.width * 0.5f, rx.size.height * 0.5f, 0, 0);
    _activityView.hidesWhenStopped = YES;
    
    [self.view addSubview:_activityView];
    
    if (_oldLinkage != nil) {
        [_linkageService getLinkageDetail:_oldLinkage];
        [_activityView startAnimating];
    }else{
    
        _linkage = [[XAILinkage alloc] init];
    }
    
}



- (IBAction)backClick:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self animalVC_L2R:[XAILinkageListVC create]];
    
}

#pragma mark - action
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
    
    NSArray*  cells = [self.cTableView visibleCells];
    
    for (XAILinkageEditCell* aCell in cells) {
        if (![aCell isKindOfClass:[XAILinkageEditCell class]]) continue;
        
        if (aCell.canDelete == false) continue;
        
        [aCell isEidt:_gEditing];
        
    }

}



- (IBAction)okClick:(id)sender{
    
    NSString* tiperr = nil;
    
    if (_linkage.name == nil || [_linkage.name isEqualToString:@""]) {
        tiperr = @"请添加联动名称";
    }else if (strlen([_linkage.name UTF8String]) < 4) {
        tiperr = @"联动名称长度过短";
    }else if ([_linkage.condInfos count] == 0) {
        tiperr = @"请添加联动条件";
    }else if([_linkage.resultInfos count] == 0){
        tiperr = @"请添加联动控制";
    }
    
    if (tiperr != nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:tiperr
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    if (_oldLinkage != nil) {/*先删除后设置*/
        [_linkageService delLinkage:_oldLinkage.num];
        
    }else{
    
        [self addLinkage];
    }
    
    
    [_activityView startAnimating];
    _activityView.hidden = false;

}

-(void)addLinkage{

    
    [_linkageService addLinkageConds:_linkage.condInfos
                             results:_linkage.resultInfos
                               status:XAILinkageStatus_Active
                                 name:_linkage.name];
}


- (void) setName:(NSString*)name{
    
    
    _name = name;
    //self.nameTF.text = name;
    
}

- (void) setLinkage:(XAILinkage*)linkage{

    _oldLinkage = linkage;
    
}

-(XAILinkage *)getLinkage{

    return _linkage;
}

- (void) setLinkageUseInfo:(XAILinkageUseInfo*)useInfo{

    NSIndexPath* next = nil;
    
    if ([_selIndex row] > 0 && [_selIndex row] < _linkage.condInfos.count+2){
        
        
        NSUInteger resIndex = [_selIndex row] - 1;
        
        if (resIndex < [_linkage.condInfos count]) {
            
            [_linkage.condInfos replaceObjectAtIndex:resIndex withObject:useInfo];
            
        }else if(resIndex == [_linkage.condInfos count]){
            [_linkage.condInfos addObject:useInfo];
            
            next = [NSIndexPath indexPathForRow:_selIndex.row+1
                                      inSection:_selIndex.section];
        }

    }else{
        
        NSUInteger resIndex = [_selIndex row] - 3 - _linkage.condInfos.count;
    
        if (resIndex < [_linkage.resultInfos count]) {
            
            [_linkage.resultInfos replaceObjectAtIndex:resIndex withObject:useInfo];
            
        }else if(resIndex == [_linkage.resultInfos count]){
            [_linkage.resultInfos addObject:useInfo];
           
            next = [NSIndexPath indexPathForRow:_selIndex.row+1
                                      inSection:_selIndex.section];
        }
    
    }
    
     [self.cTableView reloadData];

    if (next != nil) {
        [self.cTableView scrollToRowAtIndexPath:next
                               atScrollPosition:UITableViewScrollPositionBottom
                                       animated:YES];
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    BOOL hasCondAdd = _linkage.condInfos.count < 16;
    BOOL hasResultAdd = _linkage.resultInfos.count < 16;
    
    int count  = 2; //name + 分割线;
    
    if (hasCondAdd) count += 1;
    if (hasResultAdd) count += 1;
    
    count +=  _linkage.condInfos.count;
    count +=  _linkage.resultInfos.count;
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL hasCondAdd = _linkage.condInfos.count < 16;
    
    int sepIndx = 1 + _linkage.condInfos.count + (hasCondAdd ? 1 : 0);
    
    if ([indexPath row] == sepIndx) {
        return 25;
    }
    
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BOOL hasCondAdd = _linkage.condInfos.count < 16;
    int sepIndx = 1 + _linkage.condInfos.count + (hasCondAdd ? 1 : 0);
    if ([indexPath row] == sepIndx) {
        
        NSString* sepId = @"sepId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sepId];
        
        if (cell == nil || ![cell isKindOfClass:[UITableViewCell class]]) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:sepId];
        }
        
        return cell;

    }
    
    NSString* cellID = _C_XAILinkageEditCellID;
    
    XAILinkageEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil || ![cell isKindOfClass:[UITableViewCell class]]) {
        cell = [[XAILinkageEditCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
    }
    
    if ([indexPath row] == 0) { //名字
        
        [cell setName:_linkage.name];
        
        [cell isEidt:false];
        cell.canDelete = false;

        
    }else if ([indexPath row] == _linkage.condInfos.count + 1) { //条件+
        
        NSRange range;
        [cell setCondInfo:nil nameRange:range index:_linkage.condInfos.count];
        
        [cell isEidt:false];
        cell.canDelete = false;
        
        
    }else if ([indexPath row ] - 1 < _linkage.condInfos.count) { //条件
        
        NSRange range;
        
        XAILinkageUseInfo * aUseInfo = [_linkage.condInfos objectAtIndex:[indexPath row ] - 1];
        [cell setCondInfo:[aUseInfo toStrIsCond:true nameRange:&range]
                nameRange:range
                    index:[indexPath row ] - 1];
        
        
        [cell isEidt:_gEditing];
        cell.canDelete = true;
        
        
    }else{ //结果
    
        NSUInteger condIndex = [indexPath row] - 3 - _linkage.condInfos.count;
        
        if (condIndex < [_linkage.resultInfos count]) {
            
            XAILinkageUseInfo * aUseInfo = [_linkage.resultInfos objectAtIndex:condIndex];
            
            
            [cell setInfo:[aUseInfo toStrIsCond:false] index:condIndex];
            
            [cell isEidt:_gEditing];
            cell.canDelete = true;
            
        }else{
            
            
            [cell setInfo:nil index:condIndex];
            
            [cell isEidt:false];
            cell.canDelete = false;
            
        }

    
    }
    
    
    cell.delegate = self;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:false];
    
}

-(void)gotoLinkageAddInfoVC:(BOOL)isCond{

    XAILinkageChooseVC* vc = nil;
   
    
    if (isCond) {
        
      vc = [XAILinkageChooseVCTool create:XAILinkageOneType_yuanyin];

    }else{
        
      vc = [XAILinkageChooseVCTool create:XAILinkageOneType_jieguo];
    }
    
     vc.infoVC = self;
    
    [self.navigationController pushViewController:vc animated:true];
}


#pragma mark - delgate
-(void)linkageInfoCellDelClick:(XAILinkageEditCell *)cell{

    NSIndexPath* indexPath = [self.cTableView indexPathForCell:cell];
    

    int  row = indexPath.row - 1; //name
    
    
    if (row < _linkage.condInfos.count) {
        
        [_linkage.condInfos removeObjectAtIndex:row];
        
        [self.cTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [_cTableView reloadData];

    }else{
        
        BOOL hasCondAdd = _linkage.condInfos.count < 16;
        row  -= hasCondAdd ? 1 : 0;
        row  -= 1;  // sep
    
        row -= _linkage.condInfos.count;
        if (row < _linkage.resultInfos.count) {
            
            [_linkage.resultInfos removeObjectAtIndex:row];
            
            [self.cTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];

            [_cTableView reloadData];
        }
    
    }
    
    
//    NSUInteger condIndex = [indexPath row] - _linkage.condInfos.count - 1;
//    if (condIndex < [_linkage.resultInfos count]) {
//        
//        [_linkage.resultInfos removeObjectAtIndex:condIndex];
//        
//        
//        [self.cTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                                withRowAnimation:UITableViewRowAnimationAutomatic];
//        
////        NSArray* visCells = [self.cTableView visibleCells];
////        
////        NSMutableArray* indexs = [[NSMutableArray alloc] init];
////        for (XAILinkageEditCell* cell in visCells) {
////           NSIndexPath* aIndexPath =  [_cTableView indexPathForCell:cell];
////            if ([aIndexPath row] > [indexPath row]) {
////                
////                NSUInteger condIndex = [aIndexPath row] - 2 - 2;
////                
////                if (condIndex < [_linkage.condInfos count]) {
////                    
////                    XAILinkageUseInfo * aUseInfo = [_linkage.condInfos objectAtIndex:condIndex-1];
////                    
////                    [cell setInfo:[aUseInfo toStrIsCond:false] index:condIndex-1];
////                    
////
////                }
////
////                //[indexs addObject:indexPath];
////            }
////            
//////            if (cell == visCells.lastObject) {
//////                [cell reloadInputViews];
//////            }
////        }
//        
//    
//        
//        
////        [self.cTableView reloadRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
//
//        
//        [_cTableView reloadData];
//    }
    


}

-(void)linkageInfoCellResultClick:(XAILinkageEditCell *)cell{
    
    XAILinkageChooseVC* vc = [XAILinkageChooseVCTool create:XAILinkageOneType_jieguo];
    vc.infoVC = self;
    
    NSIndexPath* indexPath = [self.cTableView indexPathForCell:cell];
    

    _selIndex = indexPath;
    
    
    if ([indexPath row] == 0) { //名字
        
        return;
        
    }else if ([indexPath row ] - 1 <= _linkage.condInfos.count) { //条件
        
        [self gotoLinkageAddInfoVC:true];
    }else{
        [self gotoLinkageAddInfoVC:false];
    }

}

-(void)linkageInfoCell:(XAILinkageEditCell *)cell tipEditEnd:(NSString *)str{

    if (str != nil && ![str isEqualToString:@""]) {
        _linkage.name = str;
    }
}

-(void)linkageInfoCellEditStart:(XAILinkageEditCell *)cell{

    
    [self.cTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                 animated:YES
                           scrollPosition:UITableViewScrollPositionTop];
}

-(void)linkageService:(XAILinkageService *)service addStatusCode:(XAI_ERROR)errcode{

    NSString* tipPre  = _oldLinkage == nil ? @"添加联动" : @"修改联动";
    
    NSString* tip = [NSString stringWithFormat:@"%@%@",tipPre,@"发生错误"];
    
    if (errcode == XAI_ERROR_NONE) {
        
        _oldLinkage = _linkage;
        tip = [NSString stringWithFormat:@"%@%@",tipPre,@"成功"];
    }else if (errcode == XAI_ERROR_TIMEOUT){
         tip = [NSString stringWithFormat:@"%@%@",tipPre,@"超时"];
    }

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:tip
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
    
    
    [_activityView stopAnimating];

}

-(void)linkageService:(XAILinkageService *)service delStatusCode:(XAI_ERROR)errcode otherID:(int)otherID{

    [self addLinkage];
}

-(void)linkageService:(XAILinkageService *)service getLinkageDetail:(XAILinkage *)linkage statusCode:(XAI_ERROR)errcode{

    [_activityView stopAnimating];
    
    if (errcode == XAI_ERROR_NONE) {
        
        
        _linkage = linkage;
        
        [self.cTableView reloadData];
    }

}


@end
