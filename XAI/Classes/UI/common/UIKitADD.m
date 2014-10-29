//
//  UIKitADD.m
//  XAI
//
//  Created by office on 14-5-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "UIKitADD.h"

@implementation UIImage (ADD)


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    CGRect rect = CGRectMake(0, 0, size.width, size.height-1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
//    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
//    CGContextFillRect(context, CGRectMake(0, size.height-1, size.width, 1));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
    
}

+ (UIImage*) imageWithFile:(NSString*)file{

    NSString *fullFile = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], file];
    return [UIImage imageWithContentsOfFile:fullFile];
}


@end

@implementation UINavigationItem (Add)

- (void) OnlyBack{

    UIBarButtonItem *backItem = nil;
    
    if (!isIOS7) {
        
        backItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action:nil];
        [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 0)]
                                      forState:UIControlStateNormal
                                    barMetrics:UIBarMetricsDefault];
        
    }else{
        
        backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        
    }
    
    [self setBackBarButtonItem:backItem];
}

@end

@implementation UIBarButtonItem (Add)

-(void)ios6cleanBackgroud{

    if (isIOS7) return;
    
    [self setBackgroundImage:[UIImage new]
                    forState:UIControlStateNormal
                  barMetrics:UIBarMetricsDefault];
}

@end


@implementation UIScreen (Add)

+ (BOOL)  is_35_Size{

    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    return  iOSDeviceScreenSize.height == 480;
}

@end



@implementation NSString (ADD)

-(BOOL)onlyHasNumberAndChar{

    NSString *regex = @"[a-z][A-Z][0-9]";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return  [predicate evaluateWithObject:self] != YES ;
    
}

- (BOOL) isNameOrPawdLength{

    return [self length] > 3 && [self length] < 13;

}
@end

@implementation UIViewController (ADD)

- (NSArray*) openSwipe{
    
    UISwipeGestureRecognizer* _recognizer;
    UISwipeGestureRecognizer* _recognizerRight;

    
    _recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handleSwipeLeft:)];
    
    [_recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:_recognizer];
    
    
    _recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(handleSwipeRight:)];
    
    [_recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:_recognizerRight];
    
    return [NSArray arrayWithObjects:_recognizer,_recognizerRight,nil];

}
- (void) stopSwipte:(NSArray*) swipes{
    for ( UISwipeGestureRecognizer* recognizer in swipes) {
        if ([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:recognizer];
        }
    }
}
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer{
}
- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer{
}

- (void) animalVC_R2L:(UIViewController*)vc{
    // Get the views.
    UIView * fromView = self.view;
    if (self.parentViewController != nil && [self.parentViewController isKindOfClass:[UINavigationController class]]) {
        fromView = self.parentViewController.view;
    }
    
    UIView * toView = vc.view;
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    
    // Add the toView to the fromView
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake( 320 , viewSize.origin.y, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.4 animations:
     ^{
         // Animate the views on and off the screen. This will appear to slide.
         fromView.frame =CGRectMake( -320 , viewSize.origin.y, 320, viewSize.size.height);
         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             // Remove the old view from its parent.
             [fromView removeFromSuperview];
             [[UIApplication sharedApplication].delegate.window setRootViewController:vc];

         }
     }];
    

}


- (void) animalVC_L2R:(UIViewController*)vc{
    // Get the views.
    UIView * fromView = self.view;
    if (self.parentViewController != nil && [self.parentViewController isKindOfClass:[UINavigationController class]]) {
        fromView = self.parentViewController.view;
    }
    
    // Get the views.
    UIView * toView = vc.view;
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake( -320 , viewSize.origin.y, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.4 animations:
     ^{
         // Animate the views on and off the screen. This will appear to slide.
         fromView.frame =CGRectMake( 320 , viewSize.origin.y, 320, viewSize.size.height);
         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             // Remove the old view from the tabbar view.
             [fromView removeFromSuperview];
             [[UIApplication sharedApplication].delegate.window setRootViewController:vc];
         }
     }];
}


- (void) animalView_R2L:(UIView*)view{
    
    // Get the views.
    UIView * fromView = self.view;
    UIView * toView = view;
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    
    // Add the toView to the fromView
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake( 320 , viewSize.origin.y, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.4 animations:
     ^{
         // Animate the views on and off the screen. This will appear to slide.
         fromView.frame =CGRectMake( -320 , viewSize.origin.y, 320, viewSize.size.height);
         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             // Remove the old view from its parent.
             [fromView removeFromSuperview];
             //[[UIApplication sharedApplication].delegate.window setRootViewController:vc];
            
             [self finish_R2L];
         }
     }];
 
}

- (void) finish_R2L{

}

- (void) animalView_L2R:(UIView *)view{

    
    // Get the views.
    UIView * fromView = self.view;
    UIView * toView = view;
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake( -320 , viewSize.origin.y, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.4 animations:
     ^{
         // Animate the views on and off the screen. This will appear to slide.
         fromView.frame =CGRectMake( 320 , viewSize.origin.y, 320, viewSize.size.height);
         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             // Remove the old view from the tabbar view.
             [fromView removeFromSuperview];
             [self finish_L2R];
         }
     }];

}

-(void)finish_L2R{
}

- (void) changeIphoneStatus{

    if (isIOS7) {
        
//        [[UINavigationBar appearance] setBarTintColor:
//         [UIColor colorWithRed:255/256.0f green:91/256.0f blue:0 alpha:1]];
        
//        [[UINavigationBar appearance] setBarTintColor:
//                [UIColor colorWithRed:54.0f/256.0 green:55.0f/256.0 blue:57.0/256.0 alpha:1]];
//
//        
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
//        view.backgroundColor=[UIColor colorWithRed:54.0f/256.0 green:55.0f/256.0 blue:57.0/256.0 alpha:1];
//        
//        [self.view addSubview:view];
        
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[UIImage new]];
        
    }else{
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:RGBA(255, 91, 0, 255)
                                                                            size:CGSizeMake(1, 44)]
                                           forBarMetrics:UIBarMetricsDefault];
        
    }
    


}


- (void) changeIphoneStatusClear{
    
    if (isIOS7) {
        
        
        [[UINavigationBar appearance] setBarTintColor:
         [UIColor clearColor]];
        
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
        view.backgroundColor=[UIColor clearColor];
        
        [self.view addSubview:view];
        
    }else{
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:RGBA(255, 91, 0, 0)
                                                                            size:CGSizeMake(1, 44)]
                                           forBarMetrics:UIBarMetricsDefault];
        
    }
    
    
    
}


@end


@implementation KeyboardStateListener

static KeyboardStateListener* sListener = nil;
+ (KeyboardStateListener *)sharedInstance
{
    if ( nil == sListener ) sListener = [[KeyboardStateListener alloc] init];
    
    return sListener;
}


- (BOOL)isVisible
{
    return _isVisible;
}

- (void)didShow
{
    _isVisible = YES;
}

- (void)didHide
{
    _isVisible = NO;
}

- (id)init
{
    if ((self = [super init])) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didShow) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(didHide) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

@end

