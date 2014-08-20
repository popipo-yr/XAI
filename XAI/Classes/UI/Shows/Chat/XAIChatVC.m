//
//  ViewController.m
//  WeixinDeom
//
//  Created by iHope on 13-11-8.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import "XAIChatVC.h"

#define  XAIChatVCID @"XAIChatVCID"

@implementation XAIChatVC

+(UIViewController*) create{

    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Show_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:XAIChatVCID];
    [vc changeIphoneStatus];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"aaaaabbbbbbbbbbb",@"content", nil];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"hello",@"content", nil];
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"0",@"content", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"cccccccccccccc",@"content", nil];
//    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"0",@"content", nil];
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"ddddddddddddddd",@"content", nil];
    NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"2020202020202020203shfslfskksfllkjklsfljksdflksjdfl",@"content", nil];
    
    _resultArray = [NSMutableArray arrayWithObjects:dict,dict1,dict3,dict5,dict6,dict,dict1,dict3,dict5,dict6, nil];

    self.title = @"abc";
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    
    _oldMovePoint = CGPointMake(_moveView.center.x,_moveView.center.y);
    
    _textField.returnKeyType =  UIReturnKeyDone;
    
    
     [_textField addTarget:self action:@selector(chatInputReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
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

-(void)viewDidDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self];;

    [super viewDidDisappear:animated];
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

//    [_textField resignFirstResponder];
//    
//    // 添加移动动画，使视图跟随键盘移动
//    [UIView animateWithDuration:0.22 animations:^{
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationCurve:0.22];
//        
//        _moveView.center = _oldMovePoint;
//        // keyBoardEndY的坐标包括了状态栏的高度，要减去
//        
//    }];
    

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
    return _resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [[dict objectForKey:@"content"] sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
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
    
    NSMutableDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
    [cell setContent:dict];
       
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
