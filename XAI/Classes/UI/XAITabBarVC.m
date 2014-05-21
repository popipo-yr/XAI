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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
	// Do any additional setup after loading the view.
    
    for(UITabBarItem *tbItem in [_xaitabBar items])
    {
        
        if (isIOS7) {
            
            
            
            if([tbItem respondsToSelector:@selector(setSelectedImage:)]){/*ios7 后使用的方法*/
                
                [tbItem setSelectedImage:[self imageForTabBarItem:[tbItem tag] selected:YES]];
                [tbItem setImage:[self imageForTabBarItem:[tbItem tag] selected:NO]];
                
            }
            
            
        }else{
        
            #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            [tbItem setFinishedSelectedImage:[self imageForTabBarItem:[tbItem tag] selected:YES]
                 withFinishedUnselectedImage:[self imageForTabBarItem:[tbItem tag] selected:NO]];
        }
    }
    
    if (!isIOS7) {

        [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:RGBA(245, 245, 245, 245) size:CGSizeMake(1, 49)]];
        
        
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_bar_selected.png"]];
    
    }
    
    
    if (isIOS7) {
        
        [[UINavigationBar appearance] setBarTintColor:
         [UIColor colorWithRed:255/256.0f green:91/256.0f blue:0 alpha:1]];
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
        view.backgroundColor=[UIColor whiteColor];
        
        [self.view addSubview:view];
        
    }else{
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:RGBA(255, 91, 0, 255)
                                                                            size:CGSizeMake(1, 44)]
                                           forBarMetrics:UIBarMetricsDefault];
        
    }
    
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
