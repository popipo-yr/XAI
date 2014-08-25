//
//  XAITableViewWithOprViewController.m
//  XAI
//
//  Created by office on 14-4-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITableViewWithOprController.h"
#import "MQTT.h"

@interface XAITableViewWithOprController ()

@end

@implementation XAITableViewWithOprController

- (id) initWithCoder:(NSCoder *) coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        // Custom initialization
        
        UIImage* editNorImg = [UIImage imageWithFile:@"device_edit_nor.png"] ;
        
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.editing = FALSE;
    
    if (![[MQTT shareMQTT].curUser isAdmin]) return;
    
    UIImage* addNorImg = [UIImage imageWithFile:@"device_add_nor.png"];
    
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
    
    UIImage* editNorImg = [UIImage imageWithFile:imgName];
    
    if ([editNorImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
        
        editNorImg = [editNorImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    _editItem.image = editNorImg;
    
}

- (void) delBtnClick:(NSIndexPath*) index{

    
}


#pragma mark - Table view data source


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        _curDelIndexPath = indexPath;
        
        [self delBtnClick:indexPath];
        
    }
}


-(NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NSLocalizedString(@"TabelDelTip", nil);
}




@end
