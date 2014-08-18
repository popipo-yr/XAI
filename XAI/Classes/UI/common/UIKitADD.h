//
//  UIKitADD.h
//  XAI
//
//  Created by office on 14-5-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


#define RGBA(R,G,B,A) ([UIColor colorWithRed:R/256.0f  green:G/256.0f  blue:B/256.0f  alpha:A/256.0f])

#define Resource35(name,str) \
NSString* name = str;\
if ([UIScreen  is_35_Size]) { \
name = [NSString stringWithFormat:@"%@35",newString]; \
}

#define ViewMoveUpWhenIs35(obj,len) \
if ([UIScreen is_35_Size]) { \
CGPoint center = obj.center; \
center.y -= len; \
[obj setCenter:center]; \
}


@interface UIImage (ADD)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

@interface  UINavigationItem (Add)

- (void) OnlyBack;

@end


@interface UIBarButtonItem (Add)

- (void) ios6cleanBackgroud;

@end

@interface UIScreen (Add)

+ (BOOL)  is_35_Size;

@end


@interface NSString  (ADD)

- (BOOL) onlyHasNumberAndChar;

- (BOOL) isNameOrPawdLength;

@end


@interface UIViewController (ADD)

- (NSArray*) openSwipe;
- (void) stopSwipte:(NSArray*) swipes;

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer;

/*R2L 显示 从右边出现*/
- (void) animalVC_R2L:(UIViewController*)vc;
- (void) animalVC_L2R:(UIViewController*)vc;
- (void) animalView_R2L:(UIView*)view;
- (void) animalView_L2R:(UIView*)view;

- (void) finish_R2L;
- (void) finish_L2R;

- (void) changeIphoneStatus;

@end
