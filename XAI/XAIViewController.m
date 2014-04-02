//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIViewController.h"

@interface XAIViewController ()

@end

@implementation XAIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginBtnClick:(id)sender{
    
    

    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"XAIMainPage"] animated:YES completion:nil];
}

@end
