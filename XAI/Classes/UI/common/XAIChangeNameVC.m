//
//  XAIChangeNameVC.m
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIChangeNameVC.h"
#import "XAIChangeCell.h"

@interface XAIChangeNameVC ()

@end

@implementation XAIChangeNameVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.clearsSelectionOnViewWillAppear = YES;
    

    UIBarButtonItem* okItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(okClick:)];
    
    [okItem ios6cleanBackgroud];
    
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

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellID = @"XAIChangeNameVCCellID";
    
    XAIChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil || ![cell isKindOfClass:[XAIChangeCell class]]) {
        cell = [[XAIChangeCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
    }
    
    

    if ([indexPath row] == 0) {
        
        cell.lable.text = _oneLabName;

        [cell setTextFiledWithLable:_oneTexName];
        
    }else if([indexPath row] == 1){
    
        cell.lable.text = _twoLabName;
        _newNameTextField = cell.textFiled;
        [cell.textFiled addTarget:self action:@selector(editEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    }
    
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - Outer Methods

- (void) setOKClickTarget:(id)target Selector:(SEL)selector{

    _okTarget = target;
    _okSelector = selector;
}

- (void) setOneLabName:(NSString*)oneLabName OneTexName:(NSString*)oneTexName
            TwoLabName:(NSString*)twoLabName{

    _oneLabName = oneLabName;
    _oneTexName = oneTexName;
    _twoLabName = twoLabName;

}

- (void) endOkEvent{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改名称成功"
                                                   delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
    
    
}

- (void) endFailEvent:(NSString*)str{

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:str
                                                   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

- (void) editEnd:(id)sender{

    [_newNameTextField resignFirstResponder];
}


- (void) okClick:(id)sender{

    if (_okTarget != nil && _okSelector != nil
        && [_okTarget respondsToSelector:_okSelector]) {
        
        [_okTarget performSelector:_okSelector withObject:_newNameTextField.text afterDelay:0];
    }
    

}

- (void) setBarTitle:(NSString*)title{

    _barItemTitle = title;
}

@end
