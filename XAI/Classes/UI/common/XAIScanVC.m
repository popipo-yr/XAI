//
//  XAIScanVC.m
//  XAI
//
//  Created by office on 14-5-6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIScanVC.h"

@interface XAIScanVC ()

@end

@implementation XAIScanVC

+ (XAIScanVC*)create{
    
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    XAIScanVC* vc = [show_Storyboard instantiateViewControllerWithIdentifier:XAIScanVC_SB_ID];

    return vc;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];

    
    _readerView = [[ZBarReaderView alloc]init];
    
    

    CGRect  newframe = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                       [UIScreen mainScreen].bounds.size.height);
    
    
    _readerView.frame = newframe;
    
    _readerView.readerDelegate = self;
    
    //关闭闪光灯
    _readerView.torchMode = 0;
    
    

    
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = _readerView;
    }
    
    
    [_readerView.scanner setSymbology: ZBAR_I25
                               config: ZBAR_CFG_ENABLE
                                   to: 0];
    
    //[_readerView start];

    //dispatch_async(dispatch_get_main_queue(), ^{[_readerView start];});
    
    
    _readerView.tracksSymbols = false;
    [self.view insertSubview:_readerView atIndex:0];
    //[_scanView addSubview:_readerView];
    
    
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //扫描区域
    CGRect scanMaskRect = _scanView.frame;
    //扫描区域计算
    _readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:_readerView.bounds];
    
    [_readerView performSelectorInBackground:@selector(start) withObject:nil];
    
    
     [self lineMove];
    
    CGRect frame = _scanView.frame;
    frame.origin.x += 5;
    frame.origin.y += 5;
    frame.size.width -= 10;
    frame.size.height -= 10;
    _backView.holeRect = frame;
    [_backView setNeedsDisplay];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   // [_readerView start];
    
    if (isIOS7) {
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, -20,320, 20)];
        view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:view];
        
//        CGPoint  oldCenter =  _backView.center;
//        oldCenter.y += 20;
//        
//        [_backView setCenter:oldCenter];
        
        _ios7_view = view;
        
    }

}


- (void) viewWillDisappear:(BOOL)animated{
    
    
    if (isIOS7) {
        
        [_ios7_view removeFromSuperview];
        _ios7_view = nil;
        
    }
    
    _scanEnd =  true;

    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    
    return false;
}



-(void)lineMove{

    
    CGRect frame = self.scanLine.frame;
    frame.origin.y = _scanView.frame.origin.y;
    self.scanLine.frame = frame;


    [UIView animateWithDuration:1.5f
                     animations:^{
                         
                         CGRect frame = self.scanLine.frame;
                         frame.origin.y = _scanView.frame.origin.y+_scanView.frame.size.height - self.scanLine.frame.size.height;
                         self.scanLine.frame = frame;
                     }
                     completion:^(BOOL s){
                         
                         if (!_scanEnd) [self lineUp];
                     }];
    

}


-(void)lineUp{

    [UIView animateWithDuration:1.5f
                     animations:^{
                         
                         CGRect frame = self.scanLine.frame;
                         frame.origin.y = _scanView.frame.origin.y;
                         self.scanLine.frame = frame;
                     }
                     completion:^(BOOL s){
                         
                         if (!_scanEnd) [self lineMove];
                     }];

}


-(void)dealloc{

}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    _cancelBtn.enabled = false;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1),dispatch_get_main_queue(), ^{
        
        if (nil != _delegate && [_delegate respondsToSelector:@selector(scanVC:didReadSymbols:)]) {
            
            [_delegate scanVC:self didReadSymbols:symbols];
        }
        
        _cancelBtn.enabled = true;
        
    });
    
    
    //[self cancelBtnClick:nil];
    
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGRect newRect = rect;
    newRect.origin.x = (readerViewBounds.size.width - newRect.size.width)*0.5f;
    newRect.origin.y = (readerViewBounds.size.height - newRect.size.height)*0.5f;
    rect = newRect;
    
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}


- (IBAction)cancelBtnClick:(id)sender{
    

    [self dismissViewControllerAnimated:YES completion:nil];
    //[self removeFromParentViewController];
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(scanVC:closeWithCacncel:)]) {
        
        [_delegate scanVC:self closeWithCacncel:true];
    }

}

@end

@implementation MaskView

- (void)drawRect:(CGRect)rect {
    // Start by filling the area with the blue color
    [[UIColor colorWithRed:35/255.0f green:39/255.0f blue:60/255.0f alpha:0.4] setFill];
    UIRectFill( rect );
    
    // Assume that there's an ivar somewhere called holeRect of type CGRect
    // We could just fill holeRect, but it's more efficient to only fill the
    // area we're being asked to draw.
    CGRect holeRectIntersection = CGRectIntersection(_holeRect, rect );
    
    [[UIColor clearColor] setFill];
    UIRectFill( holeRectIntersection );
}


@end