//
//  XAIUserEditVC.m
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUserEditVC.h"
#import "XAIChangeCell.h"


@interface XAIUserEditVC ()

@end

@implementation XAIUserEditVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self == [super initWithCoder:aDecoder]) {
        
        _userService = [[XAIUserService alloc] init];
        _userService.apsn = [MQTT shareMQTT].apsn;
        _userService.luid = MQTTCover_LUID_Server_03;
        
        _userService.userServiceDelegate = self;
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


#pragma mark - Event

- (void) changeUserName:(NSString*)newName{

    _newName = newName;
    [_userService changeUser:_userInfo.luid withName:newName];
}

- (void) changePassword:(NSString*)newPwd{
    
    _newPwd = newPwd;
    [_userService changeUser:_userInfo.luid oldPassword:_userInfo.pawd to:newPwd];
}



#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellID = @"XAIUserEditVCCellID";
    
    XAIChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil || ![cell isKindOfClass:[XAIChangeCell class]]) {
        cell = [[XAIChangeCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
    }
    
    
    
    if ([indexPath row] == 0) {
        
        cell.lable.text = @"名称";
        
        [cell setTextFiledWithLable:_userInfo.name];
        
    }else if([indexPath row] == 1){
        
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

    if ([indexPath row] == 0) {
        
        XAIChangeNameVC* nameVC = [self.storyboard
                                   instantiateViewControllerWithIdentifier:@"XAIChangeNameVCID"];
        
        [nameVC setOneLabName:@"用户名" OneTexName:_userInfo.name  TwoLabName:@"新用户名"];
        [nameVC setOKClickTarget:self Selector:@selector(changeUserName:)];
        [nameVC setBarTitle:@"修改名称"];
        
        _nameVC = nameVC;
        
        [self.navigationController pushViewController:nameVC animated:YES];
        
    }else if ([indexPath row] == 1){
    
    
        XAIChangePasswordVC* pawVC = [self.storyboard
                                   instantiateViewControllerWithIdentifier:@"XAIChangePasswordVCID"];
        
        [pawVC setOldPwd:_userInfo.pawd];
        [pawVC setOKClickTarget:self Selector:@selector(changePassword:)];
        [pawVC setBarTitle:@"修改密码"];
        
        _pawVC = pawVC;
        
        [self.navigationController pushViewController:pawVC animated:YES];
    }
    

}

#pragma mark  delegate
-(void)userService:(XAIUserService *)userService changeUserName:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    if (isSuccess) {
        
        [_nameVC endOkEvent];
        _userInfo.name = _newName;
        
        [self.tableView reloadData];
        
    }else{
        
        [_nameVC endFailEvent:@"修改名称失败"];
    }
    
    
}

-(void)userService:(XAIUserService *)userService changeUserPassword:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    if (isSuccess) {
        
        [_pawVC endOkEvent];
        _userInfo.pawd = _newPwd;
        
        [self.tableView reloadData];
        
    }else{
    
        [_pawVC endFailEvent:@"修改密码失败"];
    }
    
    
}

@end
