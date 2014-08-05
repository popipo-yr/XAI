//
//  XAIUserListVC.m
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUserListVC.h"

#import "XAIUserAddVC.h"
#import "XAIUserEditVC.h"

@interface XAIUserListVC ()

@end

@implementation XAIUserListVC


- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn
                                                       Luid:MQTTCover_LUID_Server_03];
        
        _userService.userServiceDelegate = self; 
        
        
        _userDatasAry = [[NSMutableArray alloc] initWithArray:[[XAIData shareData] getUserList]];
        
        

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


- (void)dealloc{

    [_userService willRemove];
    _userService = nil;
    
}


-(void)xaiDataRefresh:(XAIData *)data{

     _userDatasAry = [[NSMutableArray alloc] initWithArray:[[XAIData shareData] getUserList]];
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Event
- (void)addBtnClick:(id)sender{

    XAIUserAddVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"XAIUserAddVCID"];
    
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)delBtnClick:(NSIndexPath *)index{

    XAIUser* aUser = [_userDatasAry objectAtIndex:[index row]];
    
    NSString* tip =  [[NSString alloc] initWithFormat:NSLocalizedString(@"UserDelTip", nil),aUser.name];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:tip
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"AlertCancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"AlertOK", nil), nil];
    
    [alert show];

}

#pragma mark - UIAlert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView cancelButtonIndex] != buttonIndex) {
        
        XAIUser* aUser = [_userDatasAry objectAtIndex:[_curDelIndexPath row]];
        [_userService delUser:aUser.luid];
        
    }else{
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_curDelIndexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    [self setSeparatorStyle:[_userDatasAry count]];
    
    return [_userDatasAry count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XAIUserListVCCellID";
    
    XAIUserListVCCell *cell = [tableView
                            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XAIUserListVCCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    XAIUser* aUser = [_userDatasAry objectAtIndex:[indexPath row]];
    
    if (aUser != nil && [aUser isKindOfClass:[XAIUser class]]) {
        
        [cell.headImageView setBackgroundColor:[UIColor clearColor]];
        [cell.headImageView setImage:[UIImage imageNamed:@"user_head.png"]];
        [cell.nameLable setText:aUser.name];
        
        if (aUser.luid == XAIUSERADMIN) {
            
            [cell.contextLable setText:NSLocalizedString(@"AdminUser", nil)];
        }else{
        
            [cell.contextLable setText:NSLocalizedString(@"NormalUser", nil)];
        }
    }
    
    return cell;
}



#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView  deselectRowAtIndexPath:indexPath animated:false];
    
    return;
    
    if ([indexPath row] < [_userDatasAry count]) {
        
        XAIUser* aUser = [_userDatasAry objectAtIndex:[indexPath row]];
        
        XAIUserEditVC* editVC = [self.storyboard
                                 instantiateViewControllerWithIdentifier:@"XAIUserEditVCID"];
        
        editVC.userInfo = aUser;
        
        [self.navigationController  pushViewController:editVC animated:YES];

        
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)userService:(XAIUserService *)userService delUser:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    if (userService != _userService) return;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                          otherButtonTitles:nil];
    
    if (isSuccess && nil != _curDelIndexPath) {
        
        alert.message = NSLocalizedString(@"DelUserSuc", nil);
        
        //不应该时这里删除
        [_userDatasAry removeObjectAtIndex:[_curDelIndexPath row]];
        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:_curDelIndexPath]
                               withRowAnimation:UITableViewRowAnimationAutomatic];
        
        _curDelIndexPath = nil;
        
    }else{
    
        alert.message = NSLocalizedString(@"DelUserFaild", nil);
    }
    
    [alert show];

}

@end

@implementation XAIUserListVCCell

@end
