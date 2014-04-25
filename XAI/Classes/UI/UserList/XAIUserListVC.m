//
//  XAIUserListVC.m
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUserListVC.h"

@interface XAIUserListVC ()

@end

@implementation XAIUserListVC


- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        _userService = [[XAIUserService alloc] init];
        
        XAIUser* user1 = [[XAIUser alloc] init];
        user1.name = @"ADMIN";
        
        
        XAIUser* user2 = [[XAIUser alloc] init];
        user2.name = @"他大爷";
        
        _userDatasAry = [[NSMutableArray alloc] initWithObjects:user1,user2,nil];

    }
    
    return self;

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
        [cell.contextLable setText:@"普通成员"];
        
    }
    
    return cell;
}



#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([indexPath row] < [_userDatasAry count]) {
        
        XAIUser* aUser = [_userDatasAry objectAtIndex:[indexPath row]];
        
//        [self.navigationController pushViewController:
//         [XAIDevShowStatusVC statusWithObject:obj storyboard:self.storyboard] animated:YES];
        
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

@end

@implementation XAIUserListVCCell

@end
