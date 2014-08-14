//
//  XAIHasTableViewVC.m
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIHasTableViewVC.h"
#import "MQTT.h"

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
        
        
        
        UIImage* editNorImg = [UIImage imageNamed:@"device_edit_nor.png"] ;
        
        if ([editNorImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
            
            editNorImg = [editNorImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        _editItem = [[UIBarButtonItem alloc] initWithImage:editNorImg
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(editBtnClick:)];
        
        [_editItem ios6cleanBackgroud];

        
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
    
    
    if (![[MQTT shareMQTT].curUser isAdmin]) return;
    
    UIImage* addNorImg = [UIImage imageNamed:@"device_add_nor.png"];
    
    if ([addNorImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
        
        addNorImg = [addNorImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithImage:addNorImg
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(addBtnClick:)];
    
    [addItem ios6cleanBackgroud];
    
    [self.navigationItem setRightBarButtonItems:@[addItem,_editItem]];
    
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


#pragma mark - Event method

- (void) addBtnClick:(id) sender{
    
}

- (void) editBtnClick:(id)sender{
    
    
    [self setTableViewEdit:!self.tableView.editing];
    
}
-(void) handleSwipeRight:(id)sender{
    
    [self setTableViewEdit:NO];
    
}

- (void) setTableViewEdit:(BOOL) bl{
    
    self.tableView.editing = bl;
    
    NSString* imgName = bl ? @"device_edit_sel.png" : @"device_edit_nor.png";
    
    UIImage* editNorImg = [UIImage imageNamed:imgName];
    
    if ([editNorImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
        
        editNorImg = [editNorImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    _editItem.image = editNorImg;
    
}

- (void) delBtnClick:(NSIndexPath*) index{
    
    
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
