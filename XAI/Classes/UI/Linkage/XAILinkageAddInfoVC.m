//
//  XAILinkageAddInfoVC.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageAddInfoVC.h"
#import "XAIData.h"
#import "XAIObjectGenerate.h"


#define XAILinkageAddInfoVCID @"XAILinkageAddInfoVCID"

@implementation XAILinkageAddInfoVC

+(XAILinkageAddInfoVC*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    XAILinkageAddInfoVC* vc = (XAILinkageAddInfoVC*)[show_Storyboard instantiateViewControllerWithIdentifier:XAILinkageAddInfoVCID];
    //[vc changeIphoneStatusClear];
    return vc;
    
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    
    
}

- (void) setLinkageOneChoosetype:(XAILinkageOneType)type{

    _type = type;
    
    if (type == XAILinkageOneType_jieguo) {
        _datas = [[NSArray alloc] initWithArray:[self getJieGuo]];
    }else{
        _datas = [[NSArray alloc] initWithArray:[self getTiaojian]];
    }
}

- (NSArray*) getTiaojian{

    NSArray* objs = [[XAIData shareData] listenObjs];
    
    NSMutableArray* tiaojianObjs = [[NSMutableArray alloc] init];
    
    for (XAIObject* obj in objs) {
        
        if ([obj hasLinkageTiaojian]) {
            
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
    
    return [_datas count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellID = @"XAILinkageVCCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil || ![cell isKindOfClass:[UITableViewCell class]]) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
    }
    
    XAIObject* obj = [_datas objectAtIndex:[indexPath row]];
    
    if (obj.nickName != nil && [obj.nickName isEqualToString:@""]) {
        
        [cell.textLabel setText:obj.nickName];
        
    }else{
    
        [cell.textLabel setText:obj.name];
    }
    
    
    
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath row] < [_datas count]) {
        
        XAIObject* obj = [_datas objectAtIndex:[indexPath row]];
        
        if (_linkageAlert == nil) {
            _linkageAlert = (XAILinkageAlert*)[[[NSBundle mainBundle] loadNibNamed:@"LinkageAlert" owner:nil options:nil] lastObject];
            
            [_linkageAlert.closeBtn addTarget:self action:@selector(closeClick:)
                             forControlEvents:UIControlEventTouchUpInside];
            
            [_linkageAlert.bgBtn addTarget:self action:@selector(closeClick:)
                             forControlEvents:UIControlEventTouchUpInside];
            
            [_linkageAlert.leftBtn addTarget:self action:@selector(leftClick:)
                             forControlEvents:UIControlEventTouchUpInside];
            
            [_linkageAlert.rightBtn addTarget:self action:@selector(rightClick:)
                             forControlEvents:UIControlEventTouchUpInside];
        }
        
        BOOL willAdd = false;

        if ([obj isKindOfClass:[XAILight class]]) {
            
            
            _curObj = obj;
            
            if (_type == XAILinkageOneType_jieguo) {
                [_linkageAlert setLightOpr:obj.name];
            }else{
                [_linkageAlert setLight:obj.name];
            }
            
            
            willAdd = true;
            
        }
        
        if ([obj isKindOfClass:[XAIDoor class]] ||
            [obj isKindOfClass:[XAIWindow class]]) {
            
            _curObj = obj;
            
            [_linkageAlert setDW:obj.name];
            willAdd = true;
            
        }
        
        if ([obj isKindOfClass:[XAIIR class]]) {
            
            _curObj = obj;
            
            [_linkageAlert setIR:obj.name];
            willAdd = true;
            
        }
        
        if (willAdd) {
            
            [self.view addSubview:_linkageAlert];
            
            self.tableView.scrollEnabled = false;

            
        }

    }
    


    
}


#pragma mark - normal alert 
- (void) closeClick:(id)sender{
    
    if (_linkageAlert.superview != nil) {
        [_linkageAlert removeFromSuperview];
    }
    
     self.tableView.scrollEnabled = true;
    
}

- (void)rightClick:(id)sender{
    
    NSArray* ary =  [_curObj getLinkageTiaojian];
    
    XAILinkageUseInfo*  use = nil;
    
    if (ary != nil && [ary count] > 0) {
       use =  [ary objectAtIndex:0];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)leftClick:(id)sender{
    
    
    NSArray* ary =  [_curObj getLinkageTiaojian];
    
    XAILinkageUseInfo*  use = nil;
    
    if (ary != nil && [ary count] > 1) {
        use =  [ary objectAtIndex:1];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

    
}



@end
