//
//  XAIShowVC.m
//  XAI
//
//  Created by office on 14-8-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIShowVC.h"
#import "XAICategoryBtn.h"
#import "XAISetVC.h"
#import "XAILinkageListVC.h"
#import "XAIDevAddVC.h"

@interface XAIShowVC ()

@end

@implementation XAIShowVC

+(UIViewController *)create{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_ShowVCID];
    //[vc changeIphoneStatus];
    return vc;

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _categorys = [[NSMutableArray alloc] init];
    }
    
    return self;
    
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    [self addDevCategory];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _swipes = [[NSArray alloc] initWithArray:[self openSwipe]];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self stopSwipte:_swipes];
    
    [super viewDidDisappear:animated];
}


-(BOOL)prefersStatusBarHidden{
    
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self setNeedsStatusBarAppearanceUpdate];
        
    }
}


- (void)dealloc{
    
}

-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer{
    
//    [self animalView_R2L:[XAISetVC create].view];
    [self animalVC_R2L:[XAISetVC create]];

    
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer{

    [self animalVC_L2R:[XAILinkageListVC create]];
}

//-(void)finish_R2L{
//
//    [[UIApplication sharedApplication].delegate.window setRootViewController:[XAISetVC create]];
//    [self changeIphoneStatus];
//}
//
//-(void)finish_L2R{
//}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - category event
- (void) categoryClick:(XAICategoryBtn*)sender{

    if (![sender isKindOfClass:[XAICategoryBtn class]]) return;
    
    UIViewController* next = [XAICategoryTool nextViewforType:sender.type];
    if (nil == next) return;
    
    [self.view.window setRootViewController:next];
}


#pragma mark - Helper
- (void) addDevCategory{

    NSArray* devCategorys =  [XAICategoryTool devCategorys];
    int buttonCount  = [devCategorys count];
    int rowButtons = 2;
    int rows = (buttonCount + 1)/rowButtons;
    
    CGSize scViewSize = self.scrollView.frame.size;
    
    float sideSpaceLR = 8.0f;
    float sideSpaceUD = 8.0f;
    float udSpace = 15.0f;
    float midSpace =  15.0f;
    float buttonHeight = 142.0f;
    float buttonWidth = (scViewSize.width - 2*sideSpaceLR - (rowButtons - 1)*midSpace) / rowButtons;
    buttonWidth =  142.f;
    
    float height = rows*buttonHeight + (rows - 1)*udSpace + 2*sideSpaceUD;
    
    [self.scrollView setContentSize:CGSizeMake(scViewSize.width, height)];
    
    for (int i = 0; i < buttonCount; i++) {
        
        float rowIn = (i + 2) / rowButtons;
        float colIn = i % rowButtons + 1;
        
        float orignX = (colIn - 1) * (midSpace + buttonWidth) + sideSpaceLR;
        float orignY = (rowIn - 1) * (udSpace + buttonHeight) + sideSpaceUD;
        XAICategoryBtn* catbtn = [[XAICategoryBtn alloc] initWithFrame:
                               CGRectMake(orignX, orignY,buttonWidth, buttonHeight)];
        
        [catbtn setType:[[devCategorys objectAtIndex:i] intValue]];
        
        [catbtn addTarget:self
                   action:@selector(categoryClick:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:[catbtn view]];
        
        [_categorys addObject:catbtn];
        
    }
    
    
    if (self.scrollView.contentSize.height > scViewSize.height) {
        self.scrollView.scrollEnabled = true;
    }else{
        self.scrollView.scrollEnabled = false;
    }
    
    

}


-(IBAction)userBtnClick:(id)sender{

    XAICategoryBtn* btn = [[XAICategoryBtn alloc] init];
    btn.type = XAICategoryType_user;
    [self categoryClick:btn];
}

-(IBAction)devAddBtnClick:(id)sender{

    XAIScanVC* scanvc = [self.storyboard instantiateViewControllerWithIdentifier:XAIScanVC_SB_ID];
    
    if ([scanvc isKindOfClass:[XAIScanVC class]]) {
        
        scanvc.delegate = self;
        
        [self presentViewController:scanvc animated:YES completion:nil];
    }

}


-(void)scanVC:(XAIScanVC *)scanVC didReadSymbols:(ZBarSymbolSet *)symbols{
    
    
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    NSString* luidstr = nil;
    
    if ([MQTTCover qrStr:symbolStr ToLuidStr:&luidstr]) {
        
        [scanVC dismissViewControllerAnimated:YES completion:^(){
        
             self.view.window.rootViewController = [XAIDevAddVC create:luidstr];
        }];
    }
    
}


@end

