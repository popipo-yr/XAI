//
//  XAILinkageResultChooseVC.m
//  XAI
//
//  Created by office on 14/11/6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageResultChooseVC.h"
#import "XAIData.h"

@interface XAILinkageResultChooseVC ()

@end

#define _L_Timer 0
#define _L_Switch 1
#define _L_Type int

@implementation XAILinkageResultChooseVC

-(NSArray*)getLeftDatas{
    
    return  [NSArray arrayWithObjects:[NSNumber numberWithInt:_L_Switch],
             [NSNumber numberWithInt:_L_Timer],nil];
    
}


-(float)tableViewCellHight_r{
    
    return 50;
}

-(float)tableViewCellHight_l{
    
    return 200;
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
    
    if (type == _L_Timer) {
        
        [[XAILinkageTime share] addToCenter:self.rightView];
        [[XAILinkageTime share].okBtn addTarget:self
                                         action:@selector(dateChoose:)
                               forControlEvents:UIControlEventTouchUpInside];
        
        [[XAILinkageTime share]  setYanShi];
        
        self.rightTableView.hidden = true;
        
    }else{
        
        [[XAILinkageTime share] removeFromSuperview];
        
        self.rightTableView.hidden = false;
    }
    

    
    [self attrShow:type];
    
    _selLeftType = type;
    [self reloadRight];
    
    [self.leftTableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionBottom];
}


- (void)tableView_r:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(void)reloadRight{
    
    
    int index  = 0;
    if (_isChooseAttr1 == false) {
        index  = 1;
    }
    
    _rTableViewDatas = [self  getJieGuo:_selLeftType index:index];
    [self.rightTableView reloadData];
    
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
    
    
    if (use != nil) {
        
        [self.infoVC setLinkageUseInfo:use];
    }

    
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
            [self.attr1Btn setTitle:@"打开开关" forState:UIControlStateNormal];
            [self.attr2Btn setTitle:@"关闭开关" forState:UIControlStateNormal];
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
            imgStr = @"link_result_sw";
            break;
        }
        case _L_Timer:{
            imgStr = @"link_result_time";
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
        case _L_Timer:{
            break;
        }
            
        default:
            break;
    }
    
    
    return aClass;
    
}

- (NSArray*) getJieGuo:(_L_Type)type index:(int)index{
    
    NSArray* objs = [[XAIData shareData] listenObjs];
    
    Class aClass = [self typeToClass:type];
    
    if (aClass == nil) {
        return nil;
    }

    
    NSMutableArray* jieGuoObjs = [[NSMutableArray alloc] init];
    
    for (XAIObject* obj in objs) {
        
        if ([obj hasLinkageJieGuo] && [obj isKindOfClass:aClass]) {
            
            [jieGuoObjs addObject:obj];
        }
    }
    
    //找出使用的结果,不能使用
    XAILinkage* linkage = [self.infoVC getLinkage];
    XAILinkageUseInfo* useInfo = linkage.effeInfo;
    
        
        //时间进行下一个
    if (useInfo.dev_apsn != 0 && useInfo.dev_luid != 0){
    
        for (XAIObject* obj in jieGuoObjs) {
            if ([obj linkageInfoIsEqual:useInfo index:index]) {
                [jieGuoObjs removeObject:obj];
                break;
            }
        }
    
    }

    
    return jieGuoObjs;
    
}


@end
