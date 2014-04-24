//
//  ManageVC.m
//  XAI
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "ManageVC.h"
#import "ManageCell.h"

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

        
        _objectAry = [[NSMutableArray alloc] init];
        
        XAILight* obj1 = [[XAILight alloc] init];
        obj1.apsn = 0x01;
        obj1.luid = 0x123;
        obj1.type = XAIObjectType_light;
        obj1.lastOpr = @"Mr.O open light at 00.0.2";
        obj1.name = @"客厅大灯";
        
        
        XAILight* obj2 = [[XAILight alloc] init];
        obj2.apsn = 0x01;
        obj2.luid = 0x123;
        obj2.type = XAIObjectType_door;
        obj2.lastOpr = @"Mr.O close door at 00.0.2";
        obj2.name = @"主卧门";
        
        [_objectAry addObject:obj1];
        [_objectAry addObject:obj2];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.editing = FALSE;
    
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleSwipeLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizer];
    
    
    

}


- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =
    //[info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    //[reader dismissModalViewControllerAnimated: YES];
    
    
    [reader dismissViewControllerAnimated:YES completion:nil];
}



- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //Get location of the swipe
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    
    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    //Check if index path is valid
    if(indexPath)
    {
        //Get the cell out of the table view
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        //Update the cell or model
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    //[self.tableView removeGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


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
        
        [cell.imageView setBackgroundColor:[UIColor clearColor]];
        [cell.imageView setImage:[UIImage imageNamed:[XAIObject typeImageName:aObj.type]]];
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
    return 60.0;
}


//设置可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//更改删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


//- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [datas removeObjectAtIndex:indexPath.row];
//        // Delete the row from the data source.
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{

    //显示textedit
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{

    //显示label
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

@end
