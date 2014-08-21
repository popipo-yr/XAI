//
//  XAIUserAddVC.m
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUserAddVC.h"
#import "XAIChangeCell.h"

#define XAIUserAddVCID @"XAIUserAddVCID"

@implementation XAIUserAddVC

+(XAIUserAddVC*)create{

    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone_Other" bundle:nil];
    XAIUserAddVC* vc = [show_Storyboard instantiateViewControllerWithIdentifier:XAIUserAddVCID];
    //[vc changeIphoneStatus];
    return vc;

    
}


- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        _addUserInfoAry = [[NSArray alloc] initWithObjects:NSLocalizedString(@"UserNameTip", nil)
                           ,NSLocalizedString(@"UserPawdTip", nil),
                           NSLocalizedString(@"UserRepPawdTip", nil), nil];
        
        _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn
                                                       Luid:MQTTCover_LUID_Server_03];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BarItemOK", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(okBtnClick:)];
    
    [okItem ios6cleanBackgroud];
    
    [self.navigationItem setRightBarButtonItem:okItem];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _userService.userServiceDelegate = nil;
}

#pragma mark - Event

- (void)okBtnClick:(id)sender{
    
    BOOL hasErr = true;
    
    NSString* errTip = nil;
    
    do {
        
        
        if (nil == _userNameTF.text ||[_userNameTF.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"UserAddNameNULL", nil);
            break;
        }
        
        if (nil == _userPawdTF.text ||[_userPawdTF.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"UserAddPawdNULL", nil);
            break;
        }
        
        if (nil == _userPawdRepTF.text ||[_userPawdRepTF.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"UserAddPawdRepNULL", nil);
            break;
        }
        
        
        if (![_userNameTF.text onlyHasNumberAndChar]) {
            
            errTip = NSLocalizedString(@"UserAddNameErr", @"username string is not  require style");
            break;
        }
        
        if (![_userNameTF.text isNameOrPawdLength]) {
            
            errTip = NSLocalizedString(@"UserAddNameLengthErr", @"username string leangth is not require length");
            break;
        }
        
        
        if (![_userPawdTF.text onlyHasNumberAndChar]) {
            
            errTip = NSLocalizedString(@"UserAddPawdErr", @"password string is not  require style");
            break;
        }
        
        if (![_userPawdTF.text isNameOrPawdLength]) {
            
            errTip = NSLocalizedString(@"UserAddPawdLengthErr", @"password string leangth is not require length");
            break;
        }
        
        
        if (![_userPawdTF.text isEqualToString:_userPawdRepTF.text]) {
            
            errTip = NSLocalizedString(@"UserAddPawdNotSame", nil);
            break;
        }
        
        
        hasErr = false;
        
    } while (0);
    
    
    if (hasErr) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errTip
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
        
        
    }
    

    
    _userService.userServiceDelegate = self;
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

- (void) userService:(XAIUserService*)userService addUser:(BOOL) isSuccess errcode:(XAI_ERROR)errcode{
    if (userService != _userService) return;
    
    _userService.userServiceDelegate = nil;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                          otherButtonTitles:nil];

    if (isSuccess ) {
        

        [alert setMessage:NSLocalizedString(@"AddUserSuc", nil)];
        alert.delegate = self;
        
    }else{
        
        if (errcode == XAI_ERROR_NAME_EXISTED) {
            
            [alert setMessage:NSLocalizedString(@"UserNameExist",nil)];
        }
    
        [alert setMessage:NSLocalizedString(@"AddUserFaild", nil)];
    
    }
    
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
