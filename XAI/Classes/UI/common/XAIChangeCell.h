//
//  XAIChangeCell.h
//  XAI
//
//  Created by office on 14-4-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAIChangeCell : UITableViewCell{

    UILabel*  _lable;
    UITextField* _textFiled;
}

@property (nonatomic,strong) IBOutlet UILabel*  lable;
@property (nonatomic,strong) IBOutlet UITextField* textFiled;

- (void) setTextFiledWithLable:(NSString*)string;

@end
