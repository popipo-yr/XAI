//
//  DevAddViewController.m
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevAddVC.h"
#import "XAIObject.h"

@interface XAIDevAddVC ()

@end

@implementation XAIDevAddVC


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _typeStrAry = @[@"门",@"灯"];
        _deviceService = [[XAIDeviceService alloc] init];
        _deviceService.delegate = self;
        
    }
    
    
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setExtraCellLineHidden:_typeTableView];
    _typeTableView.dataSource = self;
    _typeTableView.delegate = self;

    [_nameTextField addTarget:self action:@selector(nameTextReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(addOneDevice:)];
    [self.navigationItem setRightBarButtonItem:okItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table Data Source Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_typeStrAry count] > 0) {
        
        _typeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        
        _typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return [_typeStrAry count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    

   
    cell.textLabel.text = [_typeStrAry objectAtIndex:[indexPath row]];
    
    return cell;
}

#pragma mark Table Delegate Methods
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    if ([_curSelIndexPath length] > 0) {
        
        UITableViewCell* preCell = [tableView cellForRowAtIndexPath:_curSelIndexPath];
        [preCell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    
    _curSelIndexPath =  indexPath;
    
}
  
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- DeviceServiceDelegate

- (void) addDevice:(BOOL) isSuccess{

    if (isSuccess) {
        
    }
}

#pragma mark --Helper

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]){
        
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}


- (void)nameTextReturn:(id)seder{

    [_nameTextField resignFirstResponder];
}


- (void)addOneDevice:(id)seder{
    
    NSString* type = nil;
    
    if ([_curSelIndexPath length] > 0) {
        
         type = [_typeStrAry  objectAtIndex:[_curSelIndexPath row]];
    }
    
    NSString* name =  _nameTextField.text;
   
    
    [_deviceService addDev:0x1 withName:name];
}


@end
