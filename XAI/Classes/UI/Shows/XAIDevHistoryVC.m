//
//  XAIDevHistoryVC.m
//  XAI
//
//  Created by office on 14/11/3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevHistoryVC.h"

@interface XAIDevHistoryVC ()

@end


#define _ST_XAIDevHistoryVCID @"XAIDevHistoryVCID"

@implementation XAIDevHistoryVC


+(XAIDevHistoryVC *)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone_Other" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_XAIDevHistoryVCID];
    
    if ([vc isKindOfClass:[XAIDevHistoryVC class]]) {
        return (XAIDevHistoryVC*)vc;
    }
    
    return nil;
}

-(IBAction)closeClick:(id)sender{
    
    if (_retVC != nil) {
        [self animalVC_L2R:_retVC];
    }

}
-(IBAction)clearClick:(id)sender{

    [_corObj clearOpr];
    self.tableView.hidden = true;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_corObj == nil) {
        _tableView.hidden = true;
    }
    
    _datas = [NSArray arrayWithArray:[_corObj getOprList]];
    
    [self setSeparatorStyle];
    // Do any additional setup after loading the view.
    
    if ([_datas count] > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:([_datas count] - 1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return [_datas count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    XAIDevHistoryVCCell *cell = [tableView
                                dequeueReusableCellWithIdentifier:_C_XAIDevHistoryVCCellID];
    if (cell == nil) {
        cell = [[XAIDevHistoryVCCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:_C_XAIDevHistoryVCCellID];
    }
    
    XAIObjectOpr* aOpr = [_datas objectAtIndex:[indexPath row]];
    
    if (aOpr != nil && [aOpr isKindOfClass:[XAIObjectOpr class]]) {
        
        NSString* str = [aOpr allStr];
        NSMutableAttributedString* astr = [[NSMutableAttributedString alloc] initWithString:str];
        
        if (astr.length > 14 && [aOpr isWorn]) {
           
            [astr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]
                         range:NSMakeRange(14,astr.length - 14)];
        }


        cell.contentLab.attributedText = astr;
    }
    
    return cell;
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _C_XAIDevHistoryVCCellHeight;
}


- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]){
        
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}


- (void)setSeparatorStyle{
    
    if ([_datas count] > 0) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}



@end

@implementation XAIDevHistoryVCCell

@end
