//
//  ViewControllerEx.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevShowVC.h"

#import "XAIDevShowCell.h"
#import "XAIObjectGenerate.h"
#import "XAIDevShowStatusVCGenerate.h"

#import "XAIData.h"

#define  constRect  CGRectMake(0, 0, 320, 0)

@interface XAIDevShowVC ()

@end

@implementation XAIDevShowVC

- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];

    if (self) {
        // Custom initialization
        
        _deviceService = [[XAIDeviceService alloc] init];
        _deviceService.apsn = [MQTT shareMQTT].apsn;
        _deviceService.luid = MQTTCover_LUID_Server_03;
        _deviceService.deviceServiceDelegate = self;
        
        _deviceDatas = [[NSMutableArray alloc] initWithArray:[[XAIData shareData] getNormalObjList]];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [[XAIData shareData] addRefreshDelegate:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[XAIData shareData] removeRefreshDelegate:self];
    [super viewDidDisappear:animated];
}

- (void) dealloc{
    
    _deviceService.deviceServiceDelegate = nil;
    _deviceService = nil;
    //_activityView = nil;
    
    _deviceDatas = nil;

}

-(void)xaiDataRefresh:(XAIData *)data{

    _deviceDatas = [[NSMutableArray alloc] initWithArray:[[XAIData shareData] getNormalObjList]];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //back
    [self.navigationItem OnlyBack];

    
    [_deviceService findAllDev];

}


- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]){
        
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table Data Source Methods


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return constRect.size.height;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    
//    UIView* showViews = [[UIView alloc] initWithFrame:constRect];
//    UILabel* aLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 100, 30)];
//    [aLabel setText:[NSString stringWithFormat:@"分组名称"]];
//    [showViews addSubview:aLabel];
//    
//    return showViews;
//    
//    
//    UIImageView* showView =  [[UIImageView alloc] initWithFrame:constRect];
//    
//    [showView setBackgroundColor:[UIColor blackColor]];
//    
//    return showView;
//
//}



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
    static NSString *CellIdentifier = @"DeviceShowCellIdentifier";
    
    XAIDevShowCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XAIDevShowCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
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
    
    return cell;
}



#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if ([indexPath row] < [_deviceDatas count]) {
        
        XAIObject* obj = [_deviceDatas objectAtIndex:[indexPath row]];
        
        [self.navigationController pushViewController:
         [XAIDevShowStatusVCGenerate statusWithObject:obj storyboard:self.storyboard] animated:YES];
        
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- DeviceServiceDelegate
- (void) findedAllDevice:(BOOL)isSuccess datas:(NSArray *)devAry{
    
    
    NSMutableArray* objects = [[NSMutableArray alloc] init];
    
    if (isSuccess == TRUE) {
        
        for (int i = 0; i < [devAry count]; i++) {
            
            XAIDevice* device = [devAry objectAtIndex:i];
            
            if (nil != device && [device isKindOfClass:[XAIDevice class]]) {
                
                
                
                XAIObject* aObj = [[XAIObject alloc] init]; /*灯，门*/
                
                aObj.type = 22; /*?????这里是从device获取,灯，门,还是本地记录,远处获取*/
                
                aObj.groupId = 22; /*本地数据判断  guid 与 groupid 的对应表*/
                aObj.apsn = device.apsn;
                aObj.luid = device.luid;
                
                [objects addObject:aObj];
             
                
            }
        }
        
       
    }else{
        
        NSLog(@"find error");
    }
    
    
    [_activityView stopAnimating];
    
}

- (void) finddedAllOnlineDevices:(NSSet *)luidSet{
    
    
    
}





@end
