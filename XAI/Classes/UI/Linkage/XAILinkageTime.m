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
    [self.dataPicker setDatePickerMode:UIDatePickerModeTime];
    //[self.dataPicker setTimeZone:[NSTimeZone localTimeZone]];
    //[self.dataPicker setDate:[NSDate new]];
    
}
- (void) setYanShi{
    
    [self.dataPicker setLocale:[NSLocale currentLocale]];
    [self.dataPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    //[self.dataPicker setDate:[NSDate dateWithTimeIntervalSince1970:1]];
    //[self.dataPicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    
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
    
    self.frame = CGRectMake(point.x, point.y, view.frame.size.width, _C_MeHeight);
    [view addSubview:self];
    
    
}


-(void) addToCenter:(UIView*)view{

    
    
    
    float y = (view.frame.size.height - _C_MeHeight)*0.5f;
    [self addTo:view point:CGPointMake(0, y)];
    


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

@end
