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
#import "XAIToken.h"
#import "XAIObjectGenerate.h"


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
        
        _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
        _userService.userServiceDelegate = self;
        
        _isChangeBufang = false;

        _tipAlpha = 1.0;
    }
    
    return self;
    
}

-(void)dealloc{

    _userService.userServiceDelegate = nil;
    [_userService willRemove];
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    if ([[MQTT shareMQTT].curUser isAdmin] == false) {
        _addBtn.hidden = true;
    }
    
    [self addDevCategory];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _swipes = [[NSArray alloc] initWithArray:[self openSwipe]];
    
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTipNum) userInfo:nil repeats:true];
    
    _alphaTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(alphaChange) userInfo:nil repeats:true];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self stopSwipte:_swipes];
    
    [super viewDidDisappear:animated];
    
    [_refreshTimer invalidate];
    [_alphaTimer invalidate];
    _refreshTimer = nil;
    _alphaTimer = nil;
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



-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer{
    
//    [self animalView_R2L:[XAISetVC create].view];
    [self animalVC_R2L:[XAISetVC create]];

    
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer{

    if ([[MQTT shareMQTT].curUser isAdmin]) {
        [self animalVC_L2R:[XAILinkageListVC createWithNav]];
    }
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
    
    if (sender.type == XAICategoryType_bufang) {
        [self changeBufang];
    }
    
    UIViewController* next = [XAICategoryTool nextViewforType:sender.type];
    if (nil == next) return;
    
    [self.view.window setRootViewController:next];
}


- (void) changeBufang{

    if (_isChangeBufang == true) {
        return;
    }
    
    _isChangeBufang = true;
    
    
    
    void* token = malloc(TokenSize+20);
    memset(token, 0, TokenSize);
    
    [XAIToken getToken:&token size:NULL];
    
    
    [_userService pushToken:token size:TokenSize isBufang:![MQTT shareMQTT].isBufang];
    
    free(token);

}

#pragma mark - Helper
//- (void) addDevCategory{
//
//    NSArray* devCategorys =  [XAICategoryTool devCategorys];
//    int buttonCount  = [devCategorys count];
//    int rowButtons = 2;
//    int rows = (buttonCount + 1)/rowButtons;
//    
//    CGSize scViewSize = self.scrollView.frame.size;
//    
//    float sideSpaceLR = 8.0f;
//    float sideSpaceUD = 8.0f;
//    float udSpace = 15.0f;
//    float midSpace =  15.0f;
//    float buttonHeight = 142.0f;
//    float buttonWidth = (scViewSize.width - 2*sideSpaceLR - (rowButtons - 1)*midSpace) / rowButtons;
//    buttonWidth =  142.f;
//    
//    float height = rows*buttonHeight + (rows - 1)*udSpace + 2*sideSpaceUD;
//    
//    [self.scrollView setContentSize:CGSizeMake(scViewSize.width, height)];
//    
//    for (int i = 0; i < buttonCount; i++) {
//        
//        float rowIn = (i + 2) / rowButtons;
//        float colIn = i % rowButtons + 1;
//        
//        float orignX = (colIn - 1) * (midSpace + buttonWidth) + sideSpaceLR;
//        float orignY = (rowIn - 1) * (udSpace + buttonHeight) + sideSpaceUD;
//        XAICategoryBtn* catbtn = [[XAICategoryBtn alloc] initWithFrame:
//                               CGRectMake(orignX, orignY,buttonWidth, buttonHeight)];
//        
//        [catbtn setType:[[devCategorys objectAtIndex:i] intValue]];
//        
//        [catbtn addTarget:self
//                   action:@selector(categoryClick:)
//         forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.scrollView addSubview:[catbtn view]];
//        
//        [_categorys addObject:catbtn];
//        
//    }
//    
//    
//    if (self.scrollView.contentSize.height > scViewSize.height) {
//        self.scrollView.scrollEnabled = true;
//    }else{
//        self.scrollView.scrollEnabled = false;
//    }
//    
//    
//
//}



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
    
    if ([UIScreen is_35_Size]) {
        
        buttonHeight = 100.0f;
    }
    
    float height = rows*buttonHeight + (rows - 1)*udSpace + 2*sideSpaceUD;
    
    [self.scrollView setContentSize:CGSizeMake(scViewSize.width, height)];
    
    for (int i = 0; i < buttonCount; i++) {
        
        float rowIn = (i + 2) / rowButtons;
        float colIn = i % rowButtons + 1;
        
        float orignX = (colIn - 1) * (midSpace + buttonWidth) + sideSpaceLR;
        float orignY = (rowIn - 1) * (udSpace + buttonHeight) + sideSpaceUD;
        XAICategoryBtn* catbtn = [[XAICategoryBtn alloc] initWithFrame:
                                  CGRectMake(orignX, orignY,buttonWidth, buttonHeight)];
        
        if ([UIScreen is_35_Size]) {
            [catbtn setScale:0.8];
        }
        
        XAICategoryType type = [[devCategorys objectAtIndex:i] intValue];
        
        [catbtn setType:type];
        
        [catbtn addTarget:self
                   action:@selector(categoryClick:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:[catbtn view]];
        
        [_categorys addObject:catbtn];
        
        if (type == XAICategoryType_bufang) {
            if ([MQTT shareMQTT].isBufang == true) {
                catbtn.imgView.image = [UIImage imageWithFile:@"font_chefang.png"];
//                catbtn.showBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2f, 1.2f);
            }
            
            [catbtn setSelect:[MQTT shareMQTT].isBufang];
            _bufangBtn = catbtn;
        }
        
    }
    
    
    if (self.scrollView.contentSize.height > scViewSize.height) {
        self.scrollView.scrollEnabled = false;
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

    XAIScanVC* scanvc =[XAIScanVC create];
    
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

-(void)userService:(XAIUserService *)userService pushToken:(BOOL)isSuccess
           errcode:(XAI_ERROR)errcode{

    if ((YES == isSuccess) &&  (errcode == XAI_ERROR_NONE)) {
        
        
        [MQTT shareMQTT].isBufang = ![MQTT shareMQTT].isBufang;
        
    }else{
        
        
    }
    
    if (_bufangBtn != nil) {
        
        if ([MQTT shareMQTT].isBufang) {
            _bufangBtn.imgView.image = [UIImage imageWithFile:@"font_chefang.png"];
//            _bufangBtn.showBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2f, 1.2f);
        }else{
            _bufangBtn.imgView.image = [UIImage imageWithFile:@"font_bufang.png"];
//            _bufangBtn.showBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        }
    }
    

    [_bufangBtn setSelect:[MQTT shareMQTT].isBufang];
    _isChangeBufang = false;
    
}

//显示提示数字
- (void) showTipNum{

    NSArray*  allObjs = [[XAIData shareData] listenObjs];
    int openLightCount = 0;
    int openDWCount = 0;
    int openInfCount = 0;
    int notReadImCount = 0;
    
    for (XAIObject* aObj in allObjs) {
        
        if (![aObj isKindOfClass:[XAIObject class]]) continue;
        
        switch (aObj.type) {
            case XAIObjectType_light:
            case XAIObjectType_light2_1:
            case XAIObjectType_light2_2:{
            
                if (aObj.curDevStatus == XAILightStatus_Open) {
                    
                    openLightCount += 1;
                }
                
                break;
            }
            
            case XAIObjectType_door:{
            
                if (aObj.curDevStatus == XAIDoorStatus_Open) {
                    
                    openDWCount += 1;
                }
                
                break;
            }
            
            case XAIObjectType_window:{
            
                if (aObj.curDevStatus == XAIWindowStatus_Open) {
                    
                    openDWCount += 1;
                }
                
                break;
            }
            
            case XAIObjectType_IR:{
            
                if (aObj.curDevStatus == XAIIRStatus_warning) {
                    
                    openInfCount += 1;
                }
                
                break;
            
            }
                
            default:
                break;
        }
    }
    
    
    NSArray* users = [[XAIData shareData] getUserList];
    XAIUser* curUser =  [MQTT shareMQTT].curUser;
    
    
    for (XAIUser* aUser in users) {
        
        notReadImCount +=  [curUser countOfOneNotReadIMCountWithLuid:aUser.luid
                                                                apsn:aUser.apsn];
    }
    
    //添加server
    notReadImCount += [curUser countOfOneNotReadIMCountWithLuid:MQTTCover_LUID_Server_03
                                                           apsn:[MQTT shareMQTT].apsn];
    
    for (XAICategoryBtn* btn in  _categorys) {
        
        switch (btn.type) {
            case XAICategoryType_light:
                [btn setNumber:openLightCount];
                break;
            case XAICategoryType_doorwin:
                [btn setNumber:openDWCount];
                break;
            case XAICategoryType_Inf:
                [btn setNumber:openInfCount];
                break;
            default:
                break;
        }
    }
    
    
    if (notReadImCount > 99) {
        notReadImCount = 99;
    }
    
    [_label setText:[NSString stringWithFormat:@"%d",notReadImCount]];
    [_labelIV setHidden:notReadImCount <=0 ? true : false];
    [_label setHidden:notReadImCount <=0 ? true : false];
    [_chatTipV setHidden:notReadImCount <=0 ? true : false];
    
}

- (void) alphaChange{

    _tipAlpha += _tipAlphaAdd;
    
    if (_tipAlphaAdd == 0) {// 第一次进入
        _tipAlphaAdd = -0.03;
    }
    
    if (_tipAlpha <= 0.3) {
        _tipAlphaAdd = 0.04;
    }else if(_tipAlpha >= 1.2){
        _tipAlphaAdd = -0.04;
    }
    
    _chatTipV.alpha = _tipAlpha;
    
    //_chatTipV.hidden = true;

}

@end

