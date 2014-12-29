//
//  XAISafeListVC.m
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAISafeListVC.h"
#import "XAIObjectGenerate.h"

#define _M_CellWidth  35

@interface XAISafeListVC ()

@end

#define _ST_SafeListVCID @"XAISafeListVCID"

@implementation XAISafeListVC

+(UIViewController*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone_Sec" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_SafeListVCID];
    [vc changeIphoneStatus];
    return vc;
    
}


- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[MQTT shareMQTT].curUser isAdmin]) {
        _gEditBtn.hidden = true;
        _gEditBtn.enabled = false;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) lightFireCount{
    
    int count = 0;
    
    if (count > 0) {
        
        
        _gStatusImgView.image = [UIImage imageWithFile:@"switch_tbg_open.png"];
        
    }else{
        
        _gStatusImgView.image = [UIImage imageWithFile:@"switch_tbg.png"];
        
    }
    
}

#pragma mark - actions
-(IBAction)globalEditClick:(id)sender{
    
    _gEditing = !_gEditing;
    
    if (_gEditing == false) {
        
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_nor.png"]
                   forState:UIControlStateNormal];
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_sel.png"]
                   forState:UIControlStateHighlighted];
        
    }else{
        
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_close_nor.png"]
                   forState:UIControlStateNormal];
        [_gEditBtn setImage:[UIImage imageWithFile:@"edit_close_sel.png"]
                   forState:UIControlStateHighlighted];
    }
    
}


-(IBAction)bgGetClick:(id)sender{

}

#pragma mark Table Data Source Methods





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return nil;
    
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 140.0;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

