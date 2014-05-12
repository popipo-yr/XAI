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


@end

@implementation UINavigationItem (Add)

- (void) OnlyBack{

    UIBarButtonItem *backItem = nil;
    
    if (!isIOS7) {
        
        backItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action:nil];
        [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 0)]
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
