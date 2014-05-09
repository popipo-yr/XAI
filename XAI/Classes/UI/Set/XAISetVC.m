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
        
        _userItems = [[NSArray alloc] initWithObjects:NSLocalizedString(@"LabelUserName", nil),
                      NSLocalizedString(@"LabelPawd", nil),nil];
        
        _userInfo = [MQTT shareMQTT].curUser;
        
        _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn
                                                       Luid:MQTTCover_LUID_Server_03];
        _userService.userServiceDelegate = self;
        //_userInfo.name = @"小明";
        //_userInfo.pawd = @"98980454";
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        _userItems = [[NSArray alloc] initWithObjects:NSLocalizedString(@"LabelUserName", nil),
                      NSLocalizedString(@"LabelPawd", nil),nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userInfo = [MQTT shareMQTT].curUser;

    
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

- (void) changeHomeName:(NSString*)newName{
    
    _homeName = newName;
}

- (void) changeUserName:(NSString*)newName{
    
    _newName = newName;
    [_userService changeUser:_userInfo.luid withName:newName];
}

- (void) changePassword:(NSString*)newPwd{
    
    _newPwd = newPwd;
    [_userService changeUser:_userInfo.luid oldPassword:_userInfo.pawd to:newPwd];
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
        
        cell.lable.text = NSLocalizedString(@"Home", nil);
        
        [cell setTextFiledWithLable:@"小明爱家"];
        
    }else if ([indexPath row] == _key_name_index) {
        
        cell.lable.text = NSLocalizedString(@"UserName", nil);
        
        [cell setTextFiledWithLable:_userInfo.name];
        
    }else if([indexPath row] == _key_pawd_index){
        
        cell.lable.text = NSLocalizedString(@"UserPawd", nil);
        
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
        
        [nameVC setOneLabName:NSLocalizedString(@"Home", nil)
                   OneTexName:_userInfo.name
                   TwoLabName:NSLocalizedString(@"HomeNewName", nil)];
        [nameVC setOKClickTarget:self Selector:@selector(changeHomeName:)];
        [nameVC setBarTitle:NSLocalizedString(@"HomeNameChange", nil)];
        
        _homeVC = nameVC;
        
        [self.navigationController pushViewController:nameVC animated:YES];
        
    }else if ([indexPath row] == _key_name_index) {
        
        XAIChangeNameVC* nameVC = [self.storyboard
                                   instantiateViewControllerWithIdentifier:@"XAIChangeNameVCID"];
        
        [nameVC setOneLabName:NSLocalizedString(@"UserName", nil)
                   OneTexName:_userInfo.name
                   TwoLabName:NSLocalizedString(@"UserNewName", nil)];
        [nameVC setOKClickTarget:self Selector:@selector(changeUserName:)];
        [nameVC setBarTitle:NSLocalizedString(@"UserNameChange", nil)];
        
        _nameVC = nameVC;
        
        [self.navigationController pushViewController:nameVC animated:YES];
        
    }else if ([indexPath row] == _key_pawd_index){
        
        
        XAIChangePasswordVC* pawVC = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"XAIChangePasswordVCID"];
        
        [pawVC setOldPwd:_userInfo.pawd];
        [pawVC setOKClickTarget:self Selector:@selector(changePassword:)];
        [pawVC setBarTitle:NSLocalizedString(@"UserPawdChange", nil)];
        
        _pawVC = pawVC;
        
        [self.navigationController pushViewController:pawVC animated:YES];
    }
    
    
}


-(void)userService:(XAIUserService *)userService changeUserName:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (isSuccess) {
        
        [_nameVC endOkEvent];
        _userInfo.name = _newName;
        
        [self.tableView reloadData];
        
    }else{
        
        [_nameVC endFailEvent:NSLocalizedString(@"UserPawdChangeSuc", nil)];
    }
    
    
}

-(void)userService:(XAIUserService *)userService changeUserPassword:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (isSuccess) {
        
        [_pawVC endOkEvent];
        _userInfo.pawd = _newPwd;
        
        [self.tableView reloadData];
        
    }else{
        
        [_pawVC endFailEvent:NSLocalizedString(@"UserPawdChangeFaild", nil)];
    }
    
    
}


@end
