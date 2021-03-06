//
//  DeviceShowStatusVC.m
//  XAI
//
//  Created by office on 14-4-23.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevShowStatusVC.h"

@implementation XAIDevShowStatusVC

- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        CGRect rx = [ UIScreen mainScreen ].bounds;
        
        _activityView = [[UIActivityIndicatorView alloc] init];
        
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityView.color = [UIColor redColor];
        _activityView.frame = CGRectMake(rx.size.width * 0.5f, rx.size.height * 0.5f, 0, 0);
        _activityView.hidesWhenStopped = YES;
        
        
        
        

    }
    
    
    return self;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    Resource35(newString, @"DevInfoView");
    
    [[NSBundle mainBundle] loadNibNamed:newString owner:self options:nil];
    
    ViewMoveUpWhenIs35(self.statusView, 50);
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    _recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handleSwipeLeft:)];
    
    [_recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:_recognizer];
    
    
    _recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handleSwipeRight:)];
    
    [_recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:_recognizerRight];
    
    [self.view addSubview:_secondView];
    [_secondView setAlpha:0];
    
    [self setExtraCellLineHidden:_oprTableView];
    
    
    
    
    
}

- (void) viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [self.view removeGestureRecognizer:_recognizer];
    [self.view removeGestureRecognizer:_recognizerRight];

}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    if (self.secondView.alpha != 0) return;
    
    CGRect curframe = self.view.frame;
    
    self.secondView.frame = CGRectMake(curframe.size.width
                                       ,0
                                       ,self.secondView.frame.size.width
                                       ,self.secondView.frame.size.height);
    
    self.secondView.alpha = 0.0f;
    
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    self.secondView.alpha = 1.0f;
    self.secondView.frame = CGRectMake(curframe.size.width - self.secondView.frame.size.width
                                       ,0
                                       ,self.secondView.frame.size.width
                                       ,self.secondView.frame.size.height);
    
    
    [UIView commitAnimations];
    
    
    _oprTableView.dataSource = self;
    _oprTableView.delegate = self;
    
    [_oprTableView reloadData];
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    if (self.secondView.alpha == 0) return;
    
    
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    CGRect curframe = self.view.frame;
    self.secondView.frame = CGRectMake(curframe.size.width
                                       ,0
                                       ,self.secondView.frame.size.width
                                       ,self.secondView.frame.size.height);
    
    [UIView setAnimationDidStopSelector:@selector(secondViewRemoveFinish)];
    [UIView setAnimationDelegate:self];
    
    [UIView commitAnimations];
    
    _oprTableView.dataSource = nil;
    _oprTableView.delegate = nil;
    
}

- (void) secondViewRemoveFinish{

    self.secondView.alpha = 0;
}


#pragma mark -
#pragma mark Table Data Source Methods

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]){
        
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if ([_oprDatasAry count] > 0) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return [_oprDatasAry count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeviceShowStatusVCCellXIB";
    
    if (!_nib) {
        _nib = [UINib nibWithNibName:@"DevInfoViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:CellIdentifier];
    }
    
    
    XAIDevShowStatusVCCell *cell = [tableView
                            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[XAIDevShowStatusVCCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];

    }
    
    //最后的最先显示
    XAIObjectOpr* aObjOpr = [_oprDatasAry objectAtIndex:([_oprDatasAry count] - [indexPath row] - 1)];
    
    if (aObjOpr != nil && [aObjOpr isKindOfClass:[XAIObjectOpr class]]) {
        
    
        [cell.timeLable setText:[aObjOpr timeStr]];
        [cell.oprLable setText:[aObjOpr oprWithNameStr]];
        
    }
    
    return cell;
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


@end

@implementation XAIDevShowStatusVCCell

@end
