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

-(instancetype)init{

    if (self = [super init]) {
        
        UIView* view = [[[UINib nibWithNibName:@"Link_Choose" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] lastObject];
        
        if ([view isKindOfClass:[view class]]) {
            
            _oneview = view;
        }
        
        
    }
    
    return self;
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
    
    _oneview.frame = CGRectMake(0, 0,
                                self.view.frame.size.width,
                                self.view.frame.size.height);
    [self.view addSubview:_oneview];
    
    _lTableViewDatas = [self getLeftDatas];
    
    //所有选择第一个
    if ([_lTableViewDatas count] > 0) {
    
        _rTableViewDatas = [self getRigthDatas:0];
        
        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:false
                              scrollPosition:UITableViewScrollPositionTop];
        
        [self tableView_l:_leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }

    [self attr1BtnClick:nil];
    
}

#pragma mark -  replace
-(NSArray*)getLeftDatas{

    return nil;
}

-(NSArray*)getRigthDatas:(int)row{

    return nil;
}

-(float)tableViewCellHight_r{

    return 0;
}

-(float)tableViewCellHight_l{
    
    return 0;
}

- (UITableViewCell *)tableView_r:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
}

- (UITableViewCell *)tableView_l:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}


- (void)tableView_l:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (void)tableView_r:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (void) setLinkageOneChoosetype:(XAILinkageOneType)type{

//    _type = type;
//    
//    if (type == XAILinkageOneType_jieguo) {
//        _datas = [[NSArray alloc] initWithArray:[self getJieGuo]];
//    }else{
//        _datas = [[NSArray alloc] initWithArray:[self getTiaojian:[XAILight class]]];
//    }
    
    
    
    _lTableViewDatas = [self getLeftDatas];
    _rTableViewDatas = [self getRigthDatas:0];
    
    if ([_lTableViewDatas count] > 0) {

        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:false
                              scrollPosition:UITableViewScrollPositionTop];
    }

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
    
    if (tableView == _rightTableView) {
        
        return [_rTableViewDatas count];
    }else if(tableView == _leftTableView){
    
        return [_lTableViewDatas count];
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _rightTableView) {
        
        return [self tableViewCellHight_r];
    }else if(tableView == _leftTableView){
        
        return [self tableViewCellHight_l];
    }

    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    if (tableView == _rightTableView) {
        
        cell = [self tableView_r:tableView cellForRowAtIndexPath:indexPath];
        
    }else if(tableView == _leftTableView){
        
    
        cell = [self tableView_l:tableView cellForRowAtIndexPath:indexPath];
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == _rightTableView) {
        
        [self tableView_r:tableView didSelectRowAtIndexPath:indexPath];
        
    }else if(tableView == _leftTableView){
        
        
        [self tableView_l:tableView didSelectRowAtIndexPath:indexPath];
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
    
//    NSArray* ary =  [_curObj getLinkageTiaojian];
//    
//    XAILinkageUseInfo*  use = nil;
//    
//    if (ary != nil && [ary count] > 1) {
//       use =  [ary objectAtIndex:1];
//    }
//    
//    [self.infoVC setLinkageUseInfo:use];
//    
//    [self.navigationController popViewControllerAnimated:YES];

}

- (void)leftClick:(id)sender{
    
//    
//    NSArray* ary =  [_curObj getLinkageTiaojian];
//    
//    XAILinkageUseInfo*  use = nil;
//    
//    if (ary != nil && [ary count] > 0) {
//        use =  [ary objectAtIndex:0];
//    }
//    
//    [self.infoVC setLinkageUseInfo:use];
//    
//    [self.navigationController popViewControllerAnimated:YES];

    
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

    _attr1Btn.selected = true;
    _attr2Btn.selected = false;
    _isChooseAttr1 = true;
}

-(void)attr2BtnClick:(id)sender{

    _attr1Btn.selected = false;
    _attr2Btn.selected = true;
    
    _isChooseAttr1 = false;
}


@end
