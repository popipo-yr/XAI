//
//  XAILinkageAddNameVC.h
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAILinkageAddNameVC : UIViewController{

    BOOL _keyboardIsUp;
}

@property (nonatomic,strong) IBOutlet UITextField* tf;

- (IBAction)btnClick:(id)sender;

+(UIViewController*)create;

@end
