//
//  XAIHasTableViewVC.m
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"
#import "MQTT.h"
#import "XAIShowVC.h"

#import "SWTableViewCellAdd.h"

@interface XAIHasTableViewVC ()

@end

@implementation XAIHasTableViewVC

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
        
        
        
        UIImage* returnNorImg = [UIImage imageWithFile:@"back_nor.png"] ;
        
        if ([returnNorImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
            
            returnNorImg = [returnNorImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        _returnItem = [[UIBarButtonItem alloc] initWithImage:returnNorImg
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(returnClick:)];
        
        [_returnItem ios6cleanBackgroud];

        
    }
    return self;
}

- (void) dealloc{
    
    
    _activityView = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
	// Do any additional setup after loading the view.
    
    // 设置通明
    [self setExtraCellLineHidden:self.tableView];
    
    
    //back
    [self.navigationItem OnlyBack];
    
    [self.theNavigationItem setLeftBarButtonItem:_returnItem];
    
    _oldRect = self.tableView.frame;
    
}


-(BOOL)prefersStatusBarHidden{
    
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self setNeedsStatusBarAppearanceUpdate];
        
    }
}


-(void)returnClick:(id)sender{
    
    [self.view.window setRootViewController:[XAIShowVC create]];

}


- (void)moveTableViewToOld{

    self.tableView.frame  = _oldRect;
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
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}




#pragma mark - Table view data source


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        
//        _curDelIndexPath = indexPath;
//        
//        [self delBtnClick:indexPath];
//        
//    }
//}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleInsert;
//}



//-(NSString *)tableView:(UITableView *)tableView
//titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return NSLocalizedString(@"TabelDelTip", nil);
//}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}




@end
