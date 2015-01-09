//
//  XAILinkageTime.m
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageTime.h"
#import "XAIAppDelegate.h"


XAILinkageTime* ___S_TimePicker = nil;


@implementation XAILinkageTime

- (void) setDingShi{
    
    [self.dataPicker setLocale:[NSLocale currentLocale]];
    //[self.dataPicker setDatePickerMode:UIDatePickerModeTime];
    self.dataPicker.minuteInterval = 5;
    //[self.dataPicker setTimeZone:[NSTimeZone localTimeZone]];
    //[self.dataPicker setDate:[NSDate new]];
    
//    NSDate* now = [NSDate date];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
////    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
////    NSHourCalendarUnit;
//    
//    NSInteger unitFlags = NSYearCalendarUnit;
//    comps = [calendar components:unitFlags fromDate:now];
//    int hour = [comps hour];
//    int year = [comps year];
//    int month = [comps    month];
//    int day = [comps day];
//    
//    self.dataPicker.calendar = calendar;
    
    
    self.dingshiView.hidden = false;
    self.yanshiView.hidden = true;
    [self oneDayClick:nil];
}
- (void) setYanShi{
    
    [self.dataPicker setLocale:[NSLocale currentLocale]];
    [self.dataPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    //[self.dataPicker setDate:[NSDate dateWithTimeIntervalSince1970:1]];
    //[self.dataPicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    self.dingshiView.hidden = true;
    self.yanshiView.hidden = false;
    
    [self valueChange:nil];
    
}






+ (XAILinkageTime*)share{
    
    if (___S_TimePicker == nil) {
        ___S_TimePicker = [[[UINib nibWithNibName:@"LinkageTime" bundle:[NSBundle mainBundle]] instantiateWithOwner:nil options:nil] lastObject];
        
        ___S_TimePicker.frame = CGRectMake(0, 0,
                                           [UIScreen mainScreen].bounds.size.width,
                                           [UIScreen mainScreen].bounds.size.height);
        
        if (___S_TimePicker != nil && ![___S_TimePicker isKindOfClass:[XAILinkageTime class]]) {
            
            ___S_TimePicker = nil;
        }
    }
    
    return ___S_TimePicker;
}

- (IBAction)closeView:(id)sender {
    
    [self removeFromSuperview];
}


#define _C_MeHeight 268

-(void) addTo:(UIView*)view{
    
    if (view == nil) return;
    
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, _C_MeHeight);
    
    
    [view addSubview:self];
}

-(void) addTo:(UIView*)view point:(CGPoint)point{
    
    if (view == nil) return;
    
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
    
    self.frame = CGRectMake(point.x, point.y, view.frame.size.width, view.frame.size.height);
    [view addSubview:self];
    
    
}


-(void) addToCenter:(UIView*)view{

    
    
    
    //float y = (view.frame.size.height - _C_MeHeight)*0.5f;
    [self addTo:view point:CGPointMake(0, 0)];
    


}


-(void)removeFromSuperview{
    
    [_okBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    [super removeFromSuperview];
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


-(void)everyDayClick:(id)sender{

    _everyDayBtn.selected = true;
    _oneDayBtn.selected = false;
    
    [self.dataPicker setDatePickerMode:UIDatePickerModeTime];
    [self valueChange:nil];
}

-(void)oneDayClick:(id)sender{

    _everyDayBtn.selected = false;
    _oneDayBtn.selected = true;
    
    [self.dataPicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self valueChange:nil];
}

-(void)valueChange:(id)sender{

    if (self.dingshiView.hidden == false) {
        
        NSDateFormatter* format = [[NSDateFormatter alloc] init];
        
        if (_oneDayBtn.selected) {
            
            [format setDateFormat:@"您已选择MM月dd日HH时mm分触发"];
        }else{
            [format setDateFormat:@"您已选择每天HH时mm分触发"];
        }
        
        NSMutableAttributedString* astr = [[NSMutableAttributedString alloc]
                                           initWithString:[format stringFromDate:_dataPicker.date]];
        
        [astr addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1]
                     range:NSMakeRange(4,astr.length-2-4)];
        
        
        self.dingshiTipLab.attributedText = astr;
        

    }else{
        
        float couteDown = _dataPicker.countDownDuration;
        int hour = couteDown / 60 / 60;
        int min  = (couteDown - hour*60*60)/ 60;
        
        NSString* str = [NSString stringWithFormat:@"您已添加执行延时%d时%d分的动作",hour,min];
        if (hour == 0) {
          str = [NSString stringWithFormat:@"您已添加执行延时%d分的动作",min];
        }
        
        
        NSMutableAttributedString* astr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [astr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1]
                    range:NSMakeRange(4,str.length-3-4)];
       
        
        self.yanshiTipLab.attributedText = astr;
    }
}

@end
