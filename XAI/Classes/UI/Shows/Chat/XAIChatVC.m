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

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone" bundle:nil];
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
        
        
//        UIImage* backImg = [UIImage imageNamed:@"back_nor.png"] ;
//        
//        if ([backImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
//            
//            backImg = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        }
//        
//        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithImage:backImg
//                                                                     style:UIBarButtonItemStylePlain
//                                                                    target:self
//                                                                    action:@selector(backClick:)];
//        
//        [backItem ios6cleanBackgroud];
//        
//        
//        [self.navigationItem setLeftBarButtonItem:backItem];

    }
    
    return self;
    
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
    _msgs = [[NSMutableArray alloc] initWithArray:[XAIUser readIM:_user.luid apsn:_user.apsn]];
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [_mobile startListene];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
    [_mobile stopListene];
    
    [super viewDidDisappear:animated];
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
    
    [XAIUser saveIM:_msgs luid:_user.luid apsn:_user.apsn];
    
    [_mobile sendMsg:_textField.text toApsn:_user.apsn toLuid:_user.luid];
    

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
    
    
}






#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _msgs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XAIMeg *amsg = [_msgs  objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [amsg.context sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height+44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = XAIChatCellID;
    XAIChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XAIChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    XAIMeg *aMsg = [_msgs objectAtIndex:indexPath.row];
    BOOL isMe = (aMsg.fromLuid == [MQTT shareMQTT].curUser.luid &&
                 aMsg.fromAPSN == [MQTT shareMQTT].curUser.apsn);
    [cell setContent:aMsg isfromeMe:isMe];
       
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)mobileControl:(XAIMobileControl *)mc sendStatus:(XAI_ERROR)err{

}

-(void)mobileControl:(XAIMobileControl *)mc newMsg:(XAIMeg *)msg{

    [_msgs addObject:msg];
    [self.tableView reloadData];
}

@end
