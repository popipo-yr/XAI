//
//  XAIWindowStatusVC.m
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIWindowStatusVC.h"

@interface XAIWindowStatusVC ()

@end

@implementation XAIWindowStatusVC


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _window.delegate = self;
    
    [self.navigationItem setTitle:_window.name];
    
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
    
    [_window getCurStatus];
    
    
    self.factoryLabel.text = _window.vender;
    self.modelLabel.text = _window.model;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_window readOprList]; //读取操作表
    _oprDatasAry = [[NSArray alloc] initWithArray:[_window getOprList]];
    
    
    [_window startControl];
}


-(void)viewWillDisappear:(BOOL)animated{

    [_window endControl];

}



#pragma mark -- DoorDelegate

#define WindowOpenImg  @"obj_window_open.png"
#define WindowCloseImg @"obj_window_close.png"

-(void)window:(XAIWindow *)window curStatus:(XAIWindowStatus)status getIsSuccess:(BOOL)isSuccess{
    
    NSString* imageName = (status == XAIWindowStatus_Open) ?WindowOpenImg : WindowCloseImg;
    
    [_statusView setImage:[UIImage imageNamed:imageName]];
    
    [_activityView stopAnimating];
}

-(void)window:(XAIWindow *)window curPower:(float)power getIsSuccess:(BOOL)isSuccess{
    
    
}

@end
