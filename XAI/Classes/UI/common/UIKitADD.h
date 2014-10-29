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
+ (UIImage*) imageWithFile:(NSString*)file;

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
- (void) changeIphoneStatusClear;

@end



@interface KeyboardStateListener : NSObject {
    BOOL _isVisible;
}
+ (KeyboardStateListener *)sharedInstance;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@end


///------------------键盘挑战视图位置
#define  _M_KeyboardMoveView(calView,moveView,prewTag,prewMoveY) \
/*int prewTag = -1;编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同*/  \
/*float prewMoveY = 0; 编辑的时候移动的高度*/ \
-(void) textFieldDidBeginEditing:(UITextField *)textField \
{ \
   \
    CGPoint Point =  [[textField superview] convertPoint:textField.frame.origin toView:calView]; \
    \
    float textY = Point.y; \
    float bottomHeight = self.view.frame.size.height-textY; \
    float keyboardHeight = 270; \
    if((bottomHeight) >=keyboardHeight)  /*判断当前的高度是否已经有216，
                                            如果超过了就不需要再移动主界面的View高度*/ \
    {  \
        prewTag = -1; \
        return; \
    } \
    prewTag = textField.tag; \
    float moveY = keyboardHeight-bottomHeight; /*这里只能是向上移动*/ \
    prewMoveY = moveY + prewMoveY;  /*纪录移动*/ \
    \
    NSTimeInterval animationDuration = 0.3f; \
    CGRect frame = moveView.frame;  \
    frame.origin.y -= moveY;/*view的Y轴上移*/ \
    [UIView beginAnimations:@"ResizeView" context:nil]; \
    [UIView setAnimationDuration:animationDuration]; \
    moveView.frame = frame;  \
    [UIView commitAnimations];/*设置调整界面的动画效果*/ \
} \
/**
 结束编辑UITextField的方法，让原来的界面还原高度
 */ \
-(void) textFieldDidEndEditing:(UITextField *)textField \
{  \
    if ([[KeyboardStateListener sharedInstance] isVisible]) { \
        \
        return; \
    } \
    if(prewTag == -1) /*当编辑的View不是需要移动的View*/ \
    { \
        return; \
    } \
    float moveY ; \
    NSTimeInterval animationDuration = 0.1f; \
    CGRect frame = moveView.frame; \
    if(prewTag == textField.tag) /*当结束编辑的View的TAG是上次的就移动*/ \
    {   /*还原界面*/ \
        moveY =  prewMoveY; \
        frame.origin.y +=moveY; \
        moveView.frame = frame; \
        \
        /*清除*/ \
        prewMoveY = 0; \
    } \
    /*self.view移回原位置*/ \
    [UIView beginAnimations:@"ResizeView" context:nil]; \
    [UIView setAnimationDuration:animationDuration]; \
    moveView.frame = frame; \
    [UIView commitAnimations]; \
    [textField resignFirstResponder]; \
}


////----------------
