//
//  XAILinkageAddInfoVC.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageChooseVC.h"
#import "XAIData.h"
#import "XAIObjectGenerate.h"
#import "XAILinkageChooseCell.h"


#define _ST_XAILinkageChooseVCID @"XAILinkageChooseVCID"


#define _L_Timer @0
#define _L_Switch @1
#define _L_DC  @2
#define _L_INF @3
#define _L_Type int

@implementation XAILinkageChooseVC

+(XAILinkageChooseVC*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    XAILinkageChooseVC* vc = (XAILinkageChooseVC*)[show_Storyboard instantiateViewControllerWithIdentifier:_ST_XAILinkageChooseVCID];
    //[vc changeIphoneStatusClear];
    return vc;
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        UIView* view = [[[UINib nibWithNibName:@"Link_Choose" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] lastObject];
        
        if ([view isKindOfClass:[view class]]) {

            _oneview = view;
        }
        

    }
    
    return self;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    [self.view addSubview:_oneview];
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void) setLinkageOneChoosetype:(XAILinkageOneType)type{

    _type = type;
    
    if (type == XAILinkageOneType_jieguo) {
        _datas = [[NSArray alloc] initWithArray:[self getJieGuo]];
    }else{
        _datas = [[NSArray alloc] initWithArray:[self getTiaojian:[XAILight class]]];
    }
    
    
    _lTableViewDatas = [NSArray arrayWithObjects:_L_Timer,_L_Switch,_L_DC,_L_INF, nil];
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:false
                          scrollPosition:UITableViewScrollPositionTop];
    _rTableViewDatas = [[NSArray alloc] initWithArray:[self getTiaojian:[XAILight class]]];
}

- (NSArray*) getTiaojian:(Class)type{

    NSArray* objs = [[XAIData shareData] listenObjs];
    
    NSMutableArray* tiaojianObjs = [[NSMutableArray alloc] init];
    
    for (XAIObject* obj in objs) {
        
        if ([obj hasLinkageTiaojian] && [obj isKindOfClass:type]) {
            
            [tiaojianObjs addObject:obj];
        }
    }
    
    
    return tiaojianObjs;

}


- (NSArray*) getJieGuo{
    
    NSArray* objs = [[XAIData shareData] listenObjs];
    
    NSMutableArray* tiaojianObjs = [[NSMutableArray alloc] init];
    
    for (XAIObject* obj in objs) {
        
        if ([obj hasLinkageJieGuo]) {
            
            [tiaojianObjs addObject:obj];
        }
    }
    
    
    return tiaojianObjs;
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_datas count] + 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellID = _C_XAILinkageChooseCellID;
    
    XAILinkageChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil || ![cell isKindOfClass:[UITableViewCell class]]) {
        cell = [[XAILinkageChooseCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
    }
    
    if ([indexPath row] == 0) {
        if (_type == XAILinkageOneType_jieguo) {
            [cell setTip:@"添加延时"];
        }else{
            [cell setTip:@"添加定时"];
        }
        
        return cell;
    }
    
    
    XAIObject* obj = [_datas objectAtIndex:[indexPath row] - 1];
    
    if (obj.nickName != nil && [obj.nickName isEqualToString:@""]) {
        
        [cell setTip:obj.nickName];
        
    }else{
    
        [cell setTip:obj.name];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    if ([indexPath row] == 0) {
        
//        if (_linkageTime == nil) {
//            
//            _linkageTime = [[[UINib nibWithNibName:@"LinkageTime" bundle:[NSBundle mainBundle]] instantiateWithOwner:nil options:nil] lastObject];
////            _linkageTime = (XAILinkageTime*)[[[NSBundle mainBundle] loadNibNamed:@"LinkageTime"
////                                                                         owner:nil
////                                                                       options:nil] lastObject];
//            
//            
//            [_linkageTime.closeBtn addTarget:self action:@selector(closeClick:)
//                             forControlEvents:UIControlEventTouchUpInside];
//            
//            [_linkageTime.bgBtn addTarget:self action:@selector(closeClick:)
//                          forControlEvents:UIControlEventTouchUpInside];
//
//            
//            [_linkageTime.rightBtn addTarget:self action:@selector(dateChoose:)
//                             forControlEvents:UIControlEventTouchUpInside];
//
//        }
        
        if (_type == XAILinkageOneType_jieguo) {
            
            //[_linkageTime setYanShi];
            //[self.view addSubview:_linkageTime];
            //self.tableView.scrollEnabled = false;
            
        }else{
            
            //[_linkageTime setDingShi];
            //[self.view addSubview:_linkageTime];
            //self.tableView.scrollEnabled = false;

            
        }

        return;
    }
    
    int index = [indexPath row] - 1;
    
    if (index < [_datas count]) {
        
        XAIObject* obj = [_datas objectAtIndex:index];
//        
//        if (_linkageAlert == nil) {
//            _linkageAlert = (XAILinkageAlert*)[[[NSBundle mainBundle] loadNibNamed:@"LinkageAlert" owner:nil options:nil] lastObject];
//            
//            [_linkageAlert.closeBtn addTarget:self action:@selector(closeClick:)
//                             forControlEvents:UIControlEventTouchUpInside];
//            
//            [_linkageAlert.bgBtn addTarget:self action:@selector(closeClick:)
//                             forControlEvents:UIControlEventTouchUpInside];
//            
//            [_linkageAlert.leftBtn addTarget:self action:@selector(leftClick:)
//                             forControlEvents:UIControlEventTouchUpInside];
//            
//            [_linkageAlert.rightBtn addTarget:self action:@selector(rightClick:)
//                             forControlEvents:UIControlEventTouchUpInside];
//        }
//        
        BOOL willAdd = false;

        if ([obj isKindOfClass:[XAILight class]]) {
            
            
            _curObj = obj;
            
//            if (_type == XAILinkageOneType_jieguo) {
//                [_linkageAlert setLightOpr:obj.name];
//            }else{
//                [_linkageAlert setLight:obj.name];
//            }
            
            
            willAdd = true;
            
        }
        
        if ([obj isKindOfClass:[XAIDoor class]] ||
            [obj isKindOfClass:[XAIWindow class]]) {
            
            _curObj = obj;
            
//            [_linkageAlert setDW:obj.name];
            willAdd = true;
            
        }
        
        if ([obj isKindOfClass:[XAIIR class]]) {
            
            _curObj = obj;
            
            //[_linkageAlert setIR:obj.name];
            willAdd = true;
            
        }
        
        if (willAdd) {
            
            //[self.view addSubview:_linkageAlert];
            
            //self.tableView.scrollEnabled = false;

            
        }

    }
    


    
}


#pragma mark - normal alert 
- (void) closeClick:(id)sender{
    
//    if (_linkageAlert.superview != nil) {
//        [_linkageAlert removeFromSuperview];
//    }
//    
//    if (_linkageTime.subviews != nil) {
//        [_linkageTime removeFromSuperview];
//    }
    
     //self.tableView.scrollEnabled = true;
    
}

- (void)rightClick:(id)sender{
    
    NSArray* ary =  [_curObj getLinkageTiaojian];
    
    XAILinkageUseInfo*  use = nil;
    
    if (ary != nil && [ary count] > 1) {
       use =  [ary objectAtIndex:1];
    }
    
    [self.infoVC setLinkageUseInfo:use];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)leftClick:(id)sender{
    
    
    NSArray* ary =  [_curObj getLinkageTiaojian];
    
    XAILinkageUseInfo*  use = nil;
    
    if (ary != nil && [ary count] > 0) {
        use =  [ary objectAtIndex:0];
    }
    
    [self.infoVC setLinkageUseInfo:use];
    
    [self.navigationController popViewControllerAnimated:YES];

    
}

- (void)dateChoose:(id)sender{
    
//    NSDate* date= [_linkageTime.dataPicker date];
//    
//    NSDateFormatter* hourFormat = [[NSDateFormatter alloc] init];
//    [hourFormat setDateFormat:@"HH"];
//    
//    NSDateFormatter* minuFormat = [[NSDateFormatter alloc] init];
//    [minuFormat setDateFormat:@"mm"];
//    
//    int hour =[[hourFormat stringFromDate:date] intValue];
//    int min = [[minuFormat stringFromDate:date] intValue];
//    
//    
//    if (_linkageTime.dataPicker.datePickerMode == UIDatePickerModeCountDownTimer) {
//        float couteDown = _linkageTime.dataPicker.countDownDuration;
//        hour = couteDown / 60 / 60;
//        min  = (couteDown - hour*60*60)/ 60;
//    }
//    
//    
//    
//    XAILinkageUseInfoTime* timeUseInfo = [[XAILinkageUseInfoTime alloc] init];
//    timeUseInfo.time = hour*60*60 + min*60;
//    [timeUseInfo change];
//    
//    [self.infoVC setLinkageUseInfo:timeUseInfo];
//
//    [self.navigationController popViewControllerAnimated:YES];
//
}


-(void)attr1BtnClick:(id)sender{

}

-(void)attr2BtnClick:(id)sender{

}


@end