//
//  XAIIRStatusVC.m
//  XAI
//
//  Created by office on 14-7-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIIRStatusVC.h"

@implementation XAIIRStatusVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _IR.delegate = self;
    
    [self.navigationItem setTitle:_IR.name];
    
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
    
    [_IR getCurStatus];
    
    
    self.factoryLabel.text = _IR.vender;
    self.modelLabel.text = _IR.model;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_IR readOprList]; //读取操作表
    _oprDatasAry = [[NSArray alloc] initWithArray:[_IR getOprList]];
    
    [_IR startControl];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [_IR endControl];
}





#pragma mark -- DoorDelegate

#define IRWorking  @"obj_IR_working.png"
#define IRWarning @"obj_IR_warning.png"

- (void) ir:(XAIIR *)ir curStatus:(XAIIRStatus)status getIsSuccess:(BOOL)isSuccess{
    
    NSString* imageName = (status == XAIIRStatus_working) ? IRWorking : IRWarning;
    
    [_statusView setImage:[UIImage imageNamed:imageName]];
    
    [_activityView stopAnimating];
}

-(void)ir:(XAIIR *)ir curPower:(float)power getIsSuccess:(BOOL)isSuccess{
    
    
}


@end
