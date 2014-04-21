//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILoginVC.h"
#import "XAIUserService.h"

@interface XAILoginVC ()

@end

@implementation XAILoginVC

@synthesize nameLabel;
@synthesize passwordLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [passwordLabel setText:nil];
    [passwordLabel setSecureTextEntry:YES];
    [passwordLabel setPlaceholder:@"密码"];
    
    
    [nameLabel setText:nil];
    [nameLabel setPlaceholder:@"用户名"];
    
    
    [MQTT shareMQTT].apsn = 0x1;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification                                               object:nil];
    
    
    
    
    [self.nameLabel addTarget:self action:@selector(nameLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordLabel addTarget:self action:@selector(passwordLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:Nil];
    
    
    
    
    [self.nameLabel removeTarget:self action:@selector(nameLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordLabel removeTarget:self action:@selector(passwordLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];


    [super viewDidDisappear:animated];
}


- (void)nameLabelReturn:(id)sender {
    
    [self.passwordLabel becomeFirstResponder];
    
}

- (void)passwordLabelReturn:(id)sender {
    
    [self.passwordLabel resignFirstResponder];
    
}


#define  moveLength  90

- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGPoint  oldPoint = self.view.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    self.view.center = CGPointMake(oldPoint.x , oldPoint.y - moveLength);
    
    [UIView commitAnimations];
}



- (void)keyboardWillHide:(NSNotification *)notif {
    
    CGPoint  oldPoint = self.view.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];

    
    self.view.center = CGPointMake(oldPoint.x , oldPoint.y + moveLength);

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginBtnClick:(id)sender{
    

    _login = [[XAILogin alloc] init];
    _login.delegate = self;
    
    [_login loginWithName:@"admin" Password:@"admin" Host:@"192.168.1.1" apsn:0x1];


    
    
 //[self performSegueWithIdentifier:@"XAIMainPageSegue" sender:Nil];
    

//[self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"XAIMainPage"] animated:YES completion:nil];
}

- (void)loginFinishWithStatus:(BOOL)status{

    [self performSegueWithIdentifier:@"XAIMainPageSegue" sender:Nil];
    _login = Nil;
    
}

@end
