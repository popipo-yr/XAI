//
//  XAIChangePasswordVC.m
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIChangePasswordVC.h"
#import "XAIChangeCell.h"

@interface XAIChangePasswordVC ()

@end

@implementation XAIChangePasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    
    UIBarButtonItem* okItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(okClick:)];
    
    self.navigationItem.rightBarButtonItem = okItem;
    
    self.navigationItem.title = _barItemTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString* cellID = @"XAIChangePasswordVCCellID";
    
    XAIChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil || ![cell isKindOfClass:[XAIChangeCell class]]) {
        cell = [[XAIChangeCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
    }
    
    
    
    if ([indexPath row] == 0) {
        
        cell.lable.text = @"旧密码";
        
        [cell setTextFiledWithLable:_oldPwd];
        
        NSMutableString* dottedPassword = [[NSMutableString alloc] init];
        
        for (int i = 0; i < [_oldPwd length] -1 ; i++)
        {
            [dottedPassword appendString:@"●"]; // BLACK CIRCLE Unicode: U+25CF, UTF-8: E2 97 8F
        }
        
        NSRange range;
        range.length = 1;
        range.location = [_oldPwd length] - 1;
        
        [dottedPassword appendString:[_oldPwd substringWithRange:range]];
        
        [cell setTextFiledWithLable:dottedPassword];
        
        
    }else if([indexPath row] == 1){
        
        cell.lable.text = @"新密码";
        
        _newPwdTextField = cell.textFiled;
        [cell.textFiled addTarget:self action:@selector(editEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        cell.textFiled.secureTextEntry = YES;
        
    }else if([indexPath row] == 2){
        
        cell.lable.text = @"重复密码";
        
        _newPwdRepTextField = cell.textFiled;
        [cell.textFiled addTarget:self action:@selector(editEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        cell.textFiled.secureTextEntry = YES;
        
    }
    
   // cell.textFiled.secureTextEntry = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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

#pragma  mark - Outer Methods

- (void) setOKClickTarget:(id)target Selector:(SEL)selector{
    
    _okTarget = target;
    _okSelector = selector;
}

- (void) setOldPwd:(NSString *)oldPWD{
    
    _oldPwd = oldPWD;

    
}

- (void) endOkEvent{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) editEnd:(id)sender{
    
    if (sender == _newPwdTextField) {
        
        [_newPwdTextField resignFirstResponder];
        [_newPwdRepTextField becomeFirstResponder];
        
    }else if(sender == _newPwdRepTextField){
    
        [_newPwdRepTextField resignFirstResponder];
    
    }
    
}


- (void) okClick:(id)sender{
    
    if (_okTarget != nil && _okSelector != nil
        && [_okTarget respondsToSelector:_okSelector]) {
        
        [_okTarget performSelector:_okSelector withObject:_newPwdTextField.text afterDelay:0];
    }
    
    
}

- (void) setBarTitle:(NSString*)title{
    
    _barItemTitle = title;
}


@end
