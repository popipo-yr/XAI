//
//  XAILightListCellID.m
//  XAI
//
//  Created by office on 14-8-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILightListCell.h"
#import "XAILightListVC.h"

@implementation _XAILightListVCCell

//- (void) setLightStatus:(XAILightStatus)lightStatus oprstatus:(XAIObjectOprStatus)status;{
//
//    if(status == XAILightStatus_Open){
//        [self setStatus:XAIOCST_Open];
//    }else if(status == XAILightStatus_Close){
//        [self setStatus:XAIOCST_Close];
//    }else{
//        [self setStatus:XAIOCST_Unkown];
//    }
//    
//    
//}

#pragma mark -- LightDelegate

#define LightOpenImg  @"obj_light_open.png"
#define LightCloseImg @"obj_light_close.png"

- (void) light:(XAILight *)light openSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [self showOprEnd];
        [self setStatus:XAIOCST_Open];
        
    }else{
    
        
        [self showMsg:@"打开失败"];
    }
    
    
}
- (void) light:(XAILight *)light closeSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [self showOprEnd];
        [self setStatus:XAIOCST_Close];
        
    }else{
        
        [self showMsg:@"关闭失败"];
    }
}

- (void) light:(XAILight *)light curStatus:(XAILightStatus)status{
    
    if (status == XAILightStatus_Open) {
        [self setStatus:XAIOCST_Open];
        [self.contextLable setText:[light.lastOpr allStr]];
    }else if (status == XAILightStatus_Close) {
        [self setStatus:XAIOCST_Close];
        [self.contextLable setText:[light.lastOpr allStr]];
    }else{
    
        [self setStatus:XAIOCST_Unkown];
    }
}


- (void) setInfo:(XAILight*)aObj{
    
    [self _removeWeakObj];
    
    if (aObj == nil) return;
    if (![aObj isKindOfClass:[XAILight class]] ){
        
        [self  firstStatus:XAIOCST_Unkown opr:XAIOCOT_None tip:nil];
        [self.tipImageView setBackgroundColor:[UIColor clearColor]];
        [self.tipImageView setImage:nil];
        [self.nameLable setText:nil];
        [self.contextLable setText:nil];
        [self.tipLabel setText:nil];
        
        return;
    }
    
    
    
    [self.tipImageView setBackgroundColor:[UIColor clearColor]];
    
    if (aObj.nickName != NULL && ![aObj.nickName isEqualToString:@""]) {
        
        [self.nameLable setText:aObj.nickName];
    }else{
        
        [self.nameLable setText:aObj.name];
    }
    
    [self.contextLable setText:[aObj.lastOpr allStr]];
    
    
    
    
    XAIOCST status = XAIOCST_Unkown;
    
    if (aObj.curDevStatus == XAILightStatus_Open) {
        
        status = XAIOCST_Open;
        
    }else if(aObj.curDevStatus == XAILightStatus_Close){
        status = XAIOCST_Close;
    }
    
    
    
    [self firstStatus:status opr:[self coverForm:aObj.curOprStatus] tip:aObj.curOprtip];
    
    
    [self _changeWeakObj:aObj];
    
}

- (void) _removeWeakObj{
    
    if (self.weakLight != nil && [self.weakLight isKindOfClass:[XAILight class]]) {
        ((XAILight*)self.weakLight).delegate = nil;
        self.weakLight = nil;
        
    }
}

- (void) _changeWeakObj:(XAILight*)aObj{
    
    [self _removeWeakObj];
    
    
    if ([aObj isKindOfClass:[XAILight class]]) {
        
        self.weakLight = aObj;
        ((XAILight*)self.weakLight).delegate = self;
        
    }
    
}



@end

@implementation XAILightListVCCell

@end

@implementation XAILightListVCChildCell

@end

@implementation XAILightListVCCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cTableView.dataSource = self;
        self.cTableView.delegate = self;
    }
    return self;
}

- (void) setDatas:(NSArray*)datas{
    
    [self.cTableView setScrollEnabled:false];
    _curInputCell = nil;
    
    _datas = [[NSArray alloc] initWithArray:datas];
    [self.cTableView reloadData];
    
    self.cTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (_xuxianView == nil) {
        
        float jianju = 100;
        
        _xuxianView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xuxian.png"]];
        CGRect bgFram = self.backView.frame;
        _xuxianView.frame = CGRectMake(bgFram.size.width*0.5f - jianju*0.5f,
                                       (bgFram.size.height - _xuxianView.frame.size.height)*0.5f,
                                       _xuxianView.frame.size.width,
                                       _xuxianView.frame.size.height);
        [self.backView insertSubview:_xuxianView atIndex:0];
        
        
        _xuxianView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xuxian.png"]];
        _xuxianView2.frame = CGRectMake(bgFram.size.width*0.5f + jianju*0.5f,
                                       (bgFram.size.height - _xuxianView2.frame.size.height)*0.5f,
                                       _xuxianView2.frame.size.width,
                                       _xuxianView2.frame.size.height);
        [self.backView insertSubview:_xuxianView2 atIndex:0];
        
    }
    

    _xuxianView.hidden = [datas count] > 1 ? false : true;

}

-(void)dealloc{

    for (XAILight* light in _datas) {
        if (![light isKindOfClass:[XAILight class]]) continue;
        light.delegate = nil;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    _cells = [[NSMutableArray alloc] init];
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_datas count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier2 = XAILightListCellChildID;
    
    
    XAILightListVCChildCell *cell = [tableView
                                dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell == nil) {
        cell = [[XAILightListVCChildCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier2];
    }
    
    XAILight* aObj = [_datas objectAtIndex:[indexPath row]];
    
    if (aObj != nil && [aObj isKindOfClass:[XAILight class]]) {
        
        [cell setInfo:aObj];
    }
    
    
    // Add utility buttons
    [cell setEditBtn];
    cell.delegate = self;
    
    //[cell setBackgroundColor:[UIColor greenColor]];
    [_cells addObject:cell];
    return cell;
    
    
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    
    //NSLog(@"%d",state);
    return;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            
            
            XAILightListVCChildCell* listCell = (XAILightListVCChildCell*)cell;
            if ([listCell isKindOfClass:[XAILightListVCChildCell class]]) {
                
                
                if ([self.topVC isSame:listCell]) {
                    if (listCell.input.text == nil || [listCell.input.text isEqualToString:@""]) {
                        
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:NSLocalizedString(@"DevNickNameNull", nil)
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"AlertOK", nil)
                                                              otherButtonTitles:nil];
                        
                        
                        [alert show];
                        return;
                        
                    }
                    
                    int index = [[self.cTableView indexPathForCell:cell] row];
                    if (index >= [_datas  count]) {
                        return;
                    }
                    XAIObject* obj = [_datas objectAtIndex:index];
                    
                    obj.nickName = listCell.input.text;
                    
                    [[XAIData shareData] upDateObj:obj];
                    
                    listCell.nameLable.text = listCell.input.text;
                    
                    
                    [self.topVC hiddenOldInput];
                    return;
                }

                
                [self.topVC changeInputCell:listCell input:listCell.input];
                
                listCell.input.enabled = true;
                listCell.input.hidden = false;
                [listCell.input becomeFirstResponder];
                
                [listCell setSaveBtn];
                
                _curInputCell = listCell;
            }

            break;
        }
        default:
            break;
    }
}



static bool _delShow = false;
static bool _changeShow = false;
static SWTableViewCell* _curSWCell;
-(void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell{
    
    _curSWCell = cell;
    if ( cell.cellState == kCellStateLeft) {
        _delShow = false;
        _changeShow = true;
    }else if( cell.cellState == kCellStateRight){
        
        _delShow = true;
        _changeShow = false;
        
    }else{
        
        _delShow = false;
        _changeShow = false;
    }
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    if ([self.topVC hasInput] == true) {
        return false;
    }
    
    if (self.cellState != kCellStateCenter) {
        return false;
    }
    
    if (cell != _curSWCell) {
        return true;
    }
    switch (state) {
        case kCellStateLeft:
            // set to NO to disable all left utility buttons appearing
            return _delShow == false ? true : false;
            break;
        case kCellStateRight:
            // set to NO to disable all right utility buttons appearing
            return false;
            break;
        default:
            break;
    }
    
    return YES;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    if (self.topVC) {
        [self.topVC willShowLeft:self];
    }
    
    return YES;
}

-(void)swipeableTableViewCellCancelEdit:(SWTableViewCell *)cell{
    
    [self.topVC hiddenOldInput];
}

- (BOOL) isallInCenter{

    for (XAILightListVCChildCell* cell in _cells){
        if ([cell isUtilityButtonsHidden] == false) {
            return false;
        }
    }
    
    return true;
}

- (void) hidenAll{

    for (XAILightListVCChildCell* cell in _cells){
        [cell hideUtilityButtonsAnimated:true];
    }
}

- (void) refreshOpr{

    for (XAILightListVCChildCell* cell in _cells){
        
        XAIObject* obj = [_datas objectAtIndex:[[self.cTableView indexPathForCell:cell] row]];
        
        [cell setInfo:obj];
    }
    
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 63.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    do {
        
        if ([indexPath row] >= [_datas count]) break;
        
        XAILight* aLight = [_datas objectAtIndex:[indexPath row]];
        if (![aLight isKindOfClass:[XAILight class]]) break;
        
        XAILightListVCChildCell* cell = (XAILightListVCChildCell*)[tableView
                                                                   cellForRowAtIndexPath:indexPath];
        if (![cell isKindOfClass:[XAILightListVCChildCell class]]) break;
        
        
        if(aLight.curDevStatus == XAILightStatus_Open){
            
            [aLight closeLight];
            [cell showOprStart:aLight.curOprtip];
            
            
        }else if(aLight.curDevStatus == XAILightStatus_Close){
            
            [aLight openLight];
            [cell showOprStart:aLight.curOprtip];
            
        }
        
        
    } while (0);
    
    
    
    return nil;
}

- (void) enableChild:(BOOL)bl{

    for (XAILightListVCChildCell* cell in _cells){
        [cell setEnable:bl];
    }
}


@end

