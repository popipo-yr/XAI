//
//  ViewControllerEx.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "DeviceShowVC.h"
#import "DeviceShowCell.h"
#import "XAIObject.h"

#define  constRect  CGRectMake(0, 0, 320, 0)

@interface DeviceShowVC ()

@end

@implementation DeviceShowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _deviceService = [[XAIDeviceService alloc] init];
        _deviceService.delegate = self;
        _activityView = [[UIActivityIndicatorView alloc] init];
    }
    return self;
}

- (void) dealloc{

    _deviceService.delegate = nil;
    _deviceService = nil;
    _activityView = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:
     [UIColor colorWithRed:255/256.0f green:91/256.0f blue:0 alpha:1]];

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.view  addSubview:view];

    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    _activityView = [[UIActivityIndicatorView alloc] init];
    
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activityView.color = [UIColor redColor];
    _activityView.frame = CGRectMake(rx.size.width * 0.5f, rx.size.height * 0.5f, 0, 0);
    _activityView.hidesWhenStopped = YES;
    
    [_activityView startAnimating];

    
    [_deviceService findAllDevWithApsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table Data Source Methods




//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return constRect.size.height;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//}

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

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    
    return 3;
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeviceShowCellIdentifier";
    
    DeviceShowCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DeviceShowCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    
    [cell.imageView setBackgroundColor:[UIColor redColor]];
    [cell.imageView setImage:nil];
    [cell.nameLable setText:[NSString stringWithFormat:@"名字"]];
    [cell.contextLable setText:[NSString stringWithFormat:@"最后一次操作纪录"]];
    
    // Configure the cell...
    return cell;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
//    
//    static BOOL nibsRegistered = NO;
//    if (!nibsRegistered) {
//        UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
//        nibsRegistered = YES;
//    }
//    
//    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
//    
//    
//    //NSUInteger row = [indexPath row];
//    //NSDictionary *rowData = [self.dataList objectAtIndex:row];
//    
//    //cell.name = [rowData objectForKey:@"name"];
//    //cell.dec = [rowData objectForKey:@"dec"];
//    //cell.loc = [rowData objectForKey:@"loc"];
//    //cell.image = [imageList objectAtIndex:row];
//    
//    return cell;
//}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
//    [tableView setTableFooterView:v];
    
    return nil;
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
