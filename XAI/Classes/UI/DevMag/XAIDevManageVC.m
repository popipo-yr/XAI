//
//  ManageVC.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevManageVC.h"
#import "XAIDevManageCell.h"

#import "XAIDevAddVC.h"
#import "XAIChangeNameVC.h"

#import "XAIObjectGenerate.h"



#define  constRect  CGRectMake(0, 0, 320, 50)

@interface XAIDevManageVC ()

@end

@implementation XAIDevManageVC

- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        // Custom initialization
        
        _deviceService = [[XAIDeviceService alloc] init];
        _deviceService.apsn = [MQTT shareMQTT].apsn;
        _deviceService.luid = MQTTCover_LUID_Server_03;
        _deviceService.deviceServiceDelegate = self;
        
        
        _objectAry = [[NSMutableArray alloc] initWithArray:[[XAIData shareData] getObjList]];
        
        [[XAIData shareData] addRefreshDelegate:self];
        
    }
    return self;
}

- (void)dealloc{

    
    [[XAIData shareData] removeRefreshDelegate:self];
}

-(void)xaiDataRefresh:(XAIData *)data{

    _objectAry = [[NSMutableArray alloc] initWithArray:[[XAIData shareData] getObjList]];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

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
    
    luidstr = @"0x124b000413c8d8";
    
    XAIDevAddVC* devAddVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DevAddViewControllerID"];
    
    if (devAddVC != nil && [devAddVC isKindOfClass:[XAIDevAddVC class]]) {
        
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
    
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    //ZBarReaderController *reader = [ZBarReaderController new];
    
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

- (void)delBtnClick:(NSIndexPath*) index{
    
    
    XAIObject*  obj = [_objectAry objectAtIndex:[index row]];
    NSString* tip =  [[NSString alloc] initWithFormat:NSLocalizedString(@"DevDelTip", nil),obj.name];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:tip
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"AlertCancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"AlertOK", nil), nil];
    
    [alert show];
    
}

#pragma mark - UIAlert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if ([alertView cancelButtonIndex] != buttonIndex) {
        
        XAIObject*  obj = [_objectAry objectAtIndex:[_curDelIndexPath row]];
        [_deviceService delDev:obj.luid];
        
    }else{
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_curDelIndexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
        
    }

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
    
    XAIDevManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XAIDevManageCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    
    XAIObject* aObj = [_objectAry objectAtIndex:[indexPath row]];
    
    if (aObj != nil && [aObj isKindOfClass:[XAIObject class]]) {
        
        [cell.headImageView setBackgroundColor:[UIColor clearColor]];
        [cell.headImageView setImage:[UIImage imageNamed:[XAIObjectGenerate typeImageName:aObj.type]]];
        [cell.nameLable setText:aObj.nickName];
        [cell.contextLable setText:aObj.name];
        
    }

    
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
        
        [_vc setOneLabName:NSLocalizedString(@"DevNick", nil)
                OneTexName:aObj.nickName
                TwoLabName:NSLocalizedString(@"DevNewNick", nil)];
        
        [_vc setOKClickTarget:self Selector:@selector(changeDevName:)];
        
        [_vc setBarTitle:NSLocalizedString(@"DevSetNick", nil)];
        
        _curOprObj = aObj;
        
        [self.navigationController  pushViewController:_vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark - DeviceService



- (void) changeDevName:(NSString*)newName{
    
    if (newName == nil || [newName isEqualToString:@""]) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"DevNickNameNull", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                              otherButtonTitles:nil];
        

        [alert show];
        return;
        
    }

    _newName = newName;
    
    [_deviceService changeDev:_curOprObj.luid withName:newName];
}




-(void)devService:(XAIDeviceService *)devService delDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    if (devService != _deviceService) return;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                          otherButtonTitles:nil];
    
    if (isSuccess &&  nil != _curDelIndexPath) {
        
        alert.message = NSLocalizedString(@"DelDevSuc", nil);
        
        //不应该时这里删除
        [_objectAry removeObjectAtIndex:[_curDelIndexPath row]];
        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:_curDelIndexPath]
                               withRowAnimation:UITableViewRowAnimationAutomatic];
        
        _curDelIndexPath = nil;
        
    }else{
        
        alert.message = NSLocalizedString(@"DelDevFaild", nil);
    }
    
    [alert show];
    
}

-(void)devService:(XAIDeviceService *)devService changeDevName:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    
    if (isSuccess) {
        
        [_vc endOkEvent];
        
        _curOprObj.name = _newName;
        
        [self.tableView reloadData];
        
    }else{
        
        [_vc endFailEvent:NSLocalizedString(@"DevChangeNameFaild", nil)];
    }
    
    
}

@end
