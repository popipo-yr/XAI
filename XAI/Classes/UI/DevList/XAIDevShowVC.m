//
//  ViewControllerEx.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevShowVC.h"
#import "XAIDevShowCell.h"
#import "XAIObject.h"
#import "XAILight.h"
#import "XAIDevShowStatusVC.h"

#define  constRect  CGRectMake(0, 0, 320, 0)

@interface XAIDevShowVC ()

@end

@implementation XAIDevShowVC

- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];

    if (self) {
        // Custom initialization
        
        _deviceService = [[XAIDeviceService alloc] init];
        _deviceService.delegate = self;
        
        _deviceDatas = [[NSMutableArray alloc] init];
        
        XAILight* obj1 = [[XAILight alloc] init];
        obj1.apsn = 0x01;
        obj1.luid = 0x123;
        obj1.type = XAIObjectType_light;
        obj1.lastOpr = @"Mr.O open light at 00.0.2";
        obj1.name = @"客厅大灯";
        
        
        XAILight* obj2 = [[XAILight alloc] init];
        obj2.apsn = 0x01;
        obj2.luid = 0x123;
        obj2.type = XAIObjectType_door;
        obj2.lastOpr = @"Mr.O close door at 00.0.2";
        obj2.name = @"主卧门";
        
        [_deviceDatas addObject:obj1];
        [_deviceDatas addObject:obj2];
    }
    return self;
}

- (void) dealloc{

    _deviceService.delegate = nil;
    _deviceService = nil;
    //_activityView = nil;
    
    _deviceDatas = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //设置statusbar
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        
        
        [[UINavigationBar appearance] setBarTintColor:
         [UIColor colorWithRed:255/256.0f green:91/256.0f blue:0 alpha:1]];
        
    }else{
    
        [[UINavigationBar appearance] setTintColor:
         [UIColor colorWithRed:255/256.0f green:91/256.0f blue:0 alpha:1]];
    
    }
    
   

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    view.backgroundColor=[UIColor whiteColor];
    
    //[self.navigationController.view  addSubview:view];
    [self.tabBarController.view addSubview:view];
    
    //back
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];

    
    [_deviceService findAllDevWithApsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
    
    
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView* showViews = [[UIView alloc] initWithFrame:constRect];
    UILabel* aLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 100, 30)];
    [aLabel setText:[NSString stringWithFormat:@"分组名称"]];
    [showViews addSubview:aLabel];
    
    return showViews;
    
    
    UIImageView* showView =  [[UIImageView alloc] initWithFrame:constRect];
    
    [showView setBackgroundColor:[UIColor blackColor]];
    
    return showView;

}



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
        [cell.headImageView setImage:[UIImage imageNamed:[XAIObject typeImageName:aObj.type]]];
        [cell.nameLable setText:aObj.name];
        [cell.contextLable setText:aObj.lastOpr];
        
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
         [XAIDevShowStatusVC statusWithObject:obj storyboard:self.storyboard] animated:YES];
        
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
