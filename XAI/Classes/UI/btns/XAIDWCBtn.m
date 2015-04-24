//
//  XAIDWCBtn.m
//  XAI
//
//  Created by office on 15/3/30.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIDWCBtn.h"

@implementation XAIDWCBtn



#define  banjin  24.0f
#define  bian    19.f

- (void) showOprStart{
    _opr = XAIOCOT_Start;
    
    
    if (_bRoll == false) {
        
        _bRoll = true;
        [self startAnimation];
    }
    
}

-(void)startRoll{

    if (_bRoll == false) {
        _bRoll = true;
        [self startAnimation];
    }
}

-(void)stopRoll{

    _bRoll = false;
    [self.layer removeAllAnimations];
}


-(void) startAnimation
{

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _waitRollImageViewIn.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 720.0f));
    _waitRollImageViewOut.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 3600.0f) * -1);
    [UIView commitAnimations];
}

-(void)endAnimation
{
    if (_bRoll) {
        _angle += 10;
        [self startAnimation];
    }
    
}


- (void) showMsg{
    _opr = XAIOCOT_Msg;
    
    [self performSelector:@selector(showErrEnd) withObject:nil afterDelay:3.0f];
}

- (void) showErrEnd{
    
    if (_opr != XAIOCOT_Msg) {
        return;
    }
    
    [self showOprEnd];
    
    //发生了控制错误 需要停止转动,并回到最后一条状态
    [self stopRoll];
    [self setStatus:_status];
    
    
}


- (void) showOprEnd{
    
    _opr = XAIOCOT_None;
    
    //注释原因:  转动设置 都有状态消息决定,不由操作控制决定
    //[self stopRoll];
    //[self setStatus:_status];
    
    
}

-(void)setStatusCB:(XAICBTYPE)type{
    
    XAIDWCtrlStatus status = (XAIDWCtrlStatus)type;
    switch (status) {
        case XAIDWCtrlStatus_Opened:
            [self showOpened];
            break;
        case XAIDWCtrlStatus_Opening:
            [self showOpening];
            break;
        case XAIDWCtrlStatus_Closed:
            [self showClosed];
            break;
        case XAIDWCtrlStatus_Closing:
            [self showClosing];
            break;
        default:
            [self showUnkonw];
            break;
    }
    
}


- (void) showClosed{
    
    
    NSString* closeName = nil;
    
    switch (_type) {
        case XAIObjectType_DWC_C:
            closeName = @"dwctr_c_c.png";
            break;
        case XAIObjectType_DWC_D:
            closeName = @"dwctr_d_c.png";
            break;
        case XAIObjectType_DWC_W:
            closeName = @"dwctr_w_c.png";
            break;
        default:
            return;
    }
    
    _statusTipImgView.image = [UIImage imageWithFile:closeName];
    
    [self setSelBtn:_stopBtn];
    [self stopRoll];
    
    if (_weakObj != nil) {
        [self.oprTipLab setText:[_weakObj.lastOpr allStr]];
        _oneOprTipLabel.text = @"关闭完成";
    }
}

- (void) showClosing{
    
    [self setSelBtn:_closeBtn];

    [self startRoll];
    
    if (_weakObj != nil) {
        //[self.oprTipLab setText:[_weakObj.lastOpr allStr]];
        _oneOprTipLabel.text = @"正在关闭...";
    }
}


- (void) showOpened{
    
    NSString* openName = nil;
    
    switch (_type) {
        case XAIObjectType_DWC_C:
            openName = @"dwctr_c_o.png";
            break;
        case XAIObjectType_DWC_D:
            openName = @"dwctr_d_o.png";
            break;
        case XAIObjectType_DWC_W:
            openName = @"dwctr_w_o.png";
            break;
        default:
            return;
    }
    
    _statusTipImgView.image = [UIImage imageWithFile:openName];
    
    [self setSelBtn:_stopBtn];

    [self stopRoll];
    
    if (_weakObj != nil) {
        [self.oprTipLab setText:[_weakObj.lastOpr allStr]];
        _oneOprTipLabel.text = @"打开完成";
    }
    
}

- (void) showOpening{
    
  
    [self setSelBtn:_openBtn];
    [self startRoll];
    
    if (_weakObj != nil) {
        //[self.oprTipLab setText:[_weakObj.lastOpr allStr]];
        _oneOprTipLabel.text = @"正在打开";
    }
    
}

- (void) showUnkonw{
    
    NSString* unName = nil;
    
    switch (_type) {
        case XAIObjectType_DWC_C:
            unName = @"dwctr_c_u.png";
            break;
        case XAIObjectType_DWC_D:
            unName = @"dwctr_d_u.png";
            break;
        case XAIObjectType_DWC_W:
            unName = @"dwctr_w_u.png";
            break;
        default:
            return;
    }
    
    _statusTipImgView.image = [UIImage imageWithFile:unName];
    
    _oneOprTipLabel.text = @"";

}




-(void)dealloc{
    
}

-(void)bgBtnClick{
    

    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIDWCtrl class]]) return;
    
    if (self.weakObj.isOnline == false)  return;
    
    XAIDWCtrl* oneObj = (XAIDWCtrl*)self.weakObj;
    
    if(oneObj.curDevStatus == XAIDWCtrlStatus_Opened){
        
        [oneObj close];
        [self showOprStart];
        
        
    }else if(oneObj.curDevStatus == XAIDWCtrlStatus_Closed){
        
        [oneObj open];
        [self showOprStart];
    }
    
    
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(btnBgClick:)]) {
        [self.delegate btnBgClick:self];
    }
    
    
}


#pragma mark  delegate
-(void)dwc:(XAIDWCtrl *)dwc openSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [self showOprEnd];
        
    }else{
        
        
        [self showMsg];
        _oneOprTipLabel.text = @"打开异常";
    }
    
    
}

-(void)dwc:(XAIDWCtrl *)dwc closeSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [self showOprEnd];
        
    }else{
        
        [self showMsg];
        _oneOprTipLabel.text = @"关闭异常";
    }
}

-(void)dwc:(XAIDWCtrl *)dwc stopSuccess:(BOOL)isSuccess{

    if (isSuccess) {
        
        [self showOprEnd];
        _oneOprTipLabel.text = @"暂停成功";
        
    }else{
        
        [self showMsg];
        _oneOprTipLabel.text = @"暂停失败";
    }
}



- (void)dwc:(XAIDWCtrl*)dwc curStatus:(XAIDWCtrlStatus)status getIsSuccess:(BOOL)isSuccess{
    
    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIDWCtrl class]]) return;
    
    if (dwc.isOnline == false) {
        
        [self setStatus:XAIDWCtrlStatus_Unkown];
        
        return;
    }
    
    if (status == XAIDWCtrlStatus_Opened) {
        [self setStatus:XAIDWCtrlStatus_Opened];
        [self.oprTipLab setText:[dwc.lastOpr allStr]];
    }else if(status == XAIDWCtrlStatus_Closed){
        [self setStatus:XAIDWCtrlStatus_Closed];
        [self.oprTipLab setText:[dwc.lastOpr allStr]];
    }else if(status == XAIDWCtrlStatus_Closing){
        [self setStatus:XAIDWCtrlStatus_Closing];
        //[self.oprTipLab setText:[dwc.lastOpr allStr]];
    }else if(status == XAIDWCtrlStatus_Opening){
        [self setStatus:XAIDWCtrlStatus_Opening];
        //[self.oprTipLab setText:[dwc.lastOpr allStr]];
    }else{
        
        [self setStatus:XAIDWCtrlStatus_Unkown];
    }
    
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(btnStatusChange:)] ) {
        [self.delegate btnStatusChange:self];
    }
}

- (void) setInfo:(XAIDWCtrl*)aObj withType:(XAIObjectType)type{
    
    [self _removeWeakObj];
    
    if (aObj == nil) return;
    if (![aObj isKindOfClass:[XAIDWCtrl class]]){
        
        [self  firstStatus:XAIDWCtrlStatus_Unkown opr:XAIOCOT_None tip:nil];
        [self.statusTipImgView setBackgroundColor:[UIColor clearColor]];
        [self.statusTipImgView setImage:nil];
        [self.nameTipLab setText:nil];
        [self.oprTipLab setText:nil];
        [self.oneOprTipLabel setText:nil];
        
        return;
    }
    
    _type = type;
    
    
    [self.statusTipImgView setBackgroundColor:[UIColor clearColor]];
    
    if (aObj.nickName != NULL && ![aObj.nickName isEqualToString:@""]) {
        
        [self.nameTipLab setText:aObj.nickName];
    }else{
        
        [self.nameTipLab setText:aObj.name];
    }
    
    
    [self.oprTipLab setText:[aObj.lastOpr allStr]];
    self.oneOprTipLabel.text = @"";
    
    
    
    
    XAICBTYPE status = XAIDWCtrlStatus_Unkown;
    
    if (aObj.isOnline){
        
        status = aObj.lastStatus;

    }
    
    
    [self _changeWeakObj:aObj];
    
    [self firstStatus:status opr:[self coverForm:aObj.curOprStatus] tip:aObj.curOprtip];
    [self setStatus:status];
    
    
    
    
}

- (void) _removeWeakObj{
    
    if (self.weakObj != nil && [self.weakObj isKindOfClass:[XAIDWCtrl class]]) {
        ((XAIDWCtrl*)self.weakObj).delegate = nil;
    }
    self.weakObj = nil;
}

- (void) _changeWeakObj:(XAIObject*)aObj{
    
    [self _removeWeakObj];
    
    
    if ([aObj isKindOfClass:[XAIDWCtrl class]]) {
        
        self.weakObj = aObj;
        ((XAIDWCtrl*)self.weakObj).delegate = self;
        
    }
}



-(void)startEdit{
    
    [super startEdit];
    
    _threeBtnView.hidden = true;
    _threeBtnView.userInteractionEnabled = false;
    
}

-(void)endEdit{
    [super endEdit];
    
    _threeBtnView.hidden = false;
    _threeBtnView.userInteractionEnabled = true;
}




#pragma mark create

- (void) _init{
    
    [super _init];
    
    [self.bgBtn addTarget:self
                   action:@selector(bgBtnClick)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
//    //左右轨的图片
//    UIImage *stetchLeftTrack= [[UIImage imageNamed:@"dwctr_slider_bg.png"]  stretchableImageWithLeftCapWidth:6.0
//topCapHeight:0.0];;
//    UIImage *stetchRightTrack = [[UIImage imageNamed:@"dwctr_slider_bg.png"]  stretchableImageWithLeftCapWidth:3.0
//topCapHeight:0.0];;
//    //滑块图片
//    UIImage *thumbImage = [UIImage imageNamed:@"dwctr_slider_btn.png"];
//    
//    //_chooseSlider.backgroundColor = [UIColor clearColor];
//    //_chooseSlider.value=1.0;
//    //_chooseSlider.minimumValue=0;
//    //_chooseSlider.maximumValue=1.0;
//    
//    [_chooseSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
//    [_chooseSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
//    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
//    [_chooseSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
//    [_chooseSlider setThumbImage:thumbImage forState:UIControlStateNormal];
//
//    //滑动拖动后的事件
//    [_chooseSlider addTarget:self action:@selector(sliderDragUp) forControlEvents:UIControlEventTouchUpInside];
    

    
}


-(void) setSelBtn:(id)oneBtn{

    _openBtn.selected = oneBtn == _openBtn;
    _closeBtn.selected = oneBtn == _closeBtn;
    _stopBtn.selected = oneBtn == _stopBtn;
}

#pragma mark - action
-(void)closeClick:(id)sender{

    if (_closeBtn.selected) return;
    [self setSelBtn:_closeBtn];
    [self startDWCOpr:1];
}
-(void)openClick:(id)sender{
    
    if (_openBtn.selected) return;
    [self setSelBtn:_openBtn];
    [self startDWCOpr:0];
}

-(void)stopClick:(id)sender{
    
    if (_stopBtn.selected) return;
    [self setSelBtn:_stopBtn];
    [self startDWCOpr:0.5];
}


-(void)startDWCOpr:(float)option{

    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIDWCtrl class]]) return;
    
    if (self.weakObj.isOnline == false)  return;
    
    if (option == 0) {
        [(XAIDWCtrl*)self.weakObj  open];
        _oneOprTipLabel.text = @"正在打开...";
    }else if(option == 0.5){
        [(XAIDWCtrl*)self.weakObj  stop];
        _oneOprTipLabel.text = @"正在关闭...";
    }else{
        [(XAIDWCtrl*)self.weakObj  close];
        _oneOprTipLabel.text = @"正在暂停...";
    }
    
    [self showOprStart];
    
    
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(btnBgClick:)]) {
        [self.delegate btnBgClick:self];
    }

    
}


+(XAIDWCBtn*)create{
    
    XAIDWCBtn* obj = [[[UINib nibWithNibName:@"DWCBtnView" bundle:[NSBundle mainBundle]] instantiateWithOwner:nil options:nil] lastObject];
    
    if ([obj isKindOfClass:[XAIDWCBtn class]]) {
        
        [obj _init];
        return  obj;
    }
    
    return nil;
}


@end
