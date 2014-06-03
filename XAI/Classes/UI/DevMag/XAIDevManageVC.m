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



-(void)scanVC:(XAIScanVC *)scanVC didReadSymbols:(ZBarSymbolSet *)symbols{
    
    
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    NSString* luidstr = nil;
    
    if ([MQTTCover qrStr:symbolStr ToLuidStr:&luidstr]) {
        
        [scanVC dismissViewControllerAnimated:YES completion:nil];
        
        XAIDevAddVC* devAddVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DevAddViewControllerID"];
        
        if (devAddVC != nil && [devAddVC isKindOfClass:[XAIDevAddVC class]]) {
            
            devAddVC.luidStr = luidstr;
            [self.navigationController pushViewController:devAddVC animated:YES];
        }

    }
    
        // EXAMPLE: just grab the first barcode
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =
    //[info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    //[reader dismissModalViewControllerAnimated: YES];
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event method

- (void) addBtnClick:(id) sender{
    
    
    XAIScanVC* scanvc = [self.storyboard instantiateViewControllerWithIdentifier:XAIScanVC_SB_ID];
    
    if ([scanvc isKindOfClass:[XAIScanVC class]]) {
        
        scanvc.delegate = self;
        
        [self presentViewController:scanvc animated:YES completion:nil];
    }

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
        [cell.nameLable setText:aObj.name];
        
        if (aObj.nickName != nil && ![aObj.nickName isEqualToString:@""]) {
            
            [cell.contextLable setText:aObj.nickName];
        }else{
            [cell.contextLable setText:aObj.name];
        }
        
        
        
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
        
        NSString* setName = nil;
        if (aObj.nickName != nil && ![aObj.nickName isEqualToString:@""]) {
            
           setName = aObj.nickName;
        }else{
            setName = aObj.name;
        }
        
        [_vc setOneLabName:NSLocalizedString(@"DevNick", nil)
                OneTexName:setName
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
    

    
    //[_deviceService changeDev:_curOprObj.luid withName:newName];
    
    _curOprObj.nickName = newName;
//    [self.tableView reloadData];
    
    [[XAIData shareData] upDateObj:_curOprObj];
    [[XAIData shareData] notifyChange];
    
    [_vc endOkEvent];
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
        
        XAIObject* aObj = [_objectAry objectAtIndex:[_curDelIndexPath row]];
        
        //不应该时这里删除  下面会通知刷新 就会删除
//        [_objectAry removeObjectAtIndex:[_curDelIndexPath row]];
//        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:_curDelIndexPath]
//                               withRowAnimation:UITableViewRowAnimationAutomatic];
        
        /*如果是双控 则要一起移除另外一个*/
        if (aObj.type == XAIObjectType_light2_1 || aObj.type == XAIObjectType_light2_2) {
            
            /*删除储存的数据*/
            XAIObject* another = [aObj copy];
            another.type = (aObj.type == XAIObjectType_light2_1)
            ? XAIObjectType_light2_2 : XAIObjectType_light2_1;
            
            [[XAIData shareData] removeObj:another];
            
        
        }
        
        [[XAIData shareData] removeObj:aObj];
        [[XAIData shareData] notifyChange];
        
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
