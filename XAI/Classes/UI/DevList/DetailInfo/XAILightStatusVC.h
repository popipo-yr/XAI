//
//  XAILightStatusVC.h
//  XAI
//
//  Created by office on 14-4-23.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevShowStatusVC.h"

#import "XAILight.h"

@interface XAILightStatusVC : XAIDevShowStatusVC <XAILigthtDelegate>{

    XAILight* _light;

}

@property (nonatomic,strong) XAILight* light;
@property (nonatomic,strong) IBOutlet UISwitch* switchUI;

- (IBAction)swithChoose:(id)sender;

@end
