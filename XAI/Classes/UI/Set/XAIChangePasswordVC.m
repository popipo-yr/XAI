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
    
    
    
    self.navigationItem.title = @"";
    
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    _activityView = [[UIActivityIndicatorView alloc] init];
    _activityView.color = [UIColor redColor];
    _activityView.frame = CGRectMake((winSize.width - _activityView.frame.size.width)*0.5,
                                     (winSize.height - _activityView.frame.size.height)*0.5,
                                     _activityView.frame.size.width,
                                     _activityView.frame.size.height);
    
    
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
    

    _nePwdRepTextField.delegate = self;
    _nePwdTextField.delegate = self;
    _oldPwdTextField.delegate = self;
    
    
    [_nePwdRepTextField addTarget:self action:@selector(editEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_nePwdTextField addTarget:self action:@selector(editEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_oldPwdTextField addTarget:self action:@selector(editEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.view addSubview:_activityView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) back{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
int tag = 0;
int moveUp = 0;
_M_KeyboardMoveView(self.view, self.moveView, tag,moveUp);


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - Outer Methods

- (void) setOKClickTarget:(id)target Selector:(SEL)selector{
    
    _okTarget = target;
    _okSelector = selector;
}

- (void) setOldPwd:(NSString *)oldPWD{
    
    _oldPwd = oldPWD;

    
}

- (void) endOkEvent{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"ChangePawdSuc", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                          otherButtonTitles:nil];
    
    [alert show];
    
    [self stopAnimal];
}

- (void) endFailEvent:(NSString*)str{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                          otherButtonTitles:nil];
    
    [alert show];
    
    [self stopAnimal];
}

- (void) editEnd:(id)sender{
    
    if (sender == _oldPwdTextField) {
        
        //[_oldPwdTextField resignFirstResponder];
        [_nePwdTextField becomeFirstResponder];
        
    }if (sender == _nePwdTextField) {
        
        //[_nePwdTextField resignFirstResponder];
        [_nePwdRepTextField becomeFirstResponder];
        
    }else if(sender == _nePwdRepTextField){
    
        [_nePwdRepTextField resignFirstResponder];
    
    }
    
}


-(void)okClick:(id)sender{
    
    
    BOOL hasErr = true;
    
    NSString* errTip = nil;
    
    do {
        
        if (nil == _oldPwdTextField.text ||[_oldPwdTextField.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"旧密码不能为空", nil);
            break;
        }
        
        if (nil == _nePwdTextField.text ||[_nePwdTextField.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"新密码不能为空", nil);
            break;
        }
        
        if (nil == _nePwdRepTextField.text ||[_nePwdRepTextField.text isEqualToString:@""]) {
            
            errTip = NSLocalizedString(@"重复密码不能为空", nil);
            break;
        }
        
        if (![_oldPwdTextField.text isEqualToString:_oldPwd]) {
            
            errTip = NSLocalizedString(@"输入的旧密码与原来不一致", nil);
            break;
        }
        
        if (![_nePwdTextField.text onlyHasNumberAndChar]) {
            
            errTip = NSLocalizedString(@"UserChangePawdErr", @"password string is not  require style");
            break;
        }
        
        if (![_nePwdTextField.text isNameOrPawdLength]) {
            
            errTip = NSLocalizedString(@"UserChangePawdLengthErr", @"username string leangth is not require length");
            break;
        }
        
     
        if (![_nePwdTextField.text isEqualToString:_nePwdRepTextField.text]) {
            
            errTip = NSLocalizedString(@"UserChangePawdNotSame", nil);
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

    
    
    if (_okTarget != nil && _okSelector != nil
        && [_okTarget respondsToSelector:_okSelector]) {
        
        [_okTarget performSelector:_okSelector withObject:_nePwdTextField.text afterDelay:0];
    }
    
    [self starAnimal];
    
}

- (void) setBarTitle:(NSString*)title{
    
    _barItemTitle = title;
}

- (void) starAnimal{
    [_activityView startAnimating];
    _activityView.hidden = false;
}
- (void) stopAnimal{
    _activityView.hidden = true;
}

@end
