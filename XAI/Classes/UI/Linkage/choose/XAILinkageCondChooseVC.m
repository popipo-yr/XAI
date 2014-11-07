//
//  XAILinkageCondChooseVC.m
//  XAI
//
//  Created by office on 14/11/6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageCondChooseVC.h"
#import "XAILinkageChooseCell.h"
#import "XAIData.h"

#import "XAIObjectGenerate.h"

#define _L_Timer 0
#define _L_Switch 1
#define _L_DC  2
#define _L_INF 3
#define _L_Type int

@interface XAILinkageCondChooseVC ()

@end

@implementation XAILinkageCondChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)getLeftDatas{
    
    return  [NSArray arrayWithObjects:[NSNumber numberWithInt:_L_Switch],
             [NSNumber numberWithInt:_L_DC],
             [NSNumber numberWithInt:_L_INF],
             [NSNumber numberWithInt:_L_Timer],nil];
    
}

-(NSArray*)getRigthDatas:(int)row{
    
    if (row < [_lTableViewDatas count]) {
        
        _L_Type type = [[_lTableViewDatas objectAtIndex:row] intValue];
        
        return [[NSArray alloc] initWithArray:[self getTiaojian:type]];

    }
    return nil;
}

-(float)tableViewCellHight_r{
    
    return 50;
}

-(float)tableViewCellHight_l{
    
    return 100;
}

- (UITableViewCell *)tableView_r:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XAILinkageChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:_C_XAILinkageChooseCellID];
    
    if (cell == nil || ![cell isKindOfClass:[XAILinkageChooseCell class]]) {
        cell = [XAILinkageChooseCell  create:_C_XAILinkageChooseCellID];
        
    }
    
    XAIObject* obj = [_rTableViewDatas objectAtIndex:[indexPath row]];
    
    [cell setInfo:obj];
    cell.delegate = self;
    
    return cell;
}

- (UITableViewCell *)tableView_l:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* cellID = @"UITableViewCellLeft";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
        
    }
    
    _L_Type type = [[_lTableViewDatas objectAtIndex:[indexPath row]] intValue];
    
    UIImageView* imageNor = [[UIImageView alloc] init];
    imageNor.image = [self imgCond:type isSel:false];
    cell.backgroundView = imageNor;
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView* imageSel = [[UIImageView alloc] init];
    imageSel.image = [self imgCond:type isSel:true];
    cell.selectedBackgroundView = imageSel;
    
    return cell;
}


- (void)tableView_l:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _L_Type type = [[_lTableViewDatas objectAtIndex:[indexPath row]] intValue];
    
    
    _rTableViewDatas = [self  getTiaojian:type];
    [self.rightTableView reloadData];
    
    
    if (type == _L_Timer) {
        
        [[XAILinkageTime share] addToCenter:self.rightView];
        [[XAILinkageTime share].okBtn addTarget:self
                                         action:@selector(dateChoose:)
                               forControlEvents:UIControlEventTouchUpInside];
        
        [[XAILinkageTime share]  setDingShi];
        
        self.rightTableView.hidden = true;
        
    }else{
        
        [[XAILinkageTime share] removeFromSuperview];
    
        self.rightTableView.hidden = false;
    }
    
    [self attrShow:type];
}


- (void)tableView_r:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



#pragma  mark - choose delegate

-(void)chooseCellBgClick:(XAILinkageChooseCell *)cell{
    
    NSIndexPath* indexPath = [self.rightTableView indexPathForCell:cell];
    XAIObject* obj = [_rTableViewDatas objectAtIndex:[indexPath row]];

    NSArray* ary =  [obj getLinkageTiaojian];
    
    XAILinkageUseInfo*  use = nil;
    
    if (_isChooseAttr1) {
        
        if (ary != nil && [ary count] > 0) {
            use =  [ary objectAtIndex:0];
        }
        
    }else{
        
        if (ary != nil && [ary count] > 1) {
            use =  [ary objectAtIndex:1];
        }
    
    }

    
    [self.infoVC setLinkageUseInfo:use];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)dateChoose:(id)sender{
    
    NSDate* date= [[XAILinkageTime share].dataPicker date];
    
    NSDateFormatter* hourFormat = [[NSDateFormatter alloc] init];
    [hourFormat setDateFormat:@"HH"];
    
    NSDateFormatter* minuFormat = [[NSDateFormatter alloc] init];
    [minuFormat setDateFormat:@"mm"];
    
    int hour =[[hourFormat stringFromDate:date] intValue];
    int min = [[minuFormat stringFromDate:date] intValue];
    
    
    if ([XAILinkageTime share].dataPicker.datePickerMode == UIDatePickerModeCountDownTimer) {
        float couteDown = [XAILinkageTime share].dataPicker.countDownDuration;
        hour = couteDown / 60 / 60;
        min  = (couteDown - hour*60*60)/ 60;
    }
    
    
    
    XAILinkageUseInfoTime* timeUseInfo = [[XAILinkageUseInfoTime alloc] init];
    timeUseInfo.time = hour*60*60 + min*60;
    [timeUseInfo change];
    
    [self.infoVC setLinkageUseInfo:timeUseInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark - helper
-(void)attrShow:(_L_Type)type{
    
    self.attr1Btn.hidden = false;
    self.attr2Btn.hidden = false;
    
    switch (type) {
        case _L_Switch:{
            [self.attr1Btn setTitle:@"开关打开时" forState:UIControlStateNormal];
            [self.attr2Btn setTitle:@"开关关闭时" forState:UIControlStateNormal];
            break;
        }
        case _L_DC:{
            [self.attr1Btn setTitle:@"门窗打开时" forState:UIControlStateNormal];
            [self.attr2Btn setTitle:@"门窗关闭时" forState:UIControlStateNormal];
            break;
        }
        case _L_INF:{
            [self.attr1Btn setTitle:@"红外触发时" forState:UIControlStateNormal];
            [self.attr2Btn setTitle:@"红外扫描时" forState:UIControlStateNormal];
            break;
        }
        default:{
            self.attr1Btn.hidden = true;
            self.attr2Btn.hidden = true;
            break;
        }
    }
    
}


-(UIImage*)imgCond:(_L_Type)type isSel:(BOOL)isSel{
    
    NSString* imgStr = nil;
    
    switch (type) {
        case _L_Switch:{
            imgStr = @"link_cond_sw";
            break;
        }
        case _L_DC:{
            imgStr = @"link_cond_dc";
            break;
        }
        case _L_INF:{
            imgStr = @"link_cond_inf";
            break;
        }
        case _L_Timer:{
            imgStr = @"link_cond_time";
            break;
        }
            
        default:
            break;
    }
    
    if (isSel) {
        imgStr = [NSString stringWithFormat:@"%@_sel.png",imgStr];
    }else{
        imgStr = [NSString stringWithFormat:@"%@_nor.png",imgStr];
    }

    return [UIImage imageWithFile:imgStr];

}

-(Class)typeToClass:(_L_Type)type{

    Class aClass = nil;
    
    switch (type) {
        case _L_Switch:{
            aClass = [XAILight class];
            break;
        }
        case _L_DC:{
            aClass = [XAIDoor class];
            break;
        }
        case _L_INF:{
            aClass = [XAIIR class];
            break;
        }
        case _L_Timer:{
            break;
        }
            
        default:
            break;
    }
    
    
    return aClass;

}

- (NSArray*) getTiaojian:(_L_Type)type{
    
    NSArray* objs = [[XAIData shareData] listenObjs];
    
    NSMutableArray* tiaojianObjs = [[NSMutableArray alloc] init];
    
    Class aClass = [self typeToClass:type];
    
    if (aClass == nil) {
        return nil;
    }
    
    for (XAIObject* obj in objs) {
        
        if ([obj hasLinkageTiaojian] && [obj isKindOfClass:aClass]) {
            
            [tiaojianObjs addObject:obj];
        }
    }
    
    
    return tiaojianObjs;
    
}




@end
