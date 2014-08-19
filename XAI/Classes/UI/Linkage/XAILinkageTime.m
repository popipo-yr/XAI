//
//  XAILinkageTime.m
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageTime.h"

@implementation XAILinkageTime

- (void) setDingShi{
    
    [self.dataPicker setDatePickerMode:UIDatePickerModeTime];
}
- (void) setYanShi{
    [self.dataPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return 24;
    
    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
//    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width/3 - 35, 30)];
//    columnView.text = [NSString stringWithFormat:@"%lu", row];
//    columnView.textAlignment = NSTextAlignmentLeft;
//    
//    return columnView;
    return nil;
}

@end
