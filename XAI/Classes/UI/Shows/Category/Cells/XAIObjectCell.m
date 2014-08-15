//
//  XAIObjectCell.m
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"

@implementation XAIObjectCell

- (void) showStart{

    isShowErr = false;
    [self setBackgroundColor:[UIColor yellowColor]];
}
- (void) showClose{
    
    preType = XAIObjectCellShowType_Close;
    isShowErr = false;
    
    [self setBackgroundColor:[UIColor redColor]];
}
- (void) showOpen{
    
    preType = XAIObjectCellShowType_Open;
    isShowErr = false;
    
    [self setBackgroundColor:[UIColor greenColor]];
}

- (void) showUnkonw{

    preType = XAIObjectCellShowType_Unkown;
    isShowErr = false;
    
    [self setBackgroundColor:[UIColor blueColor]];
}

- (void) showError{
    
    isShowErr = true;
    [self performSelector:@selector(_changeToPre) withObject:nil afterDelay:3.0f];
    
    [self setBackgroundColor:[UIColor blackColor]];
}

- (void) setPreType:(XAIObjectCellShowType)type{

    preType = type;
}


- (void) _changeToPre{
    
    if (isShowErr == false) {
        return;
    }
    
    switch (preType) {
        case XAIObjectCellShowType_Open:
            [self showOpen];
            break;
        case XAIObjectCellShowType_Close:
            [self showClose];
            break;
        case XAIObjectCellShowType_Unkown:
            [self showUnkonw];
            break;
        default:
            break;
    }
}


@end
