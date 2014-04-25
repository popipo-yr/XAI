//
//  XAIUserEditVC.m
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUserEditVC.h"
#import "XAIChangeCell.h"
#import "XAIChangeNameVC.h"
#import "XAIChangePasswordVC.h"

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

    
}

- (void) changePassword:(NSString*)newPwd{
    
    
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
        
        
        [self.navigationController pushViewController:nameVC animated:YES];
        
    }else if ([indexPath row] == 1){
    
    
        XAIChangePasswordVC* pawVC = [self.storyboard
                                   instantiateViewControllerWithIdentifier:@"XAIChangePasswordVCID"];
        
        [pawVC setOldPwd:_userInfo.pawd];
        [pawVC setOKClickTarget:self Selector:@selector(changePassword:)];
        [pawVC setBarTitle:@"修改密码"];
        
        
        [self.navigationController pushViewController:pawVC animated:YES];
    }
    

}

@end
