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
    
    UIImage* backImg = [UIImage imageWithFile:@"back_nor.png"] ;
    
    if ([backImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
        
        backImg = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithImage:backImg
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backClick:)];
    
    [backItem ios6cleanBackgroud];
    
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    

    
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

    [self attrBtnClick:nil];
    
    
    CGRect oldRect = _leftTableView.frame;
    oldRect.size.height = [UIScreen mainScreen].bounds.size.width;
    oldRect.origin.y = [UIScreen mainScreen].bounds.size.height - oldRect.size.width;
    _leftTableView.frame = oldRect;
    
    CALayer* layer = _leftTableView.layer;
    CGPoint oldAnchorPoint = layer.anchorPoint;
    [layer setAnchorPoint:CGPointMake(0.5, layer.bounds.size.width / layer.bounds.size.height * 0.5f)];
    [layer setPosition:CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - oldAnchorPoint.x), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - oldAnchorPoint.y))];
    _leftTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);

    
}

-(void)backClick:(id)sender{

    [self.navigationController popViewControllerAnimated:true];
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
        cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
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


#pragma mark -

- (void) reloadRight{

}


-(void)attrBtnClick:(id)sender{

    _attrBtn.selected = !_attrBtn.selected;
    _isChooseAttr1 = _attrBtn.selected;
    
    [self reloadRight];
}



@end
