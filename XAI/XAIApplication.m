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
    
    do {
        
        if (event.type != UIEventTypeTouches) break;
        
        UIView* rootView = self.keyWindow.rootViewController.view;
        
        
        NSArray* subviews = self.keyWindow.subviews;
        if ([subviews count] > 0
            && [[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]])break;
        
        UITouch* touch = [[event touchesForWindow:self.keyWindow] anyObject];
        
        if (touch == nil) break;
        
        CGPoint point = [touch locationInView:rootView];
        
        UIView* hitView = [rootView hitTest:point withEvent:event];
        
        if (hitView != nil &&
            ([hitView isKindOfClass:[UIControl class]] ||
             [hitView canBecomeFirstResponder])) break;
        
        
        [self.keyWindow endEditing:YES];
        
        
    } while (0);

    
    [super sendEvent:event];
}

@end
