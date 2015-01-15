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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.titleImgV.image = [UIImage imageWithFile:@"link_result_title.png"];
    self.headImgV.image = [UIImage imageWithFile:@"link_result_head.png"];
    
    
    CGFloat headerHeight = (self.view.frame.size.width -
                            [self getLeftDatas].count*[self tableViewCellHight_l])*0.5f;
    self.leftTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, headerHeight)];
}

-(NSArray*)getLeftDatas{
    
    return  [NSArray arrayWithObjects:[NSNumber numberWithInt:_L_Switch],
             [NSNumber numberWithInt:_L_Timer],nil];
    
}


-(float)tableViewCellHight_r{
    
    return 50;
}

-(float)tableViewCellHight_l{
    
    return [UIScreen mainScreen].bounds.size.width * 0.5f;
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
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5f, 60); //CGRectZero;
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
    _curType = type;
    
    if (type == _L_Timer) {
        
        [[XAILinkageTime share] addToCenter:self.rightView];
        [[XAILinkageTime share].okBtn addTarget:self
                                         action:@selector(dateChoose:)
                               forControlEvents:UIControlEventTouchUpInside];
        
        [[XAILinkageTime share]  setYanShi];
        
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
    
    
    XAILinkageUseInfoTime* timeUseInfo = [[XAILinkageUseInfoTime alloc] init];
    timeUseInfo.time = [[XAILinkageTime share] secValue];;
    [timeUseInfo change];
    
    [self.infoVC setLinkageUseInfo:timeUseInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark - helper
-(void)attrShow:(_L_Type)type{
    
    self.attrBtn.hidden = false;
    
    switch (type) {
        case _L_Switch:{
            NSString* str = _isChooseAttr1 ? @"您已选择开关打开动作" :@"您已选择开关关闭动作";
            
            NSMutableAttributedString* astr = [[NSMutableAttributedString alloc] initWithString:str];
            [astr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]
                         range:NSMakeRange(4,4)];
            
            self.tipLab.attributedText = astr;
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
    
    //找出使用的条件,不能使用
    XAILinkage* linkage = [self.infoVC getLinkage];
    NSMutableArray* useds = [[NSMutableArray alloc] init];
    //[useds addObjectsFromArray:linkage.resultInfos];
    [useds addObjectsFromArray:linkage.condInfos];
    
    for (XAILinkageUseInfo* useInfo in useds) {
        
        //时间进行下一个
        if (useInfo.dev_apsn == 0 && useInfo.dev_luid == 0) continue;
        
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
