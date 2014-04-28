//
//  XAIUserAddVC.m
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUserAddVC.h"
#import "XAIChangeCell.h"

@interface XAIUserAddVC ()

@end

@implementation XAIUserAddVC


- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        _addUserInfoAry = [[NSArray alloc] initWithObjects:@"用户名"
                           ,@"密码",@"重复密码", nil];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(okBtnClick:)];
    [self.navigationItem setRightBarButtonItem:okItem];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event

- (void)okBtnClick:(id)sender{

    [_userService addUser:_userNameTF.text Password:_userPawdTF.text];
}

- (void)nameFinish:(id)sender{
    
    [_userNameTF resignFirstResponder];
    [_userPawdTF becomeFirstResponder];
}
- (void)pawdFinish:(id)sender{

    [_userPawdTF resignFirstResponder];
    [_userPawdRepTF becomeFirstResponder];
}
- (void)pawdRepFinish:(id)sender{

    [_userPawdRepTF resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_addUserInfoAry count] > 0) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
     return [_addUserInfoAry count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellID = @"XAIUserAddVCCellID";
    
    
    XAIChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil || ![cell isKindOfClass:[XAIChangeCell class]]) {
        cell = [[XAIChangeCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
    }

    
    cell.lable.text = [_addUserInfoAry objectAtIndex:[indexPath row]];
    

    if (0 == [indexPath row]) {
        
        _userNameTF = cell.textFiled;
        [_userNameTF addTarget:self action:@selector(nameFinish:)
              forControlEvents:UIControlEventEditingDidEndOnExit];
        
    }else if ( 1 == [indexPath row]){
    
        _userPawdTF = cell.textFiled;
        [_userPawdTF addTarget:self action:@selector(pawdFinish:)
              forControlEvents:UIControlEventEditingDidEndOnExit];
        
    }else if (2 == [indexPath row]){
    
        _userPawdRepTF = cell.textFiled;
        [_userPawdRepTF addTarget:self action:@selector(pawdRepFinish:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark Table Delegate Methods
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}

@end
