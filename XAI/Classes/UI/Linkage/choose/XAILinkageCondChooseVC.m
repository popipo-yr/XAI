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


-(float)tableViewCellHight_r{
    
    return 50;
}

-(float)tableViewCellHight_l{
    
    return 80;
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
    
    CGRect rect = CGRectMake(0, 0, 80, 60); //CGRectZero;
    //rect.size = cell.frame.size;
    
    UIImage* norImg = [self imgCond:type isSel:false];
    UIImage* selImg = [self imgCond:type isSel:true];
    
    CGRect imgRect  = CGRectMake((rect.size.width - norImg.size.width)*0.5f,
                         (rect.size.height - norImg.size.height)*0.5f,
                         norImg.size.width,
                         norImg.size.height);
    
    
    UIImageView* imageNor = [[UIImageView alloc] initWithFrame:imgRect];
    imageNor.image = norImg;
    UIView*  bgView = [[UIView alloc] initWithFrame:rect];
    [bgView addSubview:imageNor];
    cell.backgroundView = bgView;
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView* imageSel = [[UIImageView alloc] initWithFrame:imgRect];
    imageSel.image = selImg;
    UIView*  sbgView = [[UIView alloc] initWithFrame:rect];
    [sbgView addSubview:imageSel];
    cell.selectedBackgroundView = sbgView;
    
    return cell;
}


- (void)tableView_l:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundView.hidden = true;
    if (_curCell != nil) _curCell.backgroundView.hidden = false;
    _curCell = cell;
    

  
     _L_Type type = [[_lTableViewDatas objectAtIndex:[indexPath row]] intValue];
    
    
    if (type == _L_Timer) {
        
        [[XAILinkageTime share] addToCenter:self.rightView];
        [[XAILinkageTime share].okBtn addTarget:self
                                         action:@selector(dateChoose:)
                               forControlEvents:UIControlEventTouchUpInside];
        
        [[XAILinkageTime share]  setDingShi];
        
        self.rightTableView.hidden = true;
        self.rightHeadView.hidden = true;
        
    }else{
        
        [[XAILinkageTime share] removeFromSuperview];
    
        self.rightTableView.hidden = false;
        self.rightHeadView.hidden = false;
    }
    
    [self attrShow:type];
    
    _selLeftType = type;
    [self reloadRight];
}


- (void)tableView_r:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(void)reloadRight{

    
    int index  = 0;
    if (_isChooseAttr1 == false) {
        index  = 1;
    }
    
    _rTableViewDatas = [self  getTiaojian:_selLeftType index:index];
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
    
    
    NSDateFormatter* mouthFormat = [[NSDateFormatter alloc] init];
    [mouthFormat setDateFormat:@"MM"];
    
    NSDateFormatter* hourFormat = [[NSDateFormatter alloc] init];
    [hourFormat setDateFormat:@"HH"];
    
    NSDateFormatter* minuFormat = [[NSDateFormatter alloc] init];
    [minuFormat setDateFormat:@"mm"];
    
    int mouth = [[mouthFormat stringFromDate:date] intValue];
    int hour =[[hourFormat stringFromDate:date] intValue];
    int min = [[minuFormat stringFromDate:date] intValue];
    
    
    if ([XAILinkageTime share].dataPicker.datePickerMode == UIDatePickerModeCountDownTimer) {
        float couteDown = [XAILinkageTime share].dataPicker.countDownDuration;
        hour = couteDown / 60 / 60;
        min  = (couteDown - hour*60*60)/ 60;
    }
    
    
    
    XAILinkageUseInfoTime* timeUseInfo = [[XAILinkageUseInfoTime alloc] init];
    timeUseInfo.time = hour*60*60 + min*60 ;
    [timeUseInfo change];
    
    [self.infoVC setLinkageUseInfo:timeUseInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark - helper
-(void)attrShow:(_L_Type)type{
    
    self.attrBtn.hidden = false;
    
    switch (type) {
        case _L_Switch:{
            self.tipLab.text  = _isChooseAttr1 ? @"您已选择开关打开触发" : @"您已选择开关关闭触发";
            break;
        }
        case _L_DC:{
            self.tipLab.text  = _isChooseAttr1 ?@"您已选择门窗打开触发" : @"您已选择门窗关闭触发";
            break;
        }
        case _L_INF:{
            self.tipLab.text  = @"当红外触发时";
            self.attrBtn.hidden = true;
            break;
        }
        default:{
            self.attrBtn.hidden = true;
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

- (NSArray*) getTiaojian:(_L_Type)type index:(int)index{
    
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
    
    //找出使用的结果,不能使用
    XAILinkage* linkage = [self.infoVC getLinkage];
    NSArray* results = linkage.condInfos;
    
    for (XAILinkageUseInfo* useInfo in results) {
        
        //时间进行下一个
        if (useInfo.dev_apsn == 0 && useInfo.dev_luid == 0) continue;

        for (XAIObject* obj in tiaojianObjs) {
        
            if ([obj linkageInfoIsEqual:useInfo index:index]) {
                [tiaojianObjs removeObject:obj];
                break;
            }
        }
    }
    
    
    return tiaojianObjs;
    
}




@end
