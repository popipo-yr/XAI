//
//  XAILightStatusVC.h
//  XAI
//
//  Created by office on 14-4-23.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceShowStatusVC.h"

#import "XAILight.h"

@interface XAILightStatusVC : DeviceShowStatusVC <XAILigthtDelegate>{

    XAILight* _light;

}

@property (nonatomic,strong) XAILight* light;
@property (nonatomic,strong) IBOutlet UISwitch* switchUI;

- (IBAction)swithChoose:(id)sender;

@end
