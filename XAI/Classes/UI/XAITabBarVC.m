//
//  XAITabBarVC.m
//  XAI
//
//  Created by office on 14-4-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITabBarVC.h"

@interface XAITabBarVC ()

@end

@implementation XAITabBarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    for(UITabBarItem *tbItem in [_xaitabBar items])
    {
        if([tbItem respondsToSelector:@selector(setSelectedImage:)]){/*ios7 后使用的方法*/
            
            [tbItem setSelectedImage:[self imageForTabBarItem:[tbItem tag] selected:YES]];
            [tbItem setImage:[self imageForTabBarItem:[tbItem tag] selected:NO]];
            
        }else{
        
            //[tabBarItems addObject:tbItem];
            [tbItem setFinishedSelectedImage:[self imageForTabBarItem:[tbItem tag] selected:YES]
                 withFinishedUnselectedImage:[self imageForTabBarItem:[tbItem tag] selected:NO]];
        }
    }
    
     //self.tabBarItem.selectedImage = [UIImage imageNamed:name];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)imageForTabBarItem:(int)tab selected:(BOOL)selected
{
    NSString *imageName;
    switch(tab)
    {
        case 0:
            imageName = [NSString stringWithFormat:@"tab_bar_dev_%@.png", selected ? @"sel":@"nor"];
            break;
        case 1:
            imageName = [NSString stringWithFormat:@"tab_bar_devM_%@.png", selected ? @"sel":@"nor"];
            break;
        case 2:
            imageName = [NSString stringWithFormat:@"tab_bar_user_%@.png", selected ? @"sel":@"nor"];
            break;
        case 3:
            imageName = [NSString stringWithFormat:@"tab_bar_set_%@.png", selected ? @"sel":@"nor"];
            break;
    }
    
    UIImage* img = [UIImage imageNamed:imageName];
    
    if ([img respondsToSelector:@selector(imageWithRenderingMode:)]) {
        
       return  [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    return img;
  }

@end
