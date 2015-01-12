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
    self.dataPicker.minuteInterval = 5;
    
    
    self.dingshiView.hidden = false;
    self.yanshiView.hidden = true;
    
    _dataPicker.hidden = false;
    _secPickView.hidden = true;
    _secLab.hidden = true;
    _minLab.hidden = true;
    
    [self oneDayClick:nil];
}
- (void) setYanShi{
    

    self.dingshiView.hidden = true;
    self.yanshiView.hidden = false;
    
    [self valueChange:nil];
    
    
    if (_secPickView == nil) {
        
        
        _secPickView = [[UIPickerView alloc] init];
        _secPickView.dataSource = self;
        _secPickView.delegate = self;
        
        
        [_dataPicker.superview  addSubview:_secPickView];
        
        [_dataPicker.superview addConstraint:[NSLayoutConstraint
                                              constraintWithItem:_secPickView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:_yanshiView
                                              attribute:NSLayoutAttributeBottom
                                              multiplier:1
                                              constant:10]];
        [_dataPicker.superview addConstraint:[NSLayoutConstraint
                                              constraintWithItem:_secPickView
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:_okBtn
                                              attribute:NSLayoutAttributeTop
                                              multiplier:1
                                              constant:-10]];

        
        _secPickView.translatesAutoresizingMaskIntoConstraints = false;

        

        
        [_secPickView selectRow:60 inComponent:1 animated:false];
        [_secPickView selectRow:60 inComponent:0 animated:false];
        
        CGRect secRect = CGRectMake(0,0,20,30);
        UILabel* secLab = [[UILabel alloc] initWithFrame:secRect];
        secLab.text = @"秒";
        secLab.font = [UIFont systemFontOfSize:16];
        [_secPickView.superview addSubview:secLab];
        
        CGRect minRect = CGRectMake(0,0,20,30);
        UILabel* minLab = [[UILabel alloc] initWithFrame:minRect];
        minLab.text = @"分";
        minLab.font = [UIFont systemFontOfSize:16];
        [_secPickView.superview addSubview:minLab];
        
        
        float move = 5;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){
            
            move =  [UIScreen is_35_Size] ? 15 : 0;
        }
        

        secLab.translatesAutoresizingMaskIntoConstraints = false;
        [_secPickView.superview addConstraint:[NSLayoutConstraint
                                              constraintWithItem:secLab
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:_secPickView
                                              attribute:NSLayoutAttributeCenterY
                                              multiplier:1
                                              constant:move]];
        [_secPickView.superview addConstraint:[NSLayoutConstraint
                                     constraintWithItem:secLab
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:_secPickView
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1
                                     constant:50 + 30]];
        
        minLab.translatesAutoresizingMaskIntoConstraints = false;
        [_secPickView.superview addConstraint:[NSLayoutConstraint
                                     constraintWithItem:minLab
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:_secPickView
                                     attribute:NSLayoutAttributeCenterY
                                     multiplier:1
                                     constant:move]];
        [_secPickView.superview addConstraint:[NSLayoutConstraint
                                     constraintWithItem:minLab
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:_secPickView
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1
                                     constant:-50 + 25]];
        
        
  
        
        _secLab = secLab;
        _minLab = minLab;
        


    }
    
    _dataPicker.hidden = true;
    _secPickView.hidden = false;
    _secLab.hidden = false;
    _minLab.hidden = false;
    
    
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
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return 60*3;
    
    return 60*3;
}


-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    return 100;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self valueChange:nil];
    [self pickerViewLoaded:component];
}


-(void)pickerViewLoaded: (NSInteger)component {
    [_secPickView selectRow:[_secPickView selectedRowInComponent:component]%60+60 inComponent:component animated:false];
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [NSString stringWithFormat:@"%@",@(row % 60)];
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
                     value:[UIColor colorWithRed:0/255.0 green:150/255.0 blue:255/255.0 alpha:1]
                     range:NSMakeRange(4,astr.length-2-4)];
        
        
        self.dingshiTipLab.attributedText = astr;
        

    }else{
        
        int min = [_secPickView selectedRowInComponent:0]%60;
        int sec  = [_secPickView selectedRowInComponent:1]%60;
        
        NSString* str = [NSString stringWithFormat:@"您已添加执行延时%d分%d秒的动作",min,sec];
        if (min == 0) {
          str = [NSString stringWithFormat:@"您已添加执行延时%d秒的动作",sec];
        }
        
        
        NSMutableAttributedString* astr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [astr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:0/255.0 green:150/255.0 blue:255/255.0 alpha:1]
                    range:NSMakeRange(4,str.length-3-4)];
       
        
        self.yanshiTipLab.attributedText = astr;
    }
}

-(NSUInteger)secValue{

    int min = [_secPickView selectedRowInComponent:0]%60;
    int sec  = [_secPickView selectedRowInComponent:1]%60;
    
    return min*60 + sec;
}

@end
