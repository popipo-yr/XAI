//
//  XAITableViewController.m
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewController.h"

@implementation XAITableViewController


- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        // Custom initialization
        

        CGRect rx = [ UIScreen mainScreen ].bounds;
        
        _activityView = [[UIActivityIndicatorView alloc] init];
        
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityView.color = [UIColor redColor];
        _activityView.frame = CGRectMake(rx.size.width * 0.5f, rx.size.height * 0.5f, 0, 0);
        _activityView.hidesWhenStopped = YES;
        
//        self.tableView.dataSource = self;
//        self.tableView.delegate = self;
        
    }
    return self;
}

- (void) dealloc{
    

    _activityView = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 设置通明
    [self setExtraCellLineHidden:self.tableView];
    

    
    
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


- (void)setSeparatorStyle:(int) count{

    if (count > 0) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    
}




@end
