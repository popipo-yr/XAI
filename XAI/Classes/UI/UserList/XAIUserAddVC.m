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

- (IBAction)sexClick:(id)sender {
    
    
    [self.sexBtn setSelected:!self.sexBtn.isSelected];
}

- (IBAction)headImgClick:(id)sender {
}


- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        _addUserInfoAry = [[NSArray alloc] initWithObjects:NSLocalizedString(@"UserNameTip", nil)
                           ,NSLocalizedString(@"UserPawdTip", nil),
                           NSLocalizedString(@"UserRepPawdTip", nil), nil];
        
        _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn
                                                       Luid:MQTTCover_LUID_Server_03];
        
        
        _activityView = [[UIActivityIndicatorView alloc] init];
        
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityView.color = [UIColor redColor];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _activityView.frame = CGRectMake(_activityView.frame.origin.x,
                                     _activityView.frame.origin.y - 130,
                                     _activityView.frame.size.width,
                                     _activityView.frame.size.height);
    
    [self.view addSubview:_activityView];
    

    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    UIImage* backImg = [UIImage imageWithFile:@"back_nor.png"] ;
    
    if ([backImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
        
        backImg = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithImage:backImg
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(back)];
    
    [backItem ios6cleanBackgroud];
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    [_userNameTF addTarget:self action:@selector(nameFinish:)
          forControlEvents:UIControlEventEditingDidEndOnExit];
    

    _userPawdTF.secureTextEntry = true;
    [_userPawdTF addTarget:self action:@selector(pawdFinish:)
          forControlEvents:UIControlEventEditingDidEndOnExit];
    

    _userPawdRepTF.secureTextEntry = true;
    [_userPawdRepTF addTarget:self action:@selector(pawdRepFinish:)
             forControlEvents:UIControlEventEditingDidEndOnExit];

    _userNameTF.delegate = self;
    _userPawdTF.delegate = self;
    _userPawdRepTF.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{

    [_userNameTF resignFirstResponder];
    [_userPawdRepTF resignFirstResponder];
    [_userPawdTF resignFirstResponder];
    [self.view endEditing:false];
    
    [super viewWillDisappear:animated];
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:true];
}

int prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY; //编辑的时候移动的高度

// 下面两个方法是为了防止TextFiled让键盘挡住的方法
/**
 开始编辑UITextField的方法
 */
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGPoint Point =  [textField convertPoint:textField.frame.origin toView:self.view];
    
    float textY = Point.y;
    float bottomY = self.view.frame.size.height-textY;
    float keyboardHeight = 240;
    if(bottomY>=keyboardHeight)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
    {
        prewTag = -1;
        return;
    }
    prewTag = textField.tag;
    float moveY = keyboardHeight-bottomY;
    prewMoveY = moveY;
    
    NSTimeInterval animationDuration = 1.0f;
    CGRect frame = self.view.frame;
    frame.origin.y -=moveY;//view的Y轴上移
    frame.size.height +=moveY; //View的高度增加
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

/**
 结束编辑UITextField的方法，让原来的界面还原高度
 */
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if(prewTag == -1) //当编辑的View不是需要移动的View
    {
        return;
    }
    float moveY ;
    NSTimeInterval animationDuration = 1.0f;
    CGRect frame = self.view.frame;
    if(prewTag == textField.tag) //当结束编辑的View的TAG是上次的就移动
    {   //还原界面
        moveY =  prewMoveY;
        frame.origin.y +=moveY;
        frame.size. height -=moveY;
        self.view.frame = frame;
    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    
    
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

- (IBAction)okBtnClick:(id)sender{
    
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
    
    [_activityView startAnimating];
    _activityView.hidden = false;
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
        _userPawdTF.secureTextEntry = true;
        [_userPawdTF addTarget:self action:@selector(pawdFinish:)
              forControlEvents:UIControlEventEditingDidEndOnExit];
        
    }else if (2 == [indexPath row]){
    
        _userPawdRepTF = cell.textFiled;
        _userPawdRepTF.secureTextEntry = true;
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
    
    _activityView.hidden = true;

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
