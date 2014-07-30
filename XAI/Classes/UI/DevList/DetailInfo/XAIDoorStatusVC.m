//
//  XAIDoorStatusVC.m
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDoorStatusVC.h"

@interface XAIDoorStatusVC ()

@end

@implementation XAIDoorStatusVC



- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _door.delegate = self;
    
    [self.navigationItem setTitle:_door.name];
    
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
    
    [_door getCurStatus];
    
    
    self.factoryLabel.text = _door.vender;
    self.modelLabel.text = _door.model;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_door readOprList]; //读取操作表
    _oprDatasAry = [[NSArray alloc] initWithArray:[_door getOprList]];
    
    [_door startControl];
}

-(void)viewWillDisappear:(BOOL)animated{

    [_door endControl];
}





#pragma mark -- DoorDelegate

#define DoorOpenImg  @"obj_door_open.png"
#define DoorCloseImg @"obj_door_close.png"

- (void) door:(XAIDoor *)door curStatus:(XAIDoorStatus)status getIsSuccess:(BOOL)isSuccess{
    
    NSString* imageName = (status == XAIDoorStatus_Open) ?DoorOpenImg : DoorCloseImg;
    
    [_statusView setImage:[UIImage imageNamed:imageName]];
    
    [_activityView stopAnimating];
    
    /*刷新信息*/
    _oprDatasAry = [[NSArray alloc] initWithArray:[_door getOprList]];

}

-(void)door:(XAIDoor *)door curPower:(float)power getIsSuccess:(BOOL)isSuccess{


}


@end
