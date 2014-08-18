//
//  XAILinkageAddNameVC.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageAddNameVC.h"
#import "XAILinkageAddInfoVC.h"

#define XAILinkageAddNameVCID @"XAILinkageAddNameVCID"

#define _ST_show_linkage_add @"show_linkage_add"

@implementation XAILinkageAddNameVC

+(UIViewController*)create{
    
    UIStoryboard* show_Storyboard = [UIStoryboard storyboardWithName:@"Linkage_iPhone" bundle:nil];
    UIViewController* vc = [show_Storyboard instantiateViewControllerWithIdentifier:_ST_show_linkage_add];
    //[vc changeIphoneStatusClear];
    return vc;
    
}

- (IBAction)btnClick:(id)sender{
    
    
    [_tf resignFirstResponder];

    NSString* text = _tf.text;
    
    
    XAILinkageAddInfoVC* vc = [XAILinkageAddInfoVC create];
    
    [vc setLinkageOneChoosetype:XAILinkageOneType_yuanyin];
    
    
    
    
    [self.navigationController pushViewController:vc animated:true];

}


@end
