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
#import "XAILinkageChooseVC.h"
#import "XAILinkageListVC.h"
#import "XAILinkageUseInfo+ADD.h"

#import "XAIData.h"
#import "XAIObjectGenerate.h"

#define _ST_XAILinkageEditVCID @"XAILinkageEditVCID"
@implementation XAILinkageEditVC

+ (XAILinkageEditVC*)create:(NSString*)name;{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    XAILinkageEditVC* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_XAILinkageEditVCID];
    
    if (![vc isKindOfClass:[XAILinkageEditVC class]]) return nil;
    
     [vc changeIphoneStatus];
    
    
    [vc setName:name];
    
    return vc;
    
}

+ (XAILinkageEditVC*)create:(NSString*)name linkage:(XAILinkage *)linkage{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    XAILinkageEditVC* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_XAILinkageEditVCID];
    
    [vc changeIphoneStatus];
    
    if (![vc isKindOfClass:[XAILinkageEditVC class]]) return nil;
    
    [vc setName:name];
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
        
        _datas = [[NSMutableArray alloc] init];
        
        
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
    
    //[_activityView startAnimating];
    
    [self.view addSubview:_activityView];
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
        if (aCell == [cells lastObject]) continue;
        
        [aCell isEidt:_gEditing];
        
    }

}

- (IBAction)condClick:(id)sender{

    _selIndex = false;
    [self gotoLinkageAddInfoVC:true];
}

- (IBAction)okClick:(id)sender{
    
    NSString* tiperr = nil;
    
    if (_datas == nil || [_datas count] == 0) {
        tiperr = @"请添加联动条件";
    }else if([_datas count] == 1){
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
    
    if (_linkage != nil) {/*先删除后设置*/
        [_linkageService delLinkage:_linkage.num];
        
    }else{
    
        [self addLinkage];
    }
    
    
    [_activityView startAnimating];
    _activityView.hidden = false;

}

-(void)addLinkage{

    NSMutableArray* jieguos = [NSMutableArray arrayWithArray:_datas];
    [jieguos removeObjectAtIndex:0];
    
    [_linkageService addLinkageParams:jieguos ctrlInfo:[_datas objectAtIndex:0] status:XAILinkageStatus_Active name:_name];
}


- (void) setName:(NSString*)name{
    
    
    _name = name;
    self.nameTF.text = name;
    
}

- (void) setLinkage:(XAILinkage*)linkage{

    _linkage = linkage;
    [_linkageService getLinkageDetail:linkage];
    
}

- (void) setLinkageUseInfo:(XAILinkageUseInfo*)useInfo{

    if (_selIndex == nil) return;
    if ([_selIndex row] < [_datas count]) {
    
        [_datas replaceObjectAtIndex:[_selIndex row] withObject:useInfo];
        [self.cTableView reloadData];
        
    }else if([_selIndex row] == [_datas count]){
        [_datas addObject:useInfo];
        
        [self.cTableView reloadData];
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
    return [_datas count] + 1;
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
    
    if ([indexPath row ] < [_datas count]) {
        
        XAILinkageUseInfo * aUseInfo = [_datas objectAtIndex:[indexPath row]];
        
        
        [cell setJieGuo:[aUseInfo toStrIsCond:false]];
        
        
        cell.delegate = self;
        
        [cell isEidt:_gEditing];
        
    }else{
        
        
        [cell setJieGuo:nil];
        
        [cell isEidt:false];
        
    }

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:false];
    
}

-(void)gotoLinkageAddInfoVC:(BOOL)isCond{

    XAILinkageChooseVC* vc = [XAILinkageChooseVC create];
    vc.infoVC = self;
    
    if (isCond) {
        
        [vc setLinkageOneChoosetype:XAILinkageOneType_yuanyin];
        
    }else{
        
        [vc setLinkageOneChoosetype:XAILinkageOneType_jieguo];
    }
    
    
    [self.navigationController pushViewController:vc animated:true];
}


#pragma mark - delgate
-(void)linkageInfoCellDelClick:(XAILinkageEditCell *)cell{

    NSIndexPath* indexPatn = [self.cTableView indexPathForCell:cell];
    [_datas removeObjectAtIndex:[indexPatn row]];
    
    [self.cTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPatn]
                            withRowAnimation:UITableViewRowAnimationAutomatic];

}

-(void)linkageInfoCellResultClick:(XAILinkageEditCell *)cell{
    
    XAILinkageChooseVC* vc = [XAILinkageChooseVC create];
    vc.infoVC = self;
    
    NSIndexPath* indexPath = [self.cTableView indexPathForCell:cell];
    

    _selIndex = indexPath;
    
    [self gotoLinkageAddInfoVC:false];
    
    


}

-(void)linkageService:(XAILinkageService *)service addStatusCode:(XAI_ERROR)errcode{

    NSString* tip = @"添加联动错误";
    
    if (errcode == XAI_ERROR_NONE) {
        
        tip = @"添加联动成功";
    }else if (errcode == XAI_ERROR_TIMEOUT){
        tip = @"添加联动超时";
    }

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:tip
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
    
    
    _activityView.hidden = true;

}

-(void)linkageService:(XAILinkageService *)service delStatusCode:(XAI_ERROR)errcode otherID:(int)otherID{

    [self addLinkage];
}

-(void)linkageService:(XAILinkageService *)service getLinkageDetail:(XAILinkage *)linkage statusCode:(XAI_ERROR)errcode{

    if (errcode == XAI_ERROR_NONE) {
        
        _datas = [[NSMutableArray alloc]init];
        //[_datas addObject:linkage.effeInfo];
        
        _nameTF.text = linkage.name;
        _condTF.text = [linkage.effeInfo toStrIsCond:true];
        
        [_datas addObjectsFromArray:linkage.condInfos];
        
        [self.cTableView reloadData];
    }

}


@end
