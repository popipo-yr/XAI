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
    [self changeBufangStatus];
    
    
    float cvAddHeight = 100;
    float cvOldHeight = self.centerView.frame.size.height;


    
    
    //_centerView.backgroundColor = [UIColor redColor];

    CALayer *layer = [_centerView layer];
    CGPoint oldAnchorPoint = layer.anchorPoint;
    [layer setAnchorPoint:CGPointMake(0.5, 0)];
    [layer setPosition:CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - oldAnchorPoint.x), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - oldAnchorPoint.y))];
    
    self.centerView.transform =  CGAffineTransformMakeScale(1, (cvAddHeight + cvOldHeight) / cvOldHeight);
    
    CGAffineTransform t = CGAffineTransformMakeScale(1,1);


    [UIView animateWithDuration:0.1f
                     animations:^{
                         self.centerView.transform = t;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    
    CGRect jiaoHuFrame = _jiaohuView.frame;
    float  jiaoHuMove = 200;
    
    CGRect jiaohuMoveFrame = jiaoHuFrame;
    jiaohuMoveFrame.origin.y +=  jiaoHuMove;
    _jiaohuView.frame = jiaohuMoveFrame;
    
    CGRect bufangFrame = _bufangBtn.frame;
    float  bufangMove = 200;
    
    CGRect bufangMoveFrame = bufangFrame;
    bufangMoveFrame.origin.y +=  bufangMove;
    _bufangBtn.frame = bufangMoveFrame;
    
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         _jiaohuView.frame = jiaoHuFrame;
                        
                         
                     }
                     completion:^(BOOL finished) {
                         
                         
                         [UIView beginAnimations:@"ccc" context:nil];
                         [UIView setAnimationDelay:0.3f];
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(delayAnimal)];
                         //[UIView animateWithDuration:0.2 animations:^{
                             _bufangBtn.frame = bufangFrame;
                         //}];
                         
                         
                         
                         
                         [UIView commitAnimations];
                         
                         
                         
//                         [UIView animateWithDuration:0.2 animations:^{
//                             _bufangBtn.frame = bufangFrame;
//                         }];
                         
                         
                         
                     }];
    
     [XAIShowVC rarEffect:_jiaohuView];
    
}

-(void)delayAnimal{

    [XAIShowVC rarEffect:_bufangBtn];
    
}

#define DegreesToRadians(x) (M_PI * x / 180.0)

+(void)rarEffect:(UIView *)target
{
    
    CALayer *layer = [target layer];
    CATransform3D transform = layer.transform;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = [NSArray arrayWithObjects:
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, DegreesToRadians(-70), 1, 0, 0)],
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, DegreesToRadians(0), 1, 0, 0)],
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, DegreesToRadians(70), 1, 0, 0)],
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, DegreesToRadians(0), 1, 0, 0)],
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, DegreesToRadians(-50), 1, 0, 0)],
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, DegreesToRadians(0), 1, 0, 0)],
//                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, DegreesToRadians(40), 1, 0, 0)],
//                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, DegreesToRadians(0), 1, 0, 0)],
                        nil];
    animation.duration = 0.7f;
    [layer addAnimation:animation forKey:animation.keyPath];
}





- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (_swipes != nil) return;
    
    _swipes = [[NSArray alloc] initWithArray:[self openSwipe]];
    
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTipNum) userInfo:nil repeats:true];
    
    _alphaTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(alphaChange) userInfo:nil repeats:true];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self setNeedsStatusBarAppearanceUpdate];
        
    }
    
}


-(void)viewDidDisappear:(BOOL)animated{

    [self stopSwipte:_swipes];
    _swipes = nil;
    
    [_refreshTimer invalidate];
    [_alphaTimer invalidate];
    _refreshTimer = nil;
    _alphaTimer = nil;
    
    [super viewDidDisappear:animated];
}


-(BOOL)prefersStatusBarHidden{
    
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

//-(void)viewDidAppear:(BOOL)animated{
//    
//    [super viewDidAppear:animated];
//    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        
//        [self setNeedsStatusBarAppearanceUpdate];
//        
//    }
//    
//}



-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    
    [self animalVC_R2L:[XAISetVC create]];

    
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer{

        [self animalVC_L2R:[XAILinkageListVC createWithNav]];
}



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



-(UIImage*)procMaoBoLi:(UIImage*)oldImage inFrame:(CGRect)frame{

    UIImage *image = oldImage;
    
    
    //剪切图片
    CGImageRef  useImg = CGImageCreateWithImageInRect(image.CGImage, frame);
    image = [UIImage imageWithCGImage:useImg];
    CGImageRelease(useImg);
    

    //滤镜
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:5] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGRect rect             = [result extent];
    rect.origin.x          += (rect.size.width  - image.size.width ) / 2;
    rect.origin.y          += (rect.size.height - image.size.height) / 2;
    rect.size               = image.size;
    
    
    CIContext *othercontext      = [CIContext contextWithOptions:nil];
    CGImageRef cgimg        = [othercontext createCGImage:result fromRect:rect];
    image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return image;
}

-(void) addMaoBoLiCenter:(UIImage*)image{

    UIImageView* view  = [[UIImageView alloc]initWithImage:image];
    view.backgroundColor = [UIColor clearColor];
    
    [self.centerView insertSubview:view atIndex:0];
}

-(void) addMaoBoLiBufang:(UIImage*)image{
    
    UIImageView* view  = [[UIImageView alloc]initWithImage:image];
    view.backgroundColor = [UIColor clearColor];
    view.frame = self.bufangBtn.frame;
    
    [self.view insertSubview:view belowSubview:self.bufangBtn];

}

-(void) addMaoBoLi{
    
    return;

    self.centerView.hidden = true;
    
    __block UIImage *image = nil;
    
    
    
    //    if(UIGraphicsBeginImageContextWithOptions != NULL)
    //    {
    //        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    //    } else {
    UIGraphicsBeginImageContext(self.view.frame.size);
    //    }
    
    //获取图像
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    __block  CGRect centerRect = self.centerView.frame;
    __block  CGRect bufangBtnRect = self.bufangBtn.frame;
    NSLog(@"kkkkkk====%p,%p",image , &centerRect);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        UIImage* cenImg = [self procMaoBoLi:image inFrame:centerRect];
        dispatch_semaphore_signal(semaphore);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addMaoBoLiCenter:cenImg];
        });
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        UIImage* bufangImg = [self procMaoBoLi:image inFrame:bufangBtnRect];
        dispatch_semaphore_signal(semaphore);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addMaoBoLiBufang:bufangImg];
        });
    });
    
    self.centerView.hidden = false;
    
}

- (void) addDevCategory{
    
    NSArray* devCategorys =  [XAICategoryTool devCategorys];
    int buttonCount  = [devCategorys count];
    int rowButtons = 2;
    int rows = (buttonCount + 1)/rowButtons;
    
    CGSize scViewSize = self.scrollView.frame.size;
    
   float buttonHeight = scViewSize.height / 3.0f;
   float buttonWidth = scViewSize.width / 2.0f;
    
    UIImageView*  sepImgV = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
    sepImgV.image = [UIImage imageWithFile:@"cg_center_spe.png"];
    [self.scrollView addSubview:sepImgV];
    
    

    
    if ([UIScreen is_35_Size]) {
        
        //buttonHeight = 100.0f;
        CGRect frame = self.centerView.frame;
        frame.size.height = frame.size.height / 3.0f * 2.0f; //3.5寸只显示2个
        frame.origin.y += 20;
        self.centerView.frame = frame;
        
        CGRect childFrame = self.centerBgImgV.frame;
        childFrame.size.height = frame.size.height;
        
        self.centerBgImgV.frame = childFrame;
        self.scrollView.frame = childFrame;
        
    }
    

    float totalH = self.jiaohuView.frame.origin.y - 64;
    float inverlTop = (totalH - self.centerView.frame.size.height) *0.5f;
    
    CGRect frame = self.centerView.frame;
    frame.origin.y = 64 + inverlTop;
    self.centerView.frame = frame;
    
    [self addMaoBoLi];
   
    
    float height = rows*buttonHeight;
    
    [self.scrollView setContentSize:CGSizeMake(scViewSize.width, height)];
    
    for (int i = 0; i < buttonCount; i++) {
        
        int rowIn = (i + 2) / rowButtons;
        int colIn = i % rowButtons + 1;

        
        float orignX = (colIn - 1) * buttonWidth;
        float orignY = (rowIn - 1) * buttonHeight;
        
        XAICategoryBtn* catbtn = [[XAICategoryBtn alloc] initWithFrame:
                                  CGRectMake(orignX, orignY,buttonWidth, buttonHeight)];
        
        
        XAICategoryType type = [[devCategorys objectAtIndex:i] intValue];
        
        [catbtn setType:type];
        
        [catbtn addTarget:self
                   action:@selector(categoryClick:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:[catbtn view]];
        
        [_categorys addObject:catbtn];
        
//        if ([UIScreen is_35_Size]) {//设置缩放 调整位置
//            [catbtn setScale:0.8];
//        }
        

        
    }
    
     
    
    if (self.scrollView.contentSize.height > self.scrollView.frame.size.height) {
        self.scrollView.scrollEnabled = true;
    }else{
        self.scrollView.scrollEnabled = false;
    }
    
    
    
}


-(void) changeBufangStatus{


    _bufangBtn.selected = [MQTT shareMQTT].isBufang;

}

-(void)bufangBtnClick:(id)sender{

    [self changeBufang];
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
        
        [self changeBufangStatus];

        _isChangeBufang = false;
    }
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
            
                if (aObj.isOnline && aObj.curDevStatus == XAILightStatus_Open) {
                    
                    openLightCount += 1;
                }
                
                break;
            }
            
            case XAIObjectType_door:{
            
                if (aObj.isOnline && aObj.curDevStatus == XAIDoorStatus_Open) {
                    
                    openDWCount += 1;
                }
                
                break;
            }
            
            case XAIObjectType_window:{
            
                if (aObj.isOnline && aObj.curDevStatus == XAIWindowStatus_Open) {
                    
                    openDWCount += 1;
                }
                
                break;
            }
            
            case XAIObjectType_IR:{
            
                if (aObj.isOnline && aObj.curDevStatus == XAIIRStatus_warning) {
                    
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
    //[_labelIV setHidden:notReadImCount <=0 ? true : false];
    [_label setHidden:notReadImCount <=0 ? true : false];
   
    BOOL hasRedTip = [MQTT shareMQTT].isBufang && (openLightCount > 0 || openDWCount > 0 || openInfCount > 0);
    BOOL hasNorTip = notReadImCount > 0;
    
    //[_chatTipV setHidden:!hasRedTip && !hasNorTip];
    
    if (hasRedTip) {
        
        [_chatTipV setImage:[UIImage imageWithFile:@"bufangTip.png"]];
        
    }else if(hasNorTip){
        
        [_chatTipV setImage:[UIImage imageWithFile:@"chatTip.png"]];
        
    }
    
    
    if ([MQTT shareMQTT].isBufang) {

        
        if (hasRedTip) {
            [_bufangBtn setImage:[UIImage imageWithFile:@"cg_bufangCancel_sel.png"] forState:UIControlStateHighlighted];
            [_bufangBtn setImage:[UIImage imageWithFile:@"cg_bufangCancel_sel.png"] forState:UIControlStateSelected];
        }else{
            [_bufangBtn setImage:[UIImage imageWithFile:@"cg_bufang_sel.png"] forState:UIControlStateHighlighted];
            [_bufangBtn setImage:[UIImage imageWithFile:@"cg_bufang_sel.png"] forState:UIControlStateSelected];
        }
        
    }
    

    
    
}

- (void) alphaChange{
    return;

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

