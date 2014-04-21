//
//  ViewControllerEx.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "DeviceShowVC.h"
#import "DeviceShowCell.h"

#define  constRect  CGRectMake(0, 0, 320, 50)

@interface DeviceShowVC ()

@end

@implementation DeviceShowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    //self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
    //self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
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




@end
