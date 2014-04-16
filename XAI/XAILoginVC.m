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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification                                               object:nil];
    
    
    
    
    [self.nameLabel addTarget:self action:@selector(nameLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordLabel addTarget:self action:@selector(passwordLabelReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [passwordLabel setText:nil];
    [passwordLabel setSecureTextEntry:YES];
    [passwordLabel setPlaceholder:@"mima"];
    
    
    [nameLabel setText:nil];
    [nameLabel setPlaceholder:@"your name"];
    
    
    [MQTT shareMQTT].apsn = 0x1;
}


- (void)nameLabelReturn:(id)sender {
    
    [self.passwordLabel becomeFirstResponder];
    
}

- (void)passwordLabelReturn:(id)sender {
    
    [self.passwordLabel resignFirstResponder];
    
}



- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGPoint  oldPoint = self.view.center;
    
    
//    if (self.view.hidden == YES) {
//        return;
//    }
    
//    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
//    NSArray *subviews = [self.view subviews];
//    for (UIView *sub in subviews) {
//        
//        CGFloat maxY = CGRectGetMaxY(sub.frame);
//        if (maxY > y - 2) {
//            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.center.y - maxY + y - 2);
//        }
//    }
    
    self.view.center = CGPointMake(oldPoint.x , oldPoint.y - 120);
    
    [UIView commitAnimations];
}



- (void)keyboardWillHide:(NSNotification *)notif {
    
    CGPoint  oldPoint = self.view.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];

    
    self.view.center = CGPointMake(oldPoint.x , oldPoint.y + 120);

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static int i = 0;

- (IBAction)loginBtnClick:(id)sender{
    
    if (i == 0) {
        
        i = 5;
        _login = [[XAILogin alloc] init];
        [_login loginWithName:@"admin" Password:@"admin" Host:@"192.168.1.1" apsn:0x1];
    
    }else if(i == 5) {
        
        i = 7;
        //[[MQTT shareMQTT].client subscribe:@"/0/server/3"];
        
        [[MQTT shareMQTT].client subscribe:@"0x00000001/SERVER/0x0000000000000003/OUT/+"];
        [[MQTT shareMQTT].client subscribe:@"0x00000001/MOBILES/0x0000000000000001/IN"];
        //[[MQTT shareMQTT].client subscribe:[MQTTCover serverStatusTopicWithAPNS:0 luid:1 other:1]];
        //[[MQTT shareMQTT].client subscribe:[MQTTCover mobileStatusTopicWithAPNS:0 luid:1 other:1]];
        
    }else{
    
       // APServerNode* node = [[APServerNode alloc] init];
       // [node addUser:@"testname" Password:@"password"];

        XAIUserService* userService = [[XAIUserService alloc] init];
        [userService addUser:@"abc" Password:@"bbc" apsn:0x00000001 luid:0x3];
    
    }
    

    
    
 //[self performSegueWithIdentifier:@"XAIMainPageSegue" sender:Nil];
    

//[self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"XAIMainPage"] animated:YES completion:nil];
}

@end
