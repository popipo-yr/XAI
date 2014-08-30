//
//  XAILinkageTime.m
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageTime.h"
#import "XAIAppDelegate.h"


@implementation XAILinkageTime

- (void) setDingShi{
    
    self.dataPicker = ((XAIAppDelegate*)[UIApplication sharedApplication].delegate).datePicker;
    
    if (self.dataPicker.superview != nil) {
        
        [self.dataPicker removeFromSuperview];
    }
    
    self.dataPicker.frame = CGRectMake(50, 115, 220, 162);
    [self addSubview:self.dataPicker];
    [self.dataPicker setLocale:[NSLocale currentLocale]];
    [self.dataPicker setDatePickerMode:UIDatePickerModeTime];
    //[self.dataPicker setTimeZone:[NSTimeZone localTimeZone]];
    //[self.dataPicker setDate:[NSDate new]];
    
}
- (void) setYanShi{
    
    self.dataPicker = ((XAIAppDelegate*)[UIApplication sharedApplication].delegate).datePicker;
    
    if (self.dataPicker.superview != nil) {
    
        [self.dataPicker removeFromSuperview];
    }
    
    self.dataPicker.frame = CGRectMake(50, 115, 220, 162);
    [self addSubview:self.dataPicker];
    
    [self.dataPicker setLocale:[NSLocale currentLocale]];
    [self.dataPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    //[self.dataPicker setDate:[NSDate dateWithTimeIntervalSince1970:1]];
    //[self.dataPicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    
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
