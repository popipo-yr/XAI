//
//  XAILinkageInfoVC.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageEditVC.h"
#import "XAILinkage.h"
#import "XAILinkageEditCell.h"
#import "XAILinkageChooseVCTool.h"
#import "XAILinkageListVC.h"
#import "XAILinkageUseInfo+ADD.h"

#import "XAIData.h"
#import "XAIObjectGenerate.h"

#define _ST_XAILinkageEditVCID @"XAILinkageEditVCID"
@implementation XAILinkageEditVC

+ (XAILinkageEditVC*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    XAILinkageEditVC* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_XAILinkageEditVCID];
    
    if (![vc isKindOfClass:[XAILinkageEditVC class]]) return nil;
    
     [vc changeIphoneStatus];
    
    return vc;
    
}

+ (XAILinkageEditVC*)create:(XAILinkage *)linkage{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    XAILinkageEditVC* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_XAILinkageEditVCID];
    
    [vc changeIphoneStatus];
    
    if (![vc isKindOfClass:[XAILinkageEditVC class]]) return nil;
    
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
        
        NSUInteger index = [[self.cTableView indexPathForCell:aCell] row];
        if (index == [_linkage.condInfos count] + 2) continue;
        if (index == 0 || index ==  1) continue;
        
        [aCell isEidt:_gEditing];
        
    }

}



- (IBAction)okClick:(id)sender{
    
    NSString* tiperr = nil;
    
    if (_linkage.name == nil || [_linkage.name isEqualToString:@""]) {
        tiperr = @"请添加联动名称";
    }else if (_linkage.effeInfo == nil) {
        tiperr = @"请添加联动条件";
    }else if([_linkage.condInfos count] == 0){
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

    
    [_linkageService addLinkageParams:_linkage.condInfos
                             ctrlInfo:_linkage.effeInfo
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
    
    if ([_selIndex row] == 1){
    
        _linkage.effeInfo = useInfo;

    }else{
        
        NSUInteger resIndex = [_selIndex row] - 2;
    
        if (resIndex < [_linkage.condInfos count]) {
            
            [_linkage.condInfos replaceObjectAtIndex:resIndex withObject:useInfo];
            
        }else if(resIndex == [_linkage.condInfos count]){
            [_linkage.condInfos addObject:useInfo];
           
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
    return [_linkage.condInfos count]+ 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

        
    }else if ([indexPath row ] == 1) { //条件
        
        XAILinkageUseInfo * aUseInfo = _linkage.effeInfo;
        
        
        [cell setCondInfo:[aUseInfo toStrIsCond:true]];
        
        [cell isEidt:false];
        
    }else{ //结果
    
        NSUInteger condIndex = [indexPath row] - 2;
        
        if (condIndex < [_linkage.condInfos count]) {
            
            XAILinkageUseInfo * aUseInfo = [_linkage.condInfos objectAtIndex:condIndex];
            
            
            [cell setInfo:[aUseInfo toStrIsCond:false] index:condIndex];
            
            [cell isEidt:_gEditing];
            
        }else{
            
            
            [cell setInfo:nil index:condIndex];
            
            [cell isEidt:false];
            
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

    NSIndexPath* indexPatn = [self.cTableView indexPathForCell:cell];
    
    
    NSUInteger condIndex = [indexPatn row] - 2;
    if (condIndex < [_linkage.condInfos count]) {
        
        [_linkage.condInfos removeObjectAtIndex:condIndex];
        [self.cTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPatn]
                                withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    


}

-(void)linkageInfoCellResultClick:(XAILinkageEditCell *)cell{
    
    XAILinkageChooseVC* vc = [XAILinkageChooseVCTool create:XAILinkageOneType_jieguo];
    vc.infoVC = self;
    
    NSIndexPath* indexPath = [self.cTableView indexPathForCell:cell];
    

    _selIndex = indexPath;
    
    
    if ([indexPath row] == 0) { //名字
        
        return;
        
    }else if ([indexPath row ] == 1) { //条件
        
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
