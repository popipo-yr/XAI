//
//  XAIChatVC
//  
//
//  Created by iHope on 13-11-8.
//  Copyright (c)  All rights reserved.
//

#import "XAIChatVC.h"

#import "MQTT.h"

#define  XAIChatVCID @"XAIChatVCID"

@implementation XAIChatVC

+(UIViewController*) create:(XAIUser *)user{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone_Other" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:XAIChatVCID];
    
    [(XAIChatVC*)vc setUser:user];
    
    [vc changeIphoneStatus];
    return vc;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _mobile = [[XAIMobileControl alloc] init];
        _mobile.apsn = [MQTT shareMQTT].apsn;
        _mobile.luid = MQTTCover_LUID_Server_03;
        _mobile.mobileDelegate = self;
        
        _msgs = [[NSMutableArray alloc] init];
        _KeyBoardHeight = 0;
        
        _shows = [[NSMutableArray alloc] init];

    }
    
    return self;
    
}

-(void)dealloc{

    [_mobile willRemove];
    _mobile.mobileDelegate = nil;
}

-(void)backClick:(id)sender{

    //[self animalVC_R2L:[XAIUser cr]]
}

- (void) setUser:(XAIUser*)user{
    _user = user;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    
    
    _oldMovePoint = CGPointMake(_moveView.center.x,_moveView.center.y);
    
    _textField.returnKeyType =  UIReturnKeyDone;
    
    
     [_textField addTarget:self action:@selector(chatInputReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    self.navigationItem.title =  [NSString stringWithFormat:@"正在与%@对话",_user.name];
    //_cNavigationItem.title =  [NSString stringWithFormat:@"正在与%@对话",_user.name];
    XAIUser* curUser = [MQTT shareMQTT].curUser;
    _msgs = [[NSMutableArray alloc] initWithArray:
             [XAIUser readIM:curUser.luid apsn:curUser.apsn withLuid:_user.luid apsn:_user.apsn]];
    
    [self createShows];
    
    
    _oldTableFrame = self.tableView.frame;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [_mobile startListene];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    
    [self changeTableView];

    XAIUser* curUser = [MQTT shareMQTT].curUser;
    [XAIUser readIMEnd:curUser.luid apsn:curUser.apsn withLuid:_user.luid apsn:_user.apsn];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
    [_mobile stopListene];
    
    [super viewDidDisappear:animated];
    
    XAIUser* curUser = [MQTT shareMQTT].curUser;
    [XAIUser readIMEnd:curUser.luid apsn:curUser.apsn withLuid:_user.luid apsn:_user.apsn];
}


- (void) createShows{
    

    XAIMeg* preMsg = nil;
    
    NSMutableArray* msgAndDate = [[NSMutableArray alloc] init];

    
    for (int i = 0; i < [_msgs count]; i++) {
        
        XAIMeg* curMsg = [_msgs objectAtIndex:i];
        
        if (preMsg == nil) {
            
            [msgAndDate addObject:curMsg];
            preMsg = curMsg;
            continue;
        }
        
        if ([curMsg.date timeIntervalSinceNow]*-1 > 24*60*60) {
            
            if ([curMsg.date timeIntervalSinceDate:preMsg.date] > 24*60*60 ) {
                
                [msgAndDate addObject:preMsg.date];
            }
            
            [msgAndDate addObject:curMsg];
            
        }else if([curMsg.date timeIntervalSinceNow]*-1 > 1*60*60){
        
            if ([curMsg.date timeIntervalSinceDate:preMsg.date] > 1*60*60 ) {
                
                [msgAndDate addObject:preMsg.date];
                
            }
            
            [msgAndDate addObject:curMsg];
        
        }else{
        
        
            if ([curMsg.date timeIntervalSinceDate:preMsg.date] > 5*60 ) {
                
                [msgAndDate addObject:preMsg.date];
            }
            
            [msgAndDate addObject:curMsg];
        }
        
        preMsg = curMsg;
        
    }
    
    if ([preMsg.date timeIntervalSinceNow]*-1 > 5*60) {
        [msgAndDate addObject:preMsg.date];
    }
    
    _shows = [[NSMutableArray alloc] initWithArray:msgAndDate];

}


#define STATUS_BAR_HEIGHT  0

// 根据键盘状态，调整_mainView的位置
- (void) changeContentViewPoint:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        
        _moveView.center = CGPointMake(_moveView.center.x,
                        keyBoardEndY - STATUS_BAR_HEIGHT - _moveView.bounds.size.height/2.0);
        // keyBoardEndY的坐标包括了状态栏的高度，要减去
        
        
        _KeyBoardHeight = self.view.frame.size.height - keyBoardEndY;
        
        self.tableView.frame = CGRectMake(_oldTableFrame.origin.x,
                                          _oldTableFrame.origin.y + _KeyBoardHeight,
                                          _oldTableFrame.size.width,
                                          _oldTableFrame.size.height - _KeyBoardHeight);
        
        [self performSelector:@selector(changeTableView) withObject:nil];
        
    }];
    

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



-(void)sendBtnClick:(id)sender{
    
    if (_textField.text == nil ||  [_textField.text isEqualToString:@""]) return;
    
    XAIMeg* msg = [[XAIMeg alloc] init];
    msg.context = _textField.text;
    msg.date = [NSDate new];
    msg.fromAPSN =  [MQTT shareMQTT].apsn;
    msg.fromLuid = [MQTT shareMQTT].luid;
    msg.toAPSN = _user.apsn;
    msg.toLuid = _user.luid;
    
    [_msgs addObject:msg];
    
    do {
        
        if ([_shows count] == 0) break;
        
        XAIMeg* obj = [_shows lastObject];
        
        if (![obj isKindOfClass:[XAIMeg class]])break;
        
        
        if ([obj.date timeIntervalSinceNow] < 5*60) break;
        
        [_shows addObject:obj.date];
        
        
    } while (0);
    
    
    [_shows addObject:msg];

    
    XAIUser* curUser = [MQTT shareMQTT].curUser;
    [XAIUser saveIM:_msgs meLuid:curUser.luid apsn:curUser.apsn withLuid:_user.luid apsn:_user.apsn];
    
    [_mobile sendMsg:_textField.text toApsn:_user.apsn toLuid:_user.luid];
    
    _textField.text = nil;
    [self.tableView reloadData];
    
    [self changeTableView];
}


-(void)chatInputReturn:(id)sender{
    
    [_textField resignFirstResponder];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:0.22 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:0.22];
        
        _moveView.center = _oldMovePoint;
        // keyBoardEndY的坐标包括了状态栏的高度，要减去
        
    }];
    
    
    self.tableView.frame = _oldTableFrame;
    
    _KeyBoardHeight = 0;
    
}




#pragma helper

- (float) cellHeight:(NSIndexPath*)indexPath{

    XAIMeg *amsg = [_shows  objectAtIndex:indexPath.row];
    
    if ([amsg isKindOfClass:[XAIMeg class]]) {
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:20]};
        CGSize size = [amsg.context boundingRectWithSize:CGSizeMake(180, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        
        return size.height+44;
    }else{
    
        return 30;
    }
    

}

- (BOOL) needChange{

    BOOL needChange = false;
    
    float allHeight = 0;
    
    for (int i = [_shows count] - 1; i >= 0 ; i--) {
        
        allHeight += [self cellHeight:[NSIndexPath indexPathForRow:i inSection:0]];
    
        if (allHeight >  self.tableView.frame.size.height ) {
            
            needChange = true;
            break;
        }
    }
    
    return needChange;
    
}

- (void)changeTableView{

    if ([_shows count] > 0 &&
        (_KeyBoardHeight <= 0 || (_KeyBoardHeight > 0 && [self needChange]))) {
        
        NSIndexPath* ip = [NSIndexPath indexPathForRow:([_shows count] - 1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shows.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeight:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSObject* aObj = [_shows objectAtIndex:indexPath.row];
    
    if ([aObj isKindOfClass:[XAIMeg class]]) {
        
        
        static NSString *CellIdentifier = XAIChatCellID;
        XAIChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[XAIChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        XAIMeg *aMsg = (XAIMeg*)aObj;
        
        BOOL isMe = (aMsg.fromLuid == [MQTT shareMQTT].curUser.luid &&
                     aMsg.fromAPSN == [MQTT shareMQTT].curUser.apsn);
        [cell setContent:aMsg isfromeMe:isMe];
        
        return cell;
        
    }else if([aObj isKindOfClass:[NSDate class]]){
    
        static NSString *CellIdentifier = XAIChatTimeCellID;
        XAIChatTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[XAIChatTimeCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        [cell setDate:(NSDate*)aObj];
        
        return cell;
    
    }
    
    return nil;
}


-(void)mobileControl:(XAIMobileControl *)mc sendStatus:(XAI_ERROR)err{

}

-(void)mobileControl:(XAIMobileControl *)mc newMsg:(XAIMeg *)msg{

    if (msg.fromLuid != _user.luid) return;
    
    [_msgs addObject:msg];
    
    do {
        
        if ([_shows count] == 0) break;
        
        XAIMeg* obj = [_shows lastObject];
        
        if (![obj isKindOfClass:[XAIMeg class]])break;
        
        
        if ([obj.date timeIntervalSinceNow] < 5*60) break;
        
        [_shows addObject:obj.date];
        
        
    } while (0);
    
    
    [_shows addObject:msg];
    
    [self.tableView reloadData];
    
    [self changeTableView];
    
}

@end
