//
//  XAILightStatusVC.m
//  XAI
//
//  Created by office on 14-4-23.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILightStatusVC.h"

@implementation XAILightStatusVC

- (void)viewDidLoad{

    [super viewDidLoad];
    
    _light.delegate = self;
    
    [self.navigationItem setTitle:_light.name];
    
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
    
    [_light getCurStatus];
    
    //[self performSelector:@selector(lightCurStatus:)];
    
    
//    NSInvocation *anInvocation = [NSInvocation
//                                  invocationWithMethodSignature:
//                                  [XAILightStatusVC instanceMethodSignatureForSelector:@selector(lightCurStatus:)]];
//    
//    [anInvocation setSelector:@selector(lightCurStatus:)];
//    [anInvocation setTarget:self];
//    long status = 1;
//    [anInvocation setArgument:&status atIndex:2];
//    
//    [anInvocation performSelector:@selector(invoke) withObject:nil afterDelay:1];
//    
//    
//    XAIObjectOpr* opr1 = [[XAIObjectOpr alloc] init];
//    //opr1.opr = @"水水开了灯";
//    //opr1.time = @"8:39  03/23";
//    
//    
//    XAIObjectOpr* opr2 = [[XAIObjectOpr alloc] init];
//
//    
//    NSArray* ary = [[NSArray alloc] initWithObjects:opr1,opr2,nil];
    _oprDatasAry = [[NSArray alloc] initWithArray:[_light getOprList]];
    
    
    
    self.factoryLabel.text = _light.vender;//  @"成都xxx工厂";
    self.modelLabel.text = _light.model; //@"JUNENNDENG-8390F";
    
    
}



#pragma mark - IBOUT

- (IBAction)swithChoose:(id)sender{

    if (_switchUI.on == YES) {
        
        [_light openLight];
        
    }else{
    
        [_light closeLight];
    
    }
    
    [_activityView startAnimating];
    
    
//    NSInvocation *anInvocation = [NSInvocation
//                                  invocationWithMethodSignature:
//                                  [XAILightStatusVC instanceMethodSignatureForSelector:@selector(lightCloseSuccess:)]];
//    
//    [anInvocation setSelector:@selector(lightCloseSuccess:)];
//    [anInvocation setTarget:self];
//    BOOL status = YES;
//    [anInvocation setArgument:&status atIndex:2];
//    
//    [anInvocation performSelector:@selector(invoke) withObject:nil afterDelay:1];
}

#pragma mark -- LightDelegate

#define LightOpenImg  @"obj_light_open.png"
#define LightCloseImg @"obj_light_close.png"

- (void) lightOpenSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [_statusView setImage:[UIImage imageNamed:LightOpenImg]];
        
        [_activityView stopAnimating];
        
        XAIObjectOpr* opr = [[XAIObjectOpr alloc] init];
        opr.opr = XAILightStatus_Open;
        opr.time = [NSDate new];
        opr.name = [MQTT shareMQTT].curUserName;
        [_light addOpr:opr];
        
        /*刷新信息*/
        _oprDatasAry = [[NSArray alloc] initWithArray:[_light getOprList]];
        
        [self.oprTableView reloadData];
    }
    
}
- (void) lightCloseSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [_statusView setImage:[UIImage imageNamed:LightCloseImg]];
        
        [_activityView stopAnimating];
        
        
        XAIObjectOpr* opr = [[XAIObjectOpr alloc] init];
        opr.opr = XAILightStatus_Close;
        opr.time = [NSDate new];
        opr.name = [MQTT shareMQTT].curUserName;
        [_light addOpr:opr];
        
        /*刷新信息*/
        _oprDatasAry = [[NSArray alloc] initWithArray:[_light getOprList]];
        
        [self.oprTableView reloadData];

    }
}

- (void) lightCurStatus:(XAILightStatus) status{
    
    NSString* imageName = (status == XAILightStatus_Open) ?LightOpenImg : LightCloseImg;
    
    [self.switchUI setOn:status == XAILightStatus_Open];
    
    [_statusView setImage:[UIImage imageNamed:imageName]];
    
    [_activityView stopAnimating];
}

@end
