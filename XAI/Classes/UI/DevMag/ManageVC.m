//
//  ManageVC.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "ManageVC.h"
#import "ManageCell.h"

#import "DevAddViewController.h"
#import "XAIChangeNameVC.h"

#import "XAIObject.h"
#import "XAILight.h"

#define  constRect  CGRectMake(0, 0, 320, 50)

@interface ManageVC ()

@end

@implementation ManageVC

- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        // Custom initialization
        
        _deviceService = [[XAIDeviceService alloc] init];
        _deviceService.delegate = self;
        
        
        UIImage* editNorImg = [[UIImage imageNamed:@"device_edit_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        _editItem = [[UIBarButtonItem alloc] initWithImage:editNorImg
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(editBtnClick:)];

        
        _objectAry = [[NSMutableArray alloc] init];
        
        XAILight* obj1 = [[XAILight alloc] init];
        obj1.apsn = 0x01;
        obj1.luid = 0x123;
        obj1.type = XAIObjectType_light;
        obj1.lastOpr = @"Mr.O open light at 00.0.2";
        obj1.name = @"客厅大灯";
        obj1.nickName = obj1.name;
        
        
        XAILight* obj2 = [[XAILight alloc] init];
        obj2.apsn = 0x01;
        obj2.luid = 0x123;
        obj2.type = XAIObjectType_door;
        obj2.lastOpr = @"Mr.O close door at 00.0.2";
        obj2.name = @"主卧门";
        obj2.nickName = obj2.name;
        
        [_objectAry addObject:obj1];
        [_objectAry addObject:obj2];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.editing = FALSE;
    
    UIImage* addNorImg = [[UIImage imageNamed:@"device_add_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
 
    
    
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithImage:addNorImg
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(addBtnClick:)];

    
    [self.navigationItem setRightBarButtonItems:@[addItem,_editItem]];
    
    //back
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];

}


- (void) viewWillAppear:(BOOL)animated{
    
    
    _recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handleSwipeRight:)];
    
    [_recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:_recognizer];
    

    
    [super viewWillAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self.view removeGestureRecognizer:_recognizer];
    
}



- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    NSString* luidstr = nil;
    
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results){
    
       luidstr = symbol.data;
    
    }
        // EXAMPLE: just grab the first barcode
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =
    //[info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    //[reader dismissModalViewControllerAnimated: YES];
    
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    DevAddViewController* devAddVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DevAddViewControllerID"];
    
    if (devAddVC != nil && [devAddVC isKindOfClass:[DevAddViewController class]]) {
        
        devAddVC.luidStr = luidstr;
        [self.navigationController pushViewController:devAddVC animated:YES];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event method

- (void) addBtnClick:(id) sender{
    
    
    //ZBarReaderViewController *reader = [ZBarReaderViewController new];
    ZBarReaderController *reader = [ZBarReaderController new];
    
    reader.readerDelegate = self;
    //reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    
    [self presentViewController:reader animated:YES completion:Nil];
    
    
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
    
    UIImage* editNorImg = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _editItem.image = editNorImg;
    
}


#pragma mark - Table view data source



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    [self setSeparatorStyle:[_objectAry count]];
    return [_objectAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ManageCellIdentifier";
    
    ManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ManageCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    
    XAIObject* aObj = [_objectAry objectAtIndex:[indexPath row]];
    
    if (aObj != nil && [aObj isKindOfClass:[XAIObject class]]) {
        
        [cell.headImageView setBackgroundColor:[UIColor clearColor]];
        [cell.headImageView setImage:[UIImage imageNamed:[XAIObject typeImageName:aObj.type]]];
        [cell.nameLable setText:aObj.nickName];
        [cell.contextLable setText:aObj.name];
        
    }

    
    


    //cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
    
    UILabel* cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    cell.editingAccessoryView = cellLabel;
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([indexPath row] < [_objectAry count]) {
        
        
        XAIObject* aObj = [_objectAry objectAtIndex:[indexPath row]];
        
        _vc = [self.storyboard
                               instantiateViewControllerWithIdentifier:@"XAIChangeNameVCID"];
        
        [_vc setOneLabName:@"设备备注" OneTexName:aObj.nickName  TwoLabName:@"新备注名"];
        [_vc setOKClickTarget:self Selector:@selector(changeDevName:)];
        [_vc setBarTitle:@"设置备注"];
        
        _curOprObj = aObj;
        
        [self.navigationController  pushViewController:_vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        _curDelIndexPath = indexPath;
        
//        [_objectAry removeObjectAtIndex:indexPath.row];
//        // Delete the row from the data source.
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        

        XAIDebug(@"ManageVC",self,@selector(delDevice:),YES,5);
        
    }
}


-(NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    return @"删除";
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - DeviceService



- (void) changeDevName:(NSString*)newName{

    [_deviceService changeDev:_curOprObj.luid withName:newName apsn:_curOprObj.apsn luid:_curOprObj.luid];

    [_vc endOkEvent];
}

- (void) addDevice:(BOOL) isSuccess{

}
- (void) delDevice:(BOOL) isSuccess{
    
    if (isSuccess && nil != _curDelIndexPath) {
        
        [_objectAry removeObjectAtIndex:_curDelIndexPath.row];
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_curDelIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        _curDelIndexPath = nil;
    }
    


}
- (void) changeDeviceName:(BOOL) isSuccess{

}
- (void) findedAllDevice:(BOOL) isSuccess datas:(NSArray*) devAry{

}

- (void) finddedAllOnlineDevices:(NSSet*) luidAry{

}



@end
