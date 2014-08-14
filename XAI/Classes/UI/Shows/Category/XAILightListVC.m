//
//  XAILightListVC.m
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILightListVC.h"

#import "XAIObjectGenerate.h"

@interface XAILightListVC ()

@end

@implementation XAILightListVC

+(UIViewController*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_LightListVCID];
    [vc changeIphoneStatus];
    return vc;
    
}


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _deviceDatas = [[NSMutableArray alloc] initWithArray:[[XAIData shareData] getNormalObjList]];
    [self.tableView reloadData];
    [[XAIData shareData] addRefreshDelegate:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[XAIData shareData] removeRefreshDelegate:self];
    [super viewDidDisappear:animated];
}

- (void) dealloc{
    
    _deviceService.deviceServiceDelegate = nil;
    [_deviceService willRemove];
    _deviceService = nil;
    //_activityView = nil;
    
    _deviceDatas = nil;
    
}

-(void)xaiDataRefresh:(XAIData *)data{
    
    _deviceDatas = [[NSMutableArray alloc] initWithArray:[[XAIData shareData] getNormalObjList]];
    [self.tableView reloadData];
}




#pragma mark Table Data Source Methods





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
    
    XAILightListVCCell *cell = [tableView
                            dequeueReusableCellWithIdentifier:XAILightListCellID];
    if (cell == nil) {
        cell = [[XAILightListVCCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:XAILightListCellID];
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
    
    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
//                                                icon:[UIImage imageNamed:@"like.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                title:@"修改备注"];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
//                                                icon:[UIImage imageNamed:@"facebook.png"]];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
//                                                icon:[UIImage imageNamed:@"twitter.png"]];
//    
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
//                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    cell.leftUtilityButtons = leftUtilityButtons;
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    
    return cell;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{

    //NSLog(@"%d",state);
    return;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bookmark" message:@"Save to favorites successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            break;
        }
        default:
            break;
    }
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // More button is pressed
            UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", nil];
            [shareActionSheet showInView:self.view];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button is pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            //[patterns removeObjectAtIndex:cellIndexPath.row];
            //[patternImages removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    if ([indexPath row] < [_deviceDatas count]) {
//        
//        XAIObject* obj = [_deviceDatas objectAtIndex:[indexPath row]];
//        
//        [self.navigationController pushViewController:
//         [XAIDevShowStatusVCGenerate statusWithObject:obj storyboard:self.storyboard] animated:YES];
//        
//    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end


@implementation XAILightListVCCell

@end
