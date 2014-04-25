//
//  UserVC.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAISetVC.h"
#import "XAIChangeCell.h"
#import "XAIChangeNameVC.h"
#import "XAIChangePasswordVC.h"

#define _key_name_index 1
#define _key_pawd_index 2
#define _key_home_index 0

@interface XAISetVC ()

@end

@implementation XAISetVC


- (id) initWithCoder:(NSCoder *) coder{

    self = [super initWithCoder:coder];
    
    if (self) {
        
        _userItems = [[NSArray alloc] initWithObjects:@"名称",@"密码",nil];
        
        _userInfo = [[XAIUser alloc] init];
        _userInfo.name = @"小明";
        _userInfo.pawd = @"98980454";
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        _userItems = [[NSArray alloc] initWithObjects:@"名称",@"密码",nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.tableView reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeUserName:(NSString*)newName{
    
    
}

- (void) changePassword:(NSString*)newPwd{
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellID = @"XAISetVCCellID";
    
    XAIChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil || ![cell isKindOfClass:[XAIChangeCell class]]) {
        cell = [[XAIChangeCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
    }
    
    
    
    if ([indexPath row] == _key_home_index) {
        
        cell.lable.text = @"家";
        
        [cell setTextFiledWithLable:@"小明爱家"];
        
    }else if ([indexPath row] == _key_name_index) {
        
        cell.lable.text = @"用户";
        
        [cell setTextFiledWithLable:_userInfo.name];
        
    }else if([indexPath row] == _key_pawd_index){
        
        cell.lable.text = @"密码";
        
        [cell setTextFiledWithLable:_userInfo.pawd];
        [cell.textFiled setSecureTextEntry:YES];
        
        
    }
    
    cell.textFiled.enabled = false;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath row] == _key_home_index) {
        
        XAIChangeNameVC* nameVC = [self.storyboard
                                   instantiateViewControllerWithIdentifier:@"XAIChangeNameVCID"];
        
        [nameVC setOneLabName:@"家" OneTexName:_userInfo.name  TwoLabName:@"新名称"];
        [nameVC setOKClickTarget:self Selector:@selector(changeUserName:)];
        [nameVC setBarTitle:@"设置家"];
        
        
        [self.navigationController pushViewController:nameVC animated:YES];
        
    }else if ([indexPath row] == _key_name_index) {
        
        XAIChangeNameVC* nameVC = [self.storyboard
                                   instantiateViewControllerWithIdentifier:@"XAIChangeNameVCID"];
        
        [nameVC setOneLabName:@"用户名" OneTexName:_userInfo.name  TwoLabName:@"新用户名"];
        [nameVC setOKClickTarget:self Selector:@selector(changeUserName:)];
        [nameVC setBarTitle:@"设置名称"];
        
        
        [self.navigationController pushViewController:nameVC animated:YES];
        
    }else if ([indexPath row] == _key_pawd_index){
        
        
        XAIChangePasswordVC* pawVC = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"XAIChangePasswordVCID"];
        
        [pawVC setOldPwd:_userInfo.pawd];
        [pawVC setOKClickTarget:self Selector:@selector(changePassword:)];
        [pawVC setBarTitle:@"设置密码"];
        
        
        [self.navigationController pushViewController:pawVC animated:YES];
    }
    
    
}

@end
