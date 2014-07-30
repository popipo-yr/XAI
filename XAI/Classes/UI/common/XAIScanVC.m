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
    
    float startx =  2;
    float starty = 2;
    
    CGRect frame = CGRectMake(_scanView.frame.origin.x+startx,
                              _scanView.frame.origin.y+starty,
                              _scanView.frame.size.width-startx*2,
                              _scanView.frame.size.height-starty*2);
    
    _readerView.frame = CGRectMake(startx,starty, frame.size.width, frame.size.height);
    //[_readerView setBackgroundColor:[UIColor clearColor]];
    _readerView.readerDelegate = self;
    
    //关闭闪光灯
    _readerView.torchMode = 0;
    
    

    
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = _readerView;
    }
    
    //扫描区域
    //CGRect scanMaskRect = frame;
    //扫描区域计算
    // _readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:_readerView.bounds];
    
    [_readerView.scanner setSymbology: ZBAR_I25
                               config: ZBAR_CFG_ENABLE
                                   to: 0];
    
    //[_readerView start];

    //dispatch_async(dispatch_get_main_queue(), ^{[_readerView start];});
    
    [_readerView performSelectorInBackground:@selector(start) withObject:nil];
    
    
    [_scanView addSubview:_readerView];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   // [_readerView start];
    
    if (isIOS7) {
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, -20,320, 20)];
        view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:view];
        
        CGPoint  oldCenter =  _backView.center;
        oldCenter.y += 20;
        
        [_backView setCenter:oldCenter];
        
        _ios7_view = view;
        
    }

}


- (void) viewWillDisappear:(BOOL)animated{
    
    
    if (isIOS7) {
        
        [_ios7_view removeFromSuperview];
        _ios7_view = nil;
        
    }
    

    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(scanVC:didReadSymbols:)]) {
        
        [_delegate scanVC:self didReadSymbols:symbols];
    }
    
    //[self cancelBtnClick:nil];
    
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
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

}

@end
