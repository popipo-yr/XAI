//
//  XAILinkageInfoVC.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageInfoVC.h"
#import "XAILinkage.h"
#import "XAILinkageInfoCell.h"
#import "XAILinkageAddInfoVC.h"
#import "XAILinkageListVC.h"

#import "XAIData.h"
#import "XAIObjectGenerate.h"

#define XAILinkageInfoVCID @"XAILinkageInfoVCID"
#define _ST_ShowLinkageInfo @"_ST_ShowLinkageInfo"
@implementation XAILinkageInfoVC

+ (UIViewController*)create:(NSString*)name;{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    UINavigationController* vc = (UINavigationController*)[show_Storyboard instantiateViewControllerWithIdentifier:_ST_ShowLinkageInfo];
    
     [vc changeIphoneStatus];
    
    
    [(XAILinkageInfoVC*)(vc.topViewController) setName:name];
    
    return vc;
    
}

+ (UIViewController*)create:(NSString*)name linkage:(XAILinkage *)linkage{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    UINavigationController* vc = (UINavigationController*)[show_Storyboard instantiateViewControllerWithIdentifier:_ST_ShowLinkageInfo];
    
    [vc changeIphoneStatus];
    
    
    [(XAILinkageInfoVC*)(vc.topViewController) setName:name];
    [(XAILinkageInfoVC*)(vc.topViewController) setLinkage:linkage];
    
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
        
        
        UIImage* backImg = [UIImage imageNamed:@"back_nor.png"] ;
        
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

- (IBAction)backClick:(id)sender{
    
    [self animalVC_L2R:[XAILinkageListVC create]];
    
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
    
    
    NSMutableArray* jieguos = [NSMutableArray arrayWithArray:_datas];
    [jieguos removeObjectAtIndex:0];
    
    [_linkageService addLinkageParams:jieguos ctrlInfo:[_datas objectAtIndex:0] status:XAILinkageStatus_Active name:_name];

}


- (void) setName:(NSString*)name{
    
    
    _name = name;
    self.navigationItem.title = name;
    
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
    
    NSString* cellID = XAILinkageInfoCellID;
    
    XAILinkageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil || ![cell isKindOfClass:[UITableViewCell class]]) {
        cell = [[XAILinkageInfoCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
    }
    
    if ([indexPath row ] < [_datas count]) {
        
        XAILinkageUseInfo * aUseInfo = [_datas objectAtIndex:[indexPath row]];
        
        if (aUseInfo != nil && [aUseInfo isKindOfClass:[XAILinkageUseInfo class]]) {
            
            if (aUseInfo.dev_apsn == 0x0 && aUseInfo.dev_luid == 0x0) {
                //时间
                XAITYPETime time = 0;
                XAILinkageUseInfoTime* timeUseInfo = (XAILinkageUseInfoTime*)aUseInfo;
                if (![timeUseInfo isKindOfClass:[XAILinkageUseInfoTime class]]) {
    
                
                    timeUseInfo = [[XAILinkageUseInfoTime alloc] init];
                    [timeUseInfo setApsn:0 Luid:0 ID:0 Datas:aUseInfo.datas];
                    
                    [_datas replaceObjectAtIndex:[indexPath row] withObject:timeUseInfo];
                }
                
                time = timeUseInfo.time;
                int hour = time/(60*60);
                int minu = (time - (hour*60*60))/60;
                
                if ([indexPath row] == 0) {//条件 定时
                    [cell setTiaojian:[NSString stringWithFormat:@"当%d点%d分时",hour,minu]];
                    
                }else{
                
                    [cell setJieGuo:[NSString stringWithFormat:@"延时%d小时%d分",hour,minu]];

                }
            
                
                
            }else{
                
                XAIObject* obj = [[XAIData shareData] findListenObj:aUseInfo.dev_apsn luid:aUseInfo.dev_luid];
                
                if ([obj isKindOfClass:[XAILight class]]) {
                    
                    if (aUseInfo.some_id == 2) { /*通道二*/
                        obj = [[XAIData shareData] findListenObj:aUseInfo.dev_apsn
                                                            luid:aUseInfo.dev_luid
                                                            type:XAIObjectType_light2_2];
                    }
                }
                
                if (obj == nil) {
                    
                    if ([indexPath row] == 0) {//条件 定时
                        [cell setTiaojian:@"未知信息"];
                        
                    }else{
                        
                        [cell setJieGuo:@"未知信息"];
                        
                    }
                }else{
                    
                    NSString* miaoshu =  [obj linkageInfoMiaoShu:aUseInfo];
                    
                    NSString* name = obj.name;
                    
                    if (obj.nickName != nil && ![obj.nickName isEqualToString:@""]) {
                        name = obj.nickName;
                    }
                    
                    NSString* tip = nil;
                    
                    if ([indexPath row] == 0) {
                        // tiaojian
                        if (miaoshu == nil) {
                            tip = [NSString stringWithFormat:@"%@未知条件",name];
                        }else{
                            tip = [NSString stringWithFormat:@"当%@%@时",name,miaoshu];
                        }
                        
                        [cell setTiaojian:tip];

                        
                    }else{
                        //结果
                        if (miaoshu == nil) {
                            tip = [NSString stringWithFormat:@"%@未知控制",name];
                        }else{
                            tip = [NSString stringWithFormat:@"%@%@",miaoshu,name];
                        }
                        
                        [cell setJieGuo:tip];
                    }
                    
                    
                }
            }
            
        }
        
        cell.delegate = self;
        [cell setDelBtn];
        
    }else{
        
        if ([_datas count] == 0) {
            
            [cell  setTiaojianTip:@"添加条件"];
        }else{
            
            [cell setJieGuoTip:@"添加结果"];
        }
        
        
        
        //        cell.leftUtilityButtons = nil;
        //        cell.rightUtilityButtons = nil;
        //        [cell setAdd];
        
        
    }

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    XAILinkageAddInfoVC* vc = [XAILinkageAddInfoVC create];
    vc.infoVC = self;
    
    if (0 == [indexPath row]) {
        
        
        [vc setLinkageOneChoosetype:XAILinkageOneType_yuanyin];

        
    }else{
    
        
        [vc setLinkageOneChoosetype:XAILinkageOneType_jieguo];
    }
    
    
    
    
    _selIndex = indexPath;
    
    [self.navigationController pushViewController:vc animated:true];
    

    
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{

    NSIndexPath* indexPatn = [self.cTableView indexPathForCell:cell];
    [_datas removeObjectAtIndex:[indexPatn row]];
    
    [self.cTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPatn]
                           withRowAnimation:UITableViewRowAnimationAutomatic];
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

}

-(void)linkageService:(XAILinkageService *)service getLinkageDetail:(XAILinkage *)linkage statusCode:(XAI_ERROR)errcode{

    if (errcode == XAI_ERROR_NONE) {
        
        _datas = [[NSMutableArray alloc]init];
        [_datas addObject:linkage.effeInfo];
        [_datas addObjectsFromArray:linkage.condInfos];
        
        [self.cTableView reloadData];
    }

}


@end
