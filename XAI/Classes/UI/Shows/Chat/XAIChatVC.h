//
//  ViewController.h
//  WeixinDeom
//
//  Created by iHope on 13-11-8.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAIChatCell.h"

@interface XAIChatVC : UIViewController{

    CGPoint _oldMovePoint;

}

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UITextField* textField;
@property (nonatomic, strong) IBOutlet UIView* moveView;

- (IBAction)sendBtnClick:(id)sender;

+(UIViewController*) create;

@end
