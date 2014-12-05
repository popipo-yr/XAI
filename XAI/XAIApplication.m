//
//  XAIApplication.m
//  XAI
//
//  Created by office on 14/12/5.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIApplication.h"

@implementation XAIApplication

-(void)sendEvent:(UIEvent *)event
{
    if (event.type==UIEventTypeTouches) {
        
        UIView* rootView = self.keyWindow.rootViewController.view;
        
        UITouch* touch = [[event touchesForWindow:self.keyWindow] anyObject];
        
        if (touch != nil) {
          
            CGPoint point = [touch locationInView:rootView];
            
            UIView* hitView = [rootView hitTest:point withEvent:event];
            if (hitView == nil ||
                (![hitView isKindOfClass:[UIControl class]] &&
                 ![hitView canBecomeFirstResponder])) {
                
                [self.keyWindow endEditing:YES];
            }
        }
    }
    
    [super sendEvent:event];
}

@end
